import 'package:flutter/material.dart';

import '../../data/model/food_post.dart';

class NameDescWidget extends StatelessWidget {
  final FoodPost post;

  const NameDescWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.0,
                color: primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          post.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
