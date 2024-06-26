import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../provider/profile_provider.dart';
import '../common/custom_loading_indicator.dart';

class ProfileAddressEdit extends StatelessWidget {
  const ProfileAddressEdit({super.key});

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

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Container(
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10.0),
              FutureBuilder<Map<String, String>>(
                future: _getAddress(profileProvider.latitude ?? 0,
                    profileProvider.longitude ?? 0),
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
                    return const Text('Alamat belum ditambahkan.');
                  } else if (snapshot.hasData && snapshot.data != null) {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                    return const Text('Alamat belum ditambahkan.');
                  }
                },
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  final result = await context.push<Map<String, double>>(
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
                    border: Border.all(color: primary, width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        profileProvider.latitude != null &&
                                profileProvider.longitude != null &&
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
                                profileProvider.longitude != null &&
                                profileProvider.latitude != 0 &&
                                profileProvider.longitude != 0
                            ? 'Ubah Alamat'
                            : 'Tambahkan Alamat',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        );
      },
    );
  }
}
