import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as user_auth;

import '../data/model/food.dart';
import '../data/model/user.dart' as user_model;
import '../services/firestore_services.dart';

class ProfileProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  user_auth.User? _user;
  bool _isLoading = true;
  String? _message;
  user_model.User? _profile;
  List<Food> _userFoodPosts = [];
  String _foodFilter = 'publishedFoods';

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

  String? get message => _message;

  String get foodFilter => _foodFilter;

  List<Food> get userFoodPosts => _userFoodPosts;

  Future<void> _fetchUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_user != null) {
        _profile = await _firestoreService.getUser(_user!.uid);
        if (_profile != null) {
          await _fetchUserFoodPosts();
        }
      }
    } catch (e) {
      _message = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchUserFoodPosts() async {
    if (_profile == null || _profile!.postedFoods.isEmpty) return;

    try {
      _userFoodPosts = [];
      for (String foodId in _profile!.postedFoods) {
        DocumentSnapshot? foodDoc =
            await _firestoreService.getFoodPostById(foodId);
        if (foodDoc != null) {
          Food foodPost = Food.fromFirestore(foodDoc);
          _userFoodPosts.add(foodPost);
        }
      }
      _userFoodPosts.sort((a, b) => b.publishedDate
          .compareTo(a.publishedDate)); // Sort by latest publishedDate
    } catch (e) {
      _message = e.toString();
    }
  }

  Future<void> refreshUserFoodPosts() async {
    await _fetchUserProfile();
  }

  Future<void> archiveFoodPost(String foodId) async {
    await _firestoreService.updateFoodPostStatus(foodId, 'archived');
    _message = 'Makanan telah berhasil diarsip';
    await _fetchUserFoodPosts();
    notifyListeners();
  }

  Future<void> unarchiveFoodPost(String foodId) async {
    await _firestoreService.updateFoodPostStatus(foodId, 'published');
    _message = 'Makanan telah berhasil diunggah';
    await _fetchUserFoodPosts();
    notifyListeners();
  }

  void _clearProfile() {
    _profile = null;
    _userFoodPosts = [];
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

  void clearMessage() {
    _message = null;
    notifyListeners();
  }

  void setFoodFilter(String filter) {
    _foodFilter = filter;
    notifyListeners();
  }

  List<Food> get filteredUserFoodPosts {
    switch (_foodFilter) {
      case 'emptyStock':
        return _userFoodPosts.where((food) => food.stock == 0).toList();
      case 'exceededSaleTime':
        return _userFoodPosts
            .where((food) => food.saleTime.toDate().isBefore(DateTime.now()))
            .toList();
      case 'archivedFoods':
        return _userFoodPosts
            .where((food) => food.status == 'archived')
            .toList();
      case 'publishedFoods':
      default:
      return _userFoodPosts
          .where((food) => food.status == 'published')
          .toList();
    }
  }
}
