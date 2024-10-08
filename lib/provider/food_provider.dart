import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mealty/utils/fake_data_generator.dart';

import '../data/model/food_post.dart';
import '../data/model/food_review.dart';
import '../services/firestore_services.dart';

class FoodProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final Location _location = Location();
  List<FoodPost> _posts = [];
  List<FoodPost> _filteredPosts = [];
  FoodPost? _selectedPost;
  List<FoodReview> _reviews = [];
  bool _isLoading = true;
  bool _isDetailLoading = true;

  List<String> _selectedCategories = ['all'];
  String _selectedSortType = 'latestPost';
  String _searchKeyword = '';

  List<String> get selectedCategories => _selectedCategories;

  String get selectedSortType => _selectedSortType;

  String get searchKeyword => _searchKeyword;

  List<FoodPost> get posts => _filteredPosts;

  List<FoodReview> get reviews => _reviews;

  bool get isLoading => _isLoading;

  FoodPost? get selectedPost => _selectedPost;

  bool get isDetailLoading => _isDetailLoading;

  FoodProvider() {
    _checkLocationServices();
  }

  Future<void> _checkLocationServices() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    final LocationData userLocation = await Future.any([
      _location.getLocation(),
      Future.delayed(const Duration(seconds: 2), () => _location.getLocation()),
    ]);

    final GeoPoint userGeoPoint =
        GeoPoint(userLocation.latitude!, userLocation.longitude!);

    final foodDocs = await _firestoreService.getFoodPosts();
    final futures = foodDocs.map((doc) async {
      final userData = await _firestoreService.getUser(doc['userId']);
      return FoodPost.fromFirestore(doc, userData, userGeoPoint);
    });
    _posts = await Future.wait(futures);
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPostById(String id) async {
    _isDetailLoading = true;
    _selectedPost = FakeDataGenerator.generatePlaceholderPost();
    notifyListeners();

    final LocationData userLocation = await _location.getLocation();
    final GeoPoint userGeoPoint =
        GeoPoint(userLocation.latitude!, userLocation.longitude!);

    final doc = await _firestoreService.getFoodPostById(id);
    if (doc != null) {
      final userData = await _firestoreService.getUser(doc['userId']);
      _selectedPost = FoodPost.fromFirestore(doc, userData, userGeoPoint);
      _reviews = await _firestoreService.getFoodReviews(id);
    } else {
      _selectedPost = null;
    }
    _isDetailLoading = false;
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

  void updateSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    _applyFilters();
  }

  void _applyFilters() {
    List<FoodPost> availablePosts = [];
    List<FoodPost> unavailablePosts = [];

    for (var post in _posts) {
      if (post.stock > 0 && post.saleTime.toDate().isAfter(DateTime.now())) {
        availablePosts.add(post);
      } else {
        unavailablePosts.add(post);
      }
    }

    availablePosts = _applyCategoryAndSearchFilters(availablePosts);
    unavailablePosts = _applyCategoryAndSearchFilters(unavailablePosts);

    _sortPosts(availablePosts);
    _sortPosts(unavailablePosts);

    _filteredPosts = [
      ...availablePosts,
      ...unavailablePosts,
    ];

    notifyListeners();
  }

  List<FoodPost> _applyCategoryAndSearchFilters(List<FoodPost> posts) {
    return posts.where((post) {
      if (_selectedCategories.contains('all')) return true;
      return _selectedCategories.contains(post.category);
    }).where((post) {
      if (_searchKeyword.isEmpty) return true;
      return post.name.toLowerCase().contains(_searchKeyword.toLowerCase());
    }).toList();
  }

  void _sortPosts(List<FoodPost> posts) {
    switch (_selectedSortType) {
      case 'latestPost':
        posts.sort((a, b) {
          return b.publishedDate.compareTo(a.publishedDate);
        });
        break;
      case 'nearestLocation':
        posts.sort((a, b) {
          return a.distance.compareTo(b.distance);
        });
        break;
      case 'cheapestPrice':
        posts.sort((a, b) {
          return a.price.compareTo(b.price);
        });
        break;
      case 'timeLeft':
        posts.sort((a, b) {
          return a.saleTime.compareTo(b.saleTime);
        });
        break;
      default:
        break;
    }
  }
}
