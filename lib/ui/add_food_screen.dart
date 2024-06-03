import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(MdiIcons.arrowLeft),
                    iconSize: 20.0,
                    color: onBackrgound,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  const Spacer(),
                  Text(
                    'Tambah Makanan',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onBackrgound,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Container(width: 48),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: _imageFile == null
                            ? Container(
                                height: 240,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: const Center(
                                    child:
                                        Text('Belum ada Gambar yang dipilih.')),
                              )
                            : Image.file(
                                _imageFile!,
                                height: 240,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                      if (_imageFile != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                            child: CircleAvatar(
                              radius: 18.0,
                              backgroundColor: onPrimary,
                              child: Icon(
                                Icons.close,
                                size: 16.0,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _captureImageWithCamera,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: primary),
                              color: primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                bottomLeft: Radius.circular(12.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MdiIcons.cameraOutline,
                                    color: onPrimary, size: 18.0),
                                const SizedBox(width: 8),
                                Text(
                                  'Kamera',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickImageFromGallery,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: onPrimary,
                              border: Border.all(color: primary),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MdiIcons.imageSearchOutline,
                                    color: primary, size: 18.0),
                                const SizedBox(width: 8),
                                Text(
                                  'Galeri',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
            // Add the rest of your screen components here
          ],
        ),
      ),
    );
  }
}
