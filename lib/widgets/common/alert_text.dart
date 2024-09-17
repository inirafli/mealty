import 'package:flutter/material.dart';

class AlertText extends StatelessWidget {
  final String displayText;

  const AlertText({super.key, required this.displayText});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double alertWidth = screenWidth * 0.8;

    return Center(
      child: SizedBox(
        width: alertWidth,
        child: Text(
          displayText,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            height: 1.25,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
