import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealty/common/auth_state.dart';
import 'package:mealty/utils/auth_error_handling.dart';

import '../services/firestore_services.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Completer<void> _initCompleter = Completer<void>();

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
      if (user == null) {
        _authState = AuthState.unauthorized;
      } else {
        _authState = AuthState.authorized;
        _ensureUserDocument(user);
      }
      notifyListeners();
    });
  }

  Future<void> get initializationComplete => _initCompleter.future;

  AuthState _authState = AuthState.unauthorized;

  AuthState get authState => _authState;

  User? get user => _auth.currentUser;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<void> signInWithEmailPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan kata sandi tidak boleh kosong.';
      _authState = AuthState.error;
      notifyListeners();
      return;
    }

    try {
      _authState = AuthState.loading;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _authState = AuthState.authorized;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = AuthErrorHandler.parseError(e.code);
      _authState = AuthState.error;
      notifyListeners();
    }
  }

  Future<void> createUserWithEmailPassword(
      String email, String password, String displayName) async {
    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      _errorMessage = 'Email, username, dan kata sandi tidak boleh kosong.';
      _authState = AuthState.error;
      notifyListeners();
      return;
    }

    try {
      _authState = AuthState.loading;
      notifyListeners();

      bool isUsernameTaken = await _firestoreService.isUsernameUnique(displayName);
      if (isUsernameTaken) {
        _errorMessage = 'Username telah digunakan. Coba yang lain.';
        _authState = AuthState.error;
        notifyListeners();
        return;
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': displayName,
          'email': user.email ?? '',
          'phoneNumber': user.phoneNumber ?? '',
          'photoUrl': user.photoURL ?? '',
          'address': const GeoPoint(0, 0),
          'starRating': 0,
          'countRating': 0,
          'purchases': [],
          'sales': [],
          'pendingOrders': [],
          'postedFoods': [],
          'completedFoodTypes': {
            'staple': 0,
            'drinks': 0,
            'snacks': 0,
            'fruitsVeg': 0,
          },
        });

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .add({});
      }

      _authState = AuthState.registered;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = AuthErrorHandler.parseError(e.code);
      _authState = AuthState.error;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _authState = AuthState.loading;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _errorMessage = 'Pilih akun Google-mu untuk masuk dengan Google.';
        _authState = AuthState.error;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      await _ensureUserDocument(_auth.currentUser!);

      _authState = AuthState.authorized;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = AuthErrorHandler.parseError(e.code);
      _authState = AuthState.error;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      _authState = AuthState.unauthorized;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'An unknown error occurred';
      _authState = AuthState.error;
      notifyListeners();
    }
  }

  Future<void> _ensureUserDocument(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final doc = await userDoc.get();
    if (!doc.exists) {
      await userDoc.set({
        'username': user.displayName ?? '',
        'email': user.email ?? '',
        'phoneNumber': user.phoneNumber ?? '',
        'photoUrl': user.photoURL ?? '',
        'address': const GeoPoint(0, 0),
        'starRating': 0,
        'countRating': 0,
        'purchases': [],
        'sales': [],
        'pendingOrders': [],
        'postedFoods': [],
        'completedFoodTypes': {
          'staple': 0,
          'drinks': 0,
          'snacks': 0,
          'fruitsVeg': 0,
        },
      });

      await userDoc.collection('cart').add({});
    }
  }
}
