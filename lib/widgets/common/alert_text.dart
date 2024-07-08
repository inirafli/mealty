import 'package:flutter/material.dart';

class AlertText extends StatelessWidget {
  final String displayText;

  const AlertText({super.key, required this.displayText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 360.0,
        child: Text(
          displayText,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            color: Theme
                .of(context)
                .colorScheme
                .onBackground,
            height: 1.25
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}