import 'package:flutter/material.dart';

import '../services/firestore_services.dart';

class PostProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  List<String> _selectedCategories = ['all'];
  String _selectedSortType = 'timeLeft';

  List<String> get selectedCategories => _selectedCategories;

  String get selectedSortType => _selectedSortType;

  List<Map<String, dynamic>> get posts => _posts;

  bool get isLoading => _isLoading;

  PostProvider() {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    _posts = await _firestoreService.getFoodPosts();
    for (var post in _posts) {
      var userData = await _firestoreService.getUser(post['userId']);
      post['username'] = userData['username'];
      post['starRating'] = userData['starRating'];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  void toggleCategorySelection(String category) {
    if (category == 'all') {
      _selectedCategories = ['all'];
    } else {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }

      if (_selectedCategories.isEmpty) {
        _selectedCategories = ['all'];
      } else {
        _selectedCategories.remove('all');
      }
    }
    notifyListeners();
  }

  void toggleSortSelection(String sortType) {
    _selectedSortType = sortType;
    notifyListeners();
  }
}
