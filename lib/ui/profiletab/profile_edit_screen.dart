import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/sub_screen_header.dart';
import '../../widgets/profile/profile_address_edit.dart';
import '../../widgets/profile/profile_info_edit.dart';
import '../../widgets/profile/profile_picture_edit.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false)
          .refreshUserFoodPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: onPrimary,
        ),
      ),
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SubScreenHeader(
              title: 'Ubah Profil',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (profileProvider.isLoading) {
                  return Center(
                    child: CustomProgressIndicator(
                      color: primary,
                      size: 24.0,
                      strokeWidth: 2.0,
                    ),
                  );
                }

                if (profileProvider.message != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(
                          contentText: profileProvider.message!,
                          context: context,
                        ),
                      );
                      profileProvider.clearMessage();
                    }
                  });
                }

                return const SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ProfilePictureEdit(),
                        SizedBox(height: 12.0),
                        ProfileInfoEdit(),
                        SizedBox(height: 12.0),
                        ProfileAddressEdit(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return Container(
            color: onPrimary,
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: profileProvider.isLoading
                  ? null
                  : () async {
                      await profileProvider.updateProfile();

                      if (context.mounted) context.pop();
                    },
              child: profileProvider.isLoading
                  ? CustomProgressIndicator(
                      color: onPrimary,
                      size: 16.0,
                      strokeWidth: 2,
                    )
                  : Text(
                      'Simpan Perubahan',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: onPrimary,
                          ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
