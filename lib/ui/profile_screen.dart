import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import '../widgets/profile/profile_details.dart';
import '../widgets/profile/profile_food_types.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

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
                        ProfileDetails(
                          username: profile.username,
                          phoneNumber: profile.phoneNumber,
                          email: profile.email,
                          starRating: profile.starRating,
                          countRating: profile.countRating,
                          totalCompletedFoodTypes:
                          profileProvider.totalCompletedFoodTypes,
                        ),
                        ProfileFoodTypes(
                          completedFoodTypes: profile.completedFoodTypes,
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
