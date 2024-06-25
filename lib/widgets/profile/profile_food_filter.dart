import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';

class FoodFilterWidget extends StatelessWidget {
  const FoodFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final onBackground = Theme.of(context).colorScheme.onBackground;
    final profileProvider = Provider.of<ProfileProvider>(context);
    final filter = profileProvider.foodFilter;

    final filters = {
      'all': 'Semua',
      'emptyStock': 'Stok Habis',
      'exceededSaleTime': 'Waktu Habis',
      'sharingType': 'Tipe Berbagi',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = entry.key == filter;
          return GestureDetector(
            onTap: () => profileProvider.setFoodFilter(entry.key),
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected ? onBackground : onPrimary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                entry.value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? onPrimary : onBackground,
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
