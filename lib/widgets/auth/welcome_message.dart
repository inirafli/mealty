import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  final String firstText;

  const WelcomeMessage({super.key, required this.firstText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          children: [
            TextSpan(
              text: firstText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextSpan(
              text: 'Mealty.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
