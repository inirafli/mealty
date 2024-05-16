import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthState { authorized, loading, unauthorized, registered, unregistered }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthState _authState = AuthState.unauthorized;
  AuthState get authState => _authState;

  User? get user => _auth.currentUser;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _authState = AuthState.authorized;
      } else {
        _authState = AuthState.unauthorized;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      _authState = AuthState.loading;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _authState = AuthState.authorized;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      print('Error signing in with email and password: ${e.message}');
      _authState = AuthState.unauthorized;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmailPassword(String email, String password, String displayName) async {
    try {
      _authState = AuthState.loading;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload();
      _authState = AuthState.registered;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      print('Error signing up with email and password: ${e.message}');
      _authState = AuthState.unregistered;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _authState = AuthState.loading;
      notifyListeners();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _authState = AuthState.authorized;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      print('Error signing in with Google: ${e.message}');
      _authState = AuthState.unauthorized;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _authState = AuthState.unauthorized;
      notifyListeners();
    } catch (e) {
      // Handle sign out errors generically
      print('Error signing out: $e');
    }
  }
}