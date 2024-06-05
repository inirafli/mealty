import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FoodTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onSelectType;

  const FoodTypeSelector({
    required this.selectedType,
    required this.onSelectType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final types = {
      'staple': {
        'icon': MdiIcons.foodDrumstickOutline,
        'iconSize': 17.0,
        'text': 'Makanan'
      },
      'drinks': {
        'icon': MdiIcons.beerOutline,
        'iconSize': 17.5,
        'text': 'Minuman'
      },
      'snacks': {
        'icon': MdiIcons.cakeVariantOutline,
        'iconSize': 17.5,
        'text': 'Camilan'
      },
      'fruitsVeg': {
        'icon': MdiIcons.foodAppleOutline,
        'iconSize': 18.0,
        'text': 'Buah dan Sayur'
      },
    };

    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Makanan',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: onBackground,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: types.entries.map((entry) {
            final type = entry.key;
            final data = entry.value;

            final bool isSelected = type == selectedType;

            return GestureDetector(
              onTap: () => onSelectType(type),
              child: Container(
                height: 35.0,
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: isSelected ? primary : onPrimary,
                  border: Border.all(color: primary, width: 0.75),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data['icon'] as IconData,
                      size: data['iconSize'] as double,
                      color: isSelected ? onPrimary : primary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      data['text'] as String,
                      style: TextStyle(
                        color: isSelected ? onPrimary : primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
