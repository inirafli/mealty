import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../data/model/food_post.dart';

class CategoryStockWidget extends StatelessWidget {
  final FoodPost post;

  const CategoryStockWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Row(
      children: [
        // Category Container
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: onPrimary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 96.0,
                  child: Image.asset(
                    {
                      'staple': 'images/staple_category.webp',
                      'snacks': 'images/snacks_category.webp',
                      'fruitsVeg': 'images/fruits_category.webp',
                      'drinks': 'images/drinks_category.webp',
                    }[post.category]!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Kategori',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: primary,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  {
                        'snacks': 'Camilan',
                        'staple': 'Makanan',
                        'drinks': 'Minuman',
                        'fruitsVeg': 'Buah dan Sayur',
                      }[post.category] ??
                      post.category,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15.0,
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: onPrimary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 96.0,
                  child: Icon(
                    MdiIcons.packageVariant,
                    color: Theme.of(context).colorScheme.primary,
                    size: 64.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Stok Tersisa',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: primary,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${post.stock}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15.0,
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
