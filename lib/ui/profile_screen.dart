import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(54.0),
        child: AppBar(
          title: Text(
            'Profil Anda',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 8.0),
              icon: Icon(Icons.logout_outlined, color: primary, size: 24.0),
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signOut();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (profileProvider.errorMessage != null) {
            return Center(child: Text(profileProvider.errorMessage!));
          } else {
            final profile = profileProvider.profile!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profile.photoUrl == ''
                                ? 'https://ui-avatars.com/api/?name=${profile.username}'
                                : profile.photoUrl),
                            radius: 54.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Center(
                          child: Text(
                            profile.username,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                        '${profile.starRating}/5.0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: onBackground,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'dari ${profile.countRating} ulasan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: onBackground,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${profileProvider.totalCompletedFoodTypes} Makanan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: onBackground,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    'telah diselamatkan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: onBackground),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28.0),
                        Text(
                          'Rincian Pencapaian',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: primary,
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
                                        child: Icon(iconData, size: iconSize, color: onBackground),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${profile.completedFoodTypes[type] ?? 0}',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: onBackground,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            text,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                        child: Icon(iconData, size: iconSize, color: onBackground),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${profile.completedFoodTypes[type] ?? 0}',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: onBackground,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            text,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  ),
                  Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    height: 240.0,
                    child: Column(
                      children: const [
                        Text('Action is Here'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
