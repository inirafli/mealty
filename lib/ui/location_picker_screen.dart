import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  loc.LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final location = loc.Location();
    final currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
      _pickedLocation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          15.0,
        ),
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    _pickedLocation = position.target;
  }

  void _confirmLocation() {
    if (_pickedLocation != null) {
      context.pop({
        'latitude': _pickedLocation!.latitude,
        'longitude': _pickedLocation!.longitude,
      });
    }
  }

  void _moveToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          15.0,
        ),
      );
    }
  }

  void _zoomIn() {
    _mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentLocation!.latitude!,
                      _currentLocation!.longitude!,
                    ),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onCameraMove: _onCameraMove,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 56.0),
                  child: Center(
                      child: Image.asset(
                    'assets/location_pointer.png',
                    width: 48.0,
                  )),
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: IconButton(
                      icon: Icon(MdiIcons.arrowLeft,
                          color: Theme.of(context).colorScheme.onBackground),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 98,
                  right: 16,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: IconButton(
                          icon: Icon(MdiIcons.plus,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          onPressed: _zoomIn,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: IconButton(
                          icon: Icon(MdiIcons.minus,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          onPressed: _zoomOut,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: IconButton(
                          icon: Icon(MdiIcons.crosshairsGps,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          onPressed: _moveToCurrentLocation,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _confirmLocation,
                            child: Text(
                              'Pilih Lokasi',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
