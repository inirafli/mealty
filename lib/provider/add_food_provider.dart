import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../common/post_state.dart';

class AddFoodProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController =
      TextEditingController(text: '0');
  final TextEditingController stockController = TextEditingController();
  final TextEditingController saleTimeController = TextEditingController();

  String _selectedFoodCategory = '';
  String _selectedSellingType = '';
  DateTime? _saleTime;
  double? _latitude;
  double? _longitude;
  File? _imageFile;
  PostState _postState = PostState.initial();
  bool _isLoading = false;

  String get selectedFoodCategory => _selectedFoodCategory;

  String get selectedSellingType => _selectedSellingType;

  DateTime? get saleTime => _saleTime;

  double? get latitude => _latitude;

  double? get longitude => _longitude;

  File? get imageFile => _imageFile;

  PostState get postState => _postState;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void selectFoodCategory(String category) {
    _selectedFoodCategory = category;
    notifyListeners();
  }

  void selectSellingType(String type) {
    _selectedSellingType = type;
    if (type == 'sharing') {
      priceController.text = '0';
    }
    notifyListeners();
  }

  void selectSaleTime(DateTime dateTime) {
    _saleTime = dateTime;
    notifyListeners();
  }

  void setLocation(Map<String, double> location) {
    _latitude = location['latitude'];
    _longitude = location['longitude'];
    notifyListeners();
  }

  void setImage(File image) {
    _imageFile = image;
    notifyListeners();
  }

  void removeImage() {
    _imageFile = null;
    notifyListeners();
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  Future<void> pickImageFromGallery() async {
    if (await requestPermission(Permission.storage)) {
      _postState = PostState.loadingCompress();
      notifyListeners();
      final pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        if (await imageFile.length() > 8 * 1024 * 1024) {
          _postState =
              PostState.errorCompress('Ukuran Gambar melebihi batas 8 MB.');
          notifyListeners();
        } else {
          setImage(imageFile);
          _postState = PostState.initial();
          notifyListeners();
        }
      } else {
        _postState = PostState.initial();
        notifyListeners();
      }
    }
  }

  Future<void> captureImageWithCamera() async {
    _postState = PostState.loadingCompress();
    notifyListeners();
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 85);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (await imageFile.length() > 8 * 1024 * 1024) {
        _postState =
            PostState.errorCompress('Ukuran Gambar melebihi batas 8 MB.');
        notifyListeners();
      } else {
        setImage(imageFile);
        _postState = PostState.initial();
        notifyListeners();
      }
    } else {
      _postState = PostState.initial();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    saleTimeController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> addFoodPost() async {
    // Checking for null fields
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        _selectedFoodCategory.isEmpty ||
        _selectedSellingType.isEmpty ||
        _saleTime == null ||
        _latitude == null ||
        _longitude == null ||
        _imageFile == null) {
      _postState = PostState.error('Pastikan semua Field(s) telah terisi.');
      notifyListeners();
      return;
    }

    _postState = PostState.loading();
    notifyListeners();

    try {
      String formattedDate =
      DateFormat('yyyyMMddHHmmss').format(DateTime.now());

      // Upload image to Firebase Storage
      String fileName = 'foods-$formattedDate';
      Reference storageRef =
      FirebaseStorage.instance.ref().child('foods').child(fileName);
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await storageSnapshot.ref.getDownloadURL();

      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _postState = PostState.error('User not authenticated');
        notifyListeners();
        return;
      }

      // Create a new document in Firestore
      DocumentReference newPostRef = FirebaseFirestore.instance
          .collection('foods')
          .doc('posts-$formattedDate');
      await newPostRef.set({
        'category': _selectedFoodCategory,
        'description': descriptionController.text,
        'image': downloadUrl,
        'location': GeoPoint(_latitude!, _longitude!),
        'name': nameController.text,
        'price': int.parse(priceController.text),
        'stock': int.parse(stockController.text),
        'publishedDate': Timestamp.now(),
        'saleTime': Timestamp.fromDate(_saleTime!),
        'sellingType': _selectedSellingType,
        'userId': user.uid,
      });

      // Add the new post ID to the user's postedFoods field
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'postedFoods': FieldValue.arrayUnion([newPostRef.id])
      });

      _postState = PostState.success();
    } catch (e) {
      _postState = PostState.error(e.toString());
    }

    notifyListeners();
  }

  void initializeData({Map<String, dynamic>? foodData}) {
    setLoading(true);
    if (foodData != null) {
      nameController.text = foodData['name'];
      descriptionController.text = foodData['description'];
      priceController.text = foodData['price'].toString();
      stockController.text = foodData['stock'].toString();
      saleTimeController.text = DateFormat.yMMMMd('en_US').add_jms().format((foodData['saleTime'] as Timestamp).toDate());
      _selectedFoodCategory = foodData['category'];
      _selectedSellingType = foodData['sellingType'];
      _saleTime = (foodData['saleTime'] as Timestamp).toDate();
      _latitude = foodData['location'].latitude;
      _longitude = foodData['location'].longitude;
      // Handle setting the image if necessary
    } else {
      // Reset to initial state if no foodData provided
      nameController.clear();
      descriptionController.clear();
      priceController.text = '0';
      stockController.clear();
      saleTimeController.clear();
      _selectedFoodCategory = '';
      _selectedSellingType = '';
      _saleTime = null;
      _latitude = null;
      _longitude = null;
      _imageFile = null;
      _postState = PostState.initial();
    }
    setLoading(false);
  }

  Future<void> updateFoodPost(String postId) async {
    // Implement update logic here
  }
}
