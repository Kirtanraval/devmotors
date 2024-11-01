import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class locationpicker extends StatefulWidget {
  final Function(LatLng)? onLocationSelected;
  const locationpicker({super.key, this.onLocationSelected});

  @override
  State<locationpicker> createState() => _locationpickerState();
}

class _locationpickerState extends State<locationpicker> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;
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
          desiredAccuracy: LocationAccuracy.high);
      print('Latitude: ${position.latitude}, longitude: ${position.longitude}');
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting Current Location : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.terrain,
                onMapCreated: (controller) {
                  mapController = controller;
                },
                onTap: (LatLng) {
                  setState(() {
                    _selectedLocation = LatLng;
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
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 10,
                ),
                myLocationEnabled: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 5),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () async {
                  if (_selectedLocation != null) {
                    print(
                        'Selected Location - Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}');
                    Navigator.pop(context);
                    widget.onLocationSelected?.call(_selectedLocation!);
                  } else {}
                },
                child: const Icon(Icons.check, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
