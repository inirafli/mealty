import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileDetails extends StatelessWidget {
  final String username;
  final double starRating;
  final int countRating;
  final int totalCompletedFoodTypes;
  final String phoneNumber;
  final String email;

  const ProfileDetails({
    required this.username,
    required this.starRating,
    required this.countRating,
    required this.totalCompletedFoodTypes,
    required this.phoneNumber,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color onBackground = Theme.of(context).colorScheme.onBackground;
    Color primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20.0),
        Center(
          child: Text(
            username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12.0),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(MdiIcons.emailOutline, color: primary, size: 18.0),
                  const SizedBox(width: 8.0),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15.0,
                          color: onBackground,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(MdiIcons.phoneOutline, color: primary, size: 18.0),
                  const SizedBox(width: 8.0),
                  Text(
                    phoneNumber.isEmpty ? '-' : phoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15.0,
                          color: onBackground,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          decoration: BoxDecoration(
            border: Border.all(color: onBackground, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Icon(CupertinoIcons.star_fill,
                            color: Colors.orange, size: 20.0),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '$starRating/5.0',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    'dari $countRating ulasan',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onBackground,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$totalCompletedFoodTypes Makanan',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'telah diselamatkan',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onBackground,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
