import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import '../widgets/profile/profile_details.dart';
import '../widgets/profile/profile_food_types.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).refreshUserFoodPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

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
          backgroundColor: onPrimary,
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (profileProvider.profile == null) {
            return const Center(child: Text('User profile not found.'));
          } else {
            final profile = profileProvider.profile!;

            return SingleChildScrollView(
              key: const PageStorageKey<String>('profile_scroll_position'),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profile.photoUrl.isEmpty
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12.0),
                        _buildActionButton(
                          context,
                          icon: MdiIcons.accountEditOutline,
                          text: 'Ubah Profil',
                          subText: 'Kelola data Profil-mu.',
                          onTap: () {
                            // Handle Ubah Profil tap
                            context.go('/main/profileEdit');
                          },
                        ),
                        _buildActionButton(
                          context,
                          icon: MdiIcons.foodOutline,
                          text: 'Unggahan Makanan',
                          subText: 'Kelola semua unggahan Makanan-mu',
                          onTap: () {
                            context.go('/main/profileFoodList');
                          },
                        ),
                        _buildActionButton(
                          context,
                          icon: MdiIcons.logoutVariant,
                          text: 'Keluar',
                          subText: 'Keluar dari Sesi Akun-mu',
                          onTap: () async {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            await authProvider.signOut();
                            await profileProvider.resetState();
                            if (context.mounted) context.go('/login');
                          },
                        ),
                        const SizedBox(height: 24.0),
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

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String text,
      required String subText,
      required VoidCallback onTap}) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: onPrimary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: primary, size: 26.0),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      subText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onBackground, fontSize: 13.0, height: 1.15),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: primary, size: 16.0),
          ],
        ),
      ),
    );
  }
}
