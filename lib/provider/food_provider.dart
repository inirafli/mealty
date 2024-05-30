import 'package:flutter/material.dart';

import '../services/firestore_services.dart';
import '../utils/data_conversion.dart';

class FoodProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _filteredPosts = [];
  bool _isLoading = true;

  List<String> _selectedCategories = ['all'];
  String _selectedSortType = 'latestPost';

  List<String> get selectedCategories => _selectedCategories;

  String get selectedSortType => _selectedSortType;

  List<Map<String, dynamic>> get posts => _filteredPosts;

  bool get isLoading => _isLoading;

  FoodProvider() {
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
    _filteredPosts = _posts;
    _applyFilters();
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
    _applyFilters();
  }

  void toggleSortSelection(String sortType) {
    _selectedSortType = sortType;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredPosts = _posts.where((post) {
      if (_selectedCategories.contains('all')) return true;
      return _selectedCategories.contains(post['category']);
    }).toList();

    _sortPosts();
    notifyListeners();
  }

  void _sortPosts() {
    switch (_selectedSortType) {
      case 'latestPost':
        _filteredPosts.sort((a, b) {
          return b['publishedDate'].compareTo(a['publishedDate']);
        });
        break;
      case 'nearestLocation':
        _filteredPosts.sort((a, b) {
          return calculateDistance(a['location'])
              .compareTo(calculateDistance(b['location']));
        });
        break;
      case 'cheapestPrice':
        _filteredPosts.sort((a, b) {
          return a['price'].compareTo(b['price']);
        });
        break;
      case 'timeLeft':
        _filteredPosts.sort((a, b) {
          return a['saleTime'].compareTo(b['saleTime']);
        });
        break;
      default:
        break;
    }
  }
}
