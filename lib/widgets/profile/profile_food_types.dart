import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileFoodTypes extends StatelessWidget {
  final Map<String, dynamic> completedFoodTypes;

  const ProfileFoodTypes({
    required this.completedFoodTypes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    final types = {
      'staple': {
        'icon': MdiIcons.foodDrumstickOutline,
        'iconSize': 22.0,
        'text': 'Makanan'
      },
      'drinks': {
        'icon': MdiIcons.beerOutline,
        'iconSize': 22.0,
        'text': 'Minuman'
      },
      'snacks': {
        'icon': MdiIcons.cakeVariantOutline,
        'iconSize': 22.0,
        'text': 'Camilan'
      },
      'fruitsVeg': {
        'icon': MdiIcons.foodAppleOutline,
        'iconSize': 22.0,
        'text': 'Buah & Sayur'
      },
    };

    return Skeletonizer(
      enabled: Skeletonizer.of(context).enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32.0),
          Text(
            'Rincian Pencapaian',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: types.entries.take(2).map((entry) {
                  final type = entry.key;
                  final iconData = entry.value['icon'] as IconData;
                  final iconSize = entry.value['iconSize'] as double;
                  final text = entry.value['text'] as String;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: 48.0,
                          height: 46.0,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child:
                              Icon(iconData, size: iconSize, color: onBackground),
                        ),
                        const SizedBox(width: 14.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${completedFoodTypes[type] ?? 0}',
                              style:
                                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                            Text(
                              text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: onBackground,
                                    height: 1.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: types.entries.skip(2).map((entry) {
                  final type = entry.key;
                  final iconData = entry.value['icon'] as IconData;
                  final iconSize = entry.value['iconSize'] as double;
                  final text = entry.value['text'] as String;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: 48.0,
                          height: 46.0,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child:
                              Icon(iconData, size: iconSize, color: onBackground),
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${completedFoodTypes[type] ?? 0}',
                              style:
                                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                            Text(
                              text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    height: 1.0,
                                    color: onBackground,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
