import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mealty/widgets/common/custom_loading_indicator.dart';

class FoodLocationWidget extends StatefulWidget {
  final GeoPoint location;
  final String formattedDistance;

  const FoodLocationWidget({
    super.key,
    required this.location,
    required this.formattedDistance,
  });

  @override
  State<FoodLocationWidget> createState() => _FoodLocationWidgetState();
}

class _FoodLocationWidgetState extends State<FoodLocationWidget> {
  late GoogleMapController _controller;
  late CameraPosition _initialCameraPosition;
  BitmapDescriptor? _customMarker; // Changed to nullable
  String _address = 'Memuat alamat...';

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 14.0,
    );
    _loadCustomMarker();
    _getAddressFromLatLng();
  }

  Future<void> _loadCustomMarker() async {
    _customMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/location_pointer_mini.png',
    );
    setState(() {});
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.location.latitude,
        widget.location.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _address =
            '${place.street}, ${place.locality}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}.';
      });
    } catch (e) {
      setState(() {
        _address = 'Tidak bisa menampilkan Alamat.';
      });
    }
  }

  void _moveToCurrentLocation() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Container(
      decoration: BoxDecoration(
        color: onPrimary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 240.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: _customMarker == null
                      ? Center(
                          child: CustomProgressIndicator(
                          color: primary,
                          size: 16.0,
                          strokeWidth: 2.0,
                        ))
                      : GoogleMap(
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                          markers: {
                            Marker(
                              markerId: const MarkerId('postLocation'),
                              position: LatLng(widget.location.latitude,
                                  widget.location.longitude),
                              icon: _customMarker!,
                            ),
                          },
                          zoomControlsEnabled: false,
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer())
                          },
                        ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: onPrimary,
                  radius: 20,
                  child: IconButton(
                    icon: Icon(
                      MdiIcons.crosshairsGps,
                      color: onBackground,
                    ),
                    onPressed: _moveToCurrentLocation,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 12.0, left: 16.0, bottom: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi Makanan',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  _address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 14.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 7.5, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Perkiraan Jarak dari Lokasimu',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.5,
                              color: onBackground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        widget.formattedDistance,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: onBackground,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
