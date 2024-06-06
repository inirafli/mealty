import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class AddFoodProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController =
      TextEditingController(text: '0');
  final TextEditingController saleTimeController = TextEditingController();

  String _selectedFoodCategory = '';
  String _selectedSellingType = '';
  DateTime? _saleTime;
  double? _latitude;
  double? _longitude;
  File? _imageFile;

  String get selectedFoodCategory => _selectedFoodCategory;

  String get selectedSellingType => _selectedSellingType;

  DateTime? get saleTime => _saleTime;

  double? get latitude => _latitude;

  double? get longitude => _longitude;

  File? get imageFile => _imageFile;

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
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        notifyListeners();
      }
    }
  }

  Future<void> captureImageWithCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    saleTimeController.dispose();
    super.dispose();
  }

  Future<void> addFoodPost() async {
    // Implement the logic to add a food post to Firebase Storage and Firestore.
  }
}
