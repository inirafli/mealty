import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const CustomProgressIndicator({
    super.key,
    required this.color,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}
