import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthState { authorized, loading, unauthorized }

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
    } catch (e) {
      // Handle authentication errors
      print('Error signing in with email and password: $e');
    }
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      _authState = AuthState.loading;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Handle authentication errors
      print('Error signing up with email and password: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _authState = AuthState.loading;
      notifyListeners();
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      // Handle authentication errors
      print('Error signing in with Google: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle sign out errors
      print('Error signing out: $e');
    }
  }
}