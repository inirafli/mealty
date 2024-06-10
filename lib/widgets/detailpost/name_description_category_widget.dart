import 'package:flutter/material.dart';

import '../../data/model/food_post.dart';

class NameDescriptionCategoryWidget extends StatelessWidget {
  final FoodPost post;

  const NameDescriptionCategoryWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

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
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6.5,
            horizontal: 12.0,
          ),
          decoration: BoxDecoration(
            color: onPrimary,
            border: Border.all(color: primary, width: 1.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            {
                  'snacks': 'Camilan',
                  'staple': 'Makanan',
                  'drinks': 'Minuman',
                  'fruitsVeg': 'Buah dan Sayur',
                }[post.category] ??
                post.category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
