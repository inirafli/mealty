import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealty/widgets/foodpost/food_image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../widgets/foodpost/add_post_header.dart';
import '../widgets/foodpost/food_price_input.dart';
import '../widgets/foodpost/food_text_field.dart';
import '../widgets/foodpost/food_type_selector.dart';
import '../widgets/foodpost/sale_time_input.dart';
import '../widgets/foodpost/selling_type_selector.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: '0');
  final TextEditingController _saleTimeController = TextEditingController();
  String _selectedFoodCategory = '';
  String _selectedSellingType = '';
  DateTime? _saleTime;
  File? _imageFile;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _saleTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    if (await _requestPermission(Permission.storage)) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _captureImageWithCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  void _handleSelectSellingType(String type) {
    setState(() {
      _selectedSellingType = type;
      if (type == 'sharing') {
        _priceController.text = '0';
      }
    });
  }

  void _handleSelectSaleTime(DateTime dateTime) {
    setState(() {
      _saleTime = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: onPrimary,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FoodImagePicker(
                        imageFile: _imageFile,
                        onImageRemove: () {
                          setState(() {
                            _imageFile = null;
                          });
                        },
                        onPickImageFromGallery: _pickImageFromGallery,
                        onCaptureImageWithCamera: _captureImageWithCamera,
                      ),
                      const SizedBox(height: 24.0),
                      FoodTextFields(
                        nameController: _nameController,
                        descriptionController: _descriptionController,
                      ),
                      const SizedBox(height: 24.0),
                      FoodTypeSelector(
                        selectedType: _selectedFoodCategory,
                        onSelectType: (type) {
                          setState(() {
                            _selectedFoodCategory = type;
                          });
                        },
                      ),
                      const SizedBox(height: 24.0),
                      SellingTypeSelector(
                        selectedType: _selectedSellingType,
                        onSelectType: _handleSelectSellingType,
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        children: [
                          Expanded(
                            child: PriceInput(
                              controller: _priceController,
                              isEditable: _selectedSellingType == 'commercial',
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: SaleTimeInput(
                              controller: _saleTimeController,
                              onSelectDateTime: _handleSelectSaleTime,
                              initialDateTime: _saleTime,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      // Add the rest of your screen components here
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AddPostHeader(
              title: 'Tambah Makanan',
            ),
          ),
        ],
      ),
    );
  }
}
