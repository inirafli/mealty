import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

class ImageFullScreenView extends StatelessWidget {
  final String imageUrl;

  const ImageFullScreenView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
