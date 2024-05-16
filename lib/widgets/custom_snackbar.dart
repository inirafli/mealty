import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String contentText,
    required BuildContext context,
  }) : super(
          content: Text(
            contentText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        );
}
