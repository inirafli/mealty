import 'package:flutter/material.dart';
import 'package:mealty/utils/data_conversion.dart';

import '../../data/model/food_post.dart';

class PriceTypeWidget extends StatelessWidget {
  final FoodPost post;

  const PriceTypeWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatPrice(post.price),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: primary,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 16.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Container(
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
              post.sellingType == 'sharing' ? 'Berbagi' : 'Komersil',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
