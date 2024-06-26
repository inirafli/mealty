import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/sub_screen_header.dart';

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
      Provider.of<ProfileProvider>(context, listen: false).refreshUserFoodPosts();
    });
  }

  Future<Map<String, String>> _getAddress(
      double latitude, double longitude) async {
    if (latitude == 0 && longitude == 0) {
      return {'notFound': 'Belum ada Alamat yang ditambahkan'};
    }
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return {
      'street': place.street ?? "Unknown street",
      'locality':
          "${place.name}, ${place.locality}, ${place.subLocality}, ${place.subAdministrativeArea}, "
              "${place.postalCode}, ${place.administrativeArea}, ${place.country}.",
    };
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;
    Color secondary = Theme.of(context).colorScheme.secondary;

    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.bold,
        );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: onPrimary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: primary,
          width: 0.75,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
    );

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

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
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
                                      backgroundImage: profileProvider
                                                  .profileImageFile !=
                                              null
                                          ? FileImage(
                                              profileProvider.profileImageFile!)
                                          : profileProvider.profile?.photoUrl
                                                      .isNotEmpty ??
                                                  false
                                              ? NetworkImage(profileProvider
                                                  .profile!
                                                  .photoUrl) as ImageProvider
                                              : NetworkImage(
                                                  'https://ui-avatars.com/api/?name=${profileProvider.profile?.username}'),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await profileProvider
                                              .pickImageFromGallery();
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
                        ),
                        const SizedBox(height: 12.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: onPrimary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Username',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 44.0,
                                    child: TextField(
                                      controller:
                                          profileProvider.usernameController,
                                      decoration: inputDecoration.copyWith(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 12.0),
                                      ),
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nomor Telepon',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 44.0,
                                    child: TextField(
                                      controller:
                                          profileProvider.phoneNumberController,
                                      decoration: inputDecoration.copyWith(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 12.0),
                                      ),
                                      style: textStyle,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: onPrimary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alamat',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 10.0),
                              FutureBuilder<Map<String, String>>(
                                future: _getAddress(
                                    profileProvider.latitude ?? 0,
                                    profileProvider.longitude ?? 0),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CustomProgressIndicator(
                                        color: primary,
                                        size: 24.0,
                                        strokeWidth: 2.0,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                        'Alamat belum ditambahkan.');
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    final addressData = snapshot.data!;
                                    if (addressData.containsKey('notFound')) {
                                      return Text(
                                        addressData['notFound']!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: onBackground),
                                      );
                                    } else {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            addressData['street']!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontSize: 15.0,
                                                  color: onBackground,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            addressData['locality']!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: onBackground,
                                                ),
                                          ),
                                        ],
                                      );
                                    }
                                  } else {
                                    return const Text(
                                        'Alamat belum ditambahkan.');
                                  }
                                },
                              ),
                              const SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () async {
                                  final result =
                                      await context.push<Map<String, double>>(
                                          '/main/manageFood/locationPicker');
                                  if (result != null) {
                                    profileProvider.setLocation(result);
                                  }
                                },
                                child: Container(
                                  height: 40.0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: onPrimary,
                                    border:
                                        Border.all(color: primary, width: 1.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        profileProvider.latitude != null &&
                                                profileProvider.longitude !=
                                                    null &&
                                                profileProvider.latitude != 0 &&
                                                profileProvider.longitude != 0
                                            ? MdiIcons.mapMarkerMultipleOutline
                                            : MdiIcons.mapMarkerPlusOutline,
                                        size: 18.0,
                                        color: primary,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        profileProvider.latitude != null &&
                                                profileProvider.longitude !=
                                                    null &&
                                                profileProvider.latitude != 0 &&
                                                profileProvider.longitude != 0
                                            ? 'Ubah Alamat'
                                            : 'Tambahkan Alamat',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
