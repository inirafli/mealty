import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as user_auth;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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
  File? _profileImageFile;

  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  double? _latitude;
  double? _longitude;

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

  File? get profileImageFile => _profileImageFile;

  double? get latitude => _latitude;

  double? get longitude => _longitude;

  Future<void> _fetchUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_user != null) {
        _profile = await _firestoreService.getUser(_user!.uid);
        if (_profile != null) {
          await _fetchUserFoodPosts();

          usernameController.text = _profile!.username;
          phoneNumberController.text = _profile!.phoneNumber;
          _latitude = _profile!.address.latitude;
          print('ProfileProvider: latitude $_latitude');
          _longitude = _profile!.address.longitude;
          print('ProfileProvider: longitude $_longitude');
        }
      }
    } catch (e) {
      _message = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    if (await requestPermission(Permission.storage)) {
      final pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (pickedFile != null) {
        _profileImageFile = File(pickedFile.path);
        notifyListeners();
      }
    }
  }

  void setLocation(Map<String, double> location) {
    _latitude = location['latitude'];
    _longitude = location['longitude'];
    notifyListeners();
  }

  Future<bool> isUsernameUnique(String username) async {
    return await _firestoreService.isUsernameUnique(username);
  }

  Future<void> updateProfile() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      if (_user == null) throw 'User not authenticated';

      // Check if username is unique
      if (usernameController.text != _profile!.username) {
        bool isUnique = await isUsernameUnique(usernameController.text);
        if (!isUnique) {
          throw 'Username is already taken';
        }
      }

      // Upload new profile image if picked
      String? profileImageUrl;
      if (_profileImageFile != null) {
        String fileName =
            'profile-${usernameController.text}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}';
        Reference storageRef =
            FirebaseStorage.instance.ref().child('profiles').child(fileName);
        UploadTask uploadTask = storageRef.putFile(_profileImageFile!);
        TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => {});
        profileImageUrl = await storageSnapshot.ref.getDownloadURL();

        // Delete old profile image if exists
        // if (_profile!.photoUrl != null && _profile!.photoUrl!.isNotEmpty) {
        //   FirebaseStorage.instance.refFromURL(_profile!.photoUrl!).delete();
        // }
      }

      // Update Firestore
      Map<String, dynamic> updatedData = {
        'username': usernameController.text,
        'phoneNumber': phoneNumberController.text,
        'address': GeoPoint(_latitude ?? 0, _longitude ?? 0),
      };
      if (profileImageUrl != null) {
        updatedData['profileImageUrl'] = profileImageUrl;
      }

      await _firestoreService.updateUserProfile(_user!.uid, updatedData);
      _message = 'Profile updated successfully';
      await _fetchUserProfile();
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
    usernameController.clear();
    phoneNumberController.clear();
    _profileImageFile = null;
    _latitude = null;
    _longitude = null;
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

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }
}
