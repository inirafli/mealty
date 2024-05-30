import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/food_provider.dart';

class CategoryFilterDialog extends StatelessWidget {
  const CategoryFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Kategori Makanan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Flexible(
            child: Consumer<FoodProvider>(
              builder: (context, foodProvider, child) {
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  shrinkWrap: true,
                  children: [
                    _CategoryItem(
                      image: 'images/all_type_category.webp',
                      text: 'Semua',
                      isSelected:
                          foodProvider.selectedCategories.contains('all'),
                      onTap: () =>
                          foodProvider.toggleCategorySelection('all'),
                    ),
                    _CategoryItem(
                      image: 'images/staple_category.webp',
                      text: 'Makanan',
                      isSelected: foodProvider.selectedCategories
                          .contains('staple'),
                      onTap: () =>
                          foodProvider.toggleCategorySelection('staple'),
                    ),
                    _CategoryItem(
                      image: 'images/drinks_category.webp',
                      text: 'Minuman',
                      isSelected:
                          foodProvider.selectedCategories.contains('drinks'),
                      onTap: () =>
                          foodProvider.toggleCategorySelection('drinks'),
                    ),
                    _CategoryItem(
                      image: 'images/snacks_category.webp',
                      text: 'Camilan',
                      isSelected:
                          foodProvider.selectedCategories.contains('snacks'),
                      onTap: () =>
                          foodProvider.toggleCategorySelection('snacks'),
                    ),
                    _CategoryItem(
                      image: 'images/fruits_category.webp',
                      text: 'Buah dan Sayur',
                      isSelected: foodProvider.selectedCategories
                          .contains('fruitsVeg'),
                      onTap: () =>
                          foodProvider.toggleCategorySelection('fruitsVeg'),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String image;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.image,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              width: double.infinity,
              color: Colors.transparent,
              padding: const EdgeInsets.all(10.0),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
