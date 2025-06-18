import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng)? onLocationSelected;
  const LocationPicker({super.key, this.onLocationSelected});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permission denied Forever');
    } else {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 10,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.terrain,
                onMapCreated: (controller) {
                  mapController = controller;
                  if (_currentPosition != null) {
                    mapController?.animateCamera(
                      CameraUpdate.newLatLng(LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      )),
                    );
                  }
                },
                onTap: (LatLng location) {
                  setState(() {
                    _selectedLocation = location;
                  });
                },
                markers: _selectedLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selectedLocation'),
                          position: _selectedLocation!,
                          infoWindow: InfoWindow(
                            title: 'Selected location',
                            snippet:
                                'Lat: ${_selectedLocation!.latitude}, long: ${_selectedLocation!.longitude}',
                          ),
                        ),
                      }
                    : {},
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation ?? LatLng(0, 0),
                  zoom: 10,
                ),
                myLocationEnabled: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 62, 150, 38),
                onPressed: () {
                  if (_selectedLocation != null) {
                    Navigator.pop(context);
                    widget.onLocationSelected?.call(_selectedLocation!);
                  } else {
                    // Optional: Show a message if no location is selected
                    print('No location selected');
                  }
                },
                child: const Icon(Icons.check, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      _selectedLocation != null
                          ? 'Selected Location: Lat: ${_selectedLocation!.latitude.toStringAsFixed(3)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(3)}'
                          : 'Select a location on the map',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
