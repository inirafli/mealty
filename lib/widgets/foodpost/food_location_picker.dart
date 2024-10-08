import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../common/custom_loading_indicator.dart';

class FoodLocationPicker extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final ValueChanged<Map<String, double>> onLocationPicked;

  const FoodLocationPicker({
    super.key,
    this.latitude,
    this.longitude,
    required this.onLocationPicked,
  });

  @override
  State<FoodLocationPicker> createState() => _FoodLocationPickerState();
}

class _FoodLocationPickerState extends State<FoodLocationPicker> {
  Future<Map<String, String>> _getAddress(
      double latitude, double longitude) async {
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

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final hasUserAddress = profileProvider.latitude != null &&
        profileProvider.longitude != null &&
        profileProvider.latitude != 0 &&
        profileProvider.longitude != 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lokasi Makanan',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasUserAddress)
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
                ),
                onPressed: () {
                  final userLocation = {
                    'latitude': profileProvider.latitude!,
                    'longitude': profileProvider.longitude!
                  };
                  widget.onLocationPicked(userLocation);
                  setState(() {});
                },
                child: Text(
                  'Gunakan Alamat',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12.0),
        if (widget.latitude != null && widget.longitude != null)
          FutureBuilder<Map<String, String>>(
            future: _getAddress(widget.latitude!, widget.longitude!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CustomProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2.0,
                    size: 24.0,
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Error fetching location',
                    style: TextStyle(color: Colors.red));
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          MdiIcons.mapMarkerRadiusOutline,
                          size: 20.0,
                          color: onBackground,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['street']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: onBackground,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 1.5),
                              Text(
                                snapshot.data!['locality']!,
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: onBackground,
                                          fontSize: 13.0,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              }
              return const SizedBox(height: 16.0);
            },
          ),
        GestureDetector(
          onTap: () async {
            final result = await context
                .push<Map<String, double>>('/main/manageFood/locationPicker');
            if (result != null) {
              widget.onLocationPicked(result);
              setState(() {});
            }
          },
          child: Container(
            height: 40.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            margin: const EdgeInsets.only(top: 4.0),
            decoration: BoxDecoration(
              color: onPrimary,
              border: Border.all(color: primary, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.latitude != null && widget.longitude != null
                      ? MdiIcons.mapMarkerMultipleOutline
                      : MdiIcons.mapMarkerPlusOutline,
                  size: 18.0,
                  color: primary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.latitude != null && widget.longitude != null
                      ? 'Ubah Lokasi'
                      : 'Pilih Lokasi',
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
    );
  }
}
