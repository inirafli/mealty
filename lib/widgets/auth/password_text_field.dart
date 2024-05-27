import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback togglePasswordVisibility;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kata Sandi',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            hintText: 'Masukkan Kata Sandi-mu',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w500,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.65),
                  width: 2.0),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                size: 18.0,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
              onPressed: togglePasswordVisibility,
            ),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }
}
