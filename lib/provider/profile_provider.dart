import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as user_auth;

import '../data/model/user.dart' as user_model;
import '../services/firestore_services.dart';

class ProfileProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  user_auth.User? _user;
  bool _isLoading = true;
  String? _errorMessage;
  user_model.User? _profile;

  ProfileProvider() {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        _fetchUserProfile();
      } else {
        _clearProfile();
      }
    });
  }

  user_model.User? get profile => _profile;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> _fetchUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_user != null) {
        _profile = await _firestoreService.getUser(_user!.uid);
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void _clearProfile() {
    _profile = null;
    notifyListeners();
  }

  int get totalCompletedFoodTypes {
    if (_profile != null) {
      return (_profile!.completedFoodTypes['drinks'] ?? 0) +
          (_profile!.completedFoodTypes['fruitsVeg'] ?? 0) +
          (_profile!.completedFoodTypes['snacks'] ?? 0) +
          (_profile!.completedFoodTypes['staple'] ?? 0);
    }
    return 0;
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
