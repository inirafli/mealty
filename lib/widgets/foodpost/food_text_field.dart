import 'package:flutter/material.dart';

class FoodTextFields extends StatelessWidget {
  const FoodTextFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.w600,
        );

    final hintStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.w400,
        );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: onPrimary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: primary,
          width: 0.75,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: primary,
          width: 1.0,
        ),
      ),
    );

    Widget buildTextField({
      required String label,
      required TextEditingController controller,
      required String hintText,
      double height = 44.0,
      int maxLines = 1,
      EdgeInsetsGeometry contentPadding =
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.5),
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: height,
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: inputDecoration.copyWith(
                hintText: hintText,
                hintStyle: hintStyle,
                contentPadding: contentPadding,
              ),
              style: textStyle,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextField(
          label: 'Nama Makanan',
          controller: nameController,
          hintText: 'Masukan judul post makanan-mu.',
        ),
        const SizedBox(height: 16),
        buildTextField(
          label: 'Deskripsi Makanan',
          controller: descriptionController,
          hintText: 'Masukan deskripsi post makanan-mu.',
          height: 124,
          maxLines: 5,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ],
    );
  }
}
