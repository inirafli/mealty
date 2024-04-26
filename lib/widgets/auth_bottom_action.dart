import 'package:flutter/material.dart';

class FormActionRow extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const FormActionRow({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 6.0),
        TextButton(
          onPressed: onButtonPressed,
          style: TextButton.styleFrom(
            minimumSize: Size.zero, // Set this
            padding: EdgeInsets.zero, // and this
          ),
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
