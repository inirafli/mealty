import 'package:flutter/material.dart';
import 'dart:io';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FoodImagePicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onImageRemove;
  final VoidCallback onPickImageFromGallery;
  final VoidCallback onCaptureImageWithCamera;

  const FoodImagePicker({
    super.key,
    required this.imageFile,
    required this.onImageRemove,
    required this.onPickImageFromGallery,
    required this.onCaptureImageWithCamera,
  });

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: imageFile == null
                  ? Container(
                      height: 240,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Text('Belum ada Gambar yang dipilih.')),
                    )
                  : Image.file(
                      imageFile!,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            if (imageFile != null)
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: onImageRemove,
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundColor: onPrimary,
                    child: Icon(
                      Icons.close,
                      size: 18.0,
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
                onTap: onCaptureImageWithCamera,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.5),
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
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                onTap: onPickImageFromGallery,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.5),
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
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }
}
