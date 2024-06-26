import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../provider/profile_provider.dart';

class ProfilePictureEdit extends StatelessWidget {
  const ProfilePictureEdit({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: onPrimary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ubah Foto Profil',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15.0,
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundImage: profileProvider.profileImageFile != null
                          ? FileImage(profileProvider.profileImageFile!)
                          : profileProvider.profile?.photoUrl.isNotEmpty ?? false
                          ? NetworkImage(profileProvider.profile!.photoUrl)
                      as ImageProvider
                          : NetworkImage(
                          'https://ui-avatars.com/api/?name=${profileProvider.profile?.username}'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          await profileProvider.pickImageFromGallery();
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: primary,
                          child: Icon(
                            MdiIcons.imageEditOutline,
                            color: onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}