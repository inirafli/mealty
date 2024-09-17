import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mealty/provider/food_provider.dart';
import 'package:provider/provider.dart';

class SortFilterDialog extends StatelessWidget {
  const SortFilterDialog({super.key});

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
                'Urutkan Berdasarkan',
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
          Consumer<FoodProvider>(
            builder: (context, foodProvider, child) {
              return Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  _SortOption(
                    icon: MdiIcons.fire,
                    iconSize: 21.0,
                    text: 'Terbaru',
                    isSelected: foodProvider.selectedSortType == 'latestPost',
                    onTap: () => foodProvider.toggleSortSelection('latestPost'),
                  ),
                  _SortOption(
                    icon: MdiIcons.storeMarkerOutline,
                    iconSize: 21.0,
                    text: 'Lokasi Terdekat',
                    isSelected:
                        foodProvider.selectedSortType == 'nearestLocation',
                    onTap: () =>
                        foodProvider.toggleSortSelection('nearestLocation'),
                  ),
                  _SortOption(
                    icon: MdiIcons.cashCheck,
                    iconSize: 23.0,
                    text: 'Harga Termurah',
                    isSelected:
                        foodProvider.selectedSortType == 'cheapestPrice',
                    onTap: () =>
                        foodProvider.toggleSortSelection('cheapestPrice'),
                  ),
                  _SortOption(
                    icon: MdiIcons.storeClockOutline,
                    iconSize: 18.5,
                    text: 'Waktu Tersisa',
                    isSelected: foodProvider.selectedSortType == 'timeLeft',
                    onTap: () => foodProvider.toggleSortSelection('timeLeft'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.iconSize,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.0,
        padding: const EdgeInsets.only(left: 14.0, right: 16.0, top: 6.0, bottom: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                size: iconSize),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
