import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealty/widgets/foodpost/food_image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../widgets/foodpost/add_post_header.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  File? _imageFile;

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

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackrgound = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: onPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const AddPostHeader(
              title: 'Tambah Makanan',
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
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
                ],
              ),
            ),
            // Add the rest of your screen components here
          ],
        ),
      ),
    );
  }
}
