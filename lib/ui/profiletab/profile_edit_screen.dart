import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/sub_screen_header.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  Future<String> _getAddress(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return "${place.name}, ${place.locality}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}.";
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;
    Color secondary = Theme.of(context).colorScheme.secondary;

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                        contentText: profileProvider.message!,
                        context: context,
                      ),
                    );
                    profileProvider.clearMessage();
                  });
                }

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: profileProvider.profileImageFile != null
                                ? FileImage(profileProvider.profileImageFile!)
                                : profileProvider.profile?.photoUrl.isNotEmpty ?? false
                                ? NetworkImage(profileProvider.profile!.photoUrl) as ImageProvider
                                : const AssetImage('assets/default_profile.png'),
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
                                backgroundColor: secondary,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: profileProvider.usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: profileProvider.phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16.0),
                    FutureBuilder<String>(
                      future: _getAddress(profileProvider.latitude ?? 0, profileProvider.longitude ?? 0),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CustomProgressIndicator(
                              color: primary,
                              size: 24.0,
                              strokeWidth: 2.0,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text('Error fetching location', style: TextStyle(color: Colors.red));
                        } else if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                snapshot.data!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: onBackground,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await context.push<Map<String, double>>('/main/manageFood/locationPicker');
                                  if (result != null) {
                                    profileProvider.setLocation(result);
                                  }
                                },
                                child: const Text('Change Address'),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
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
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: profileProvider.isLoading
                  ? null
                  : () async {
                await profileProvider.updateProfile();
              },
              child: profileProvider.isLoading
                  ? CustomProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
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