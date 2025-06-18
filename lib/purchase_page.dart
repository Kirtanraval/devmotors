import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pick_location_page.dart'; // Ensure this is correctly imported
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PurchaseDetailsPage extends StatefulWidget {
  const PurchaseDetailsPage({super.key});

  @override
  _PurchaseDetailsPageState createState() => _PurchaseDetailsPageState();
}

class _PurchaseDetailsPageState extends State<PurchaseDetailsPage> {
  String selectedLocation = "No location selected";
  LatLng? userSelectedLatLng;
  final List<String> paymentMethods = [
    'Cash on delivery',
    'Credit Card',
    'UPI'
  ];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool hasCalled = false; // Track if the user has called

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveLocationToFirestore() async {
    if (userSelectedLatLng != null) {
      DocumentReference docRef = firestore.collection('locations').doc();
      await docRef.set({
        'id': docRef.id,
        'latitude': userSelectedLatLng!.latitude,
        'longitude': userSelectedLatLng!.longitude,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  String createSmsMessage(String location) {
    return "Alert! My location for purchase: $location";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'REQUEST FOR HELP..!',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Start color (white)
              Color.fromARGB(255, 111, 111, 111), // End color (light orange)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Your Details :',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Address',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'For live tracking order, please select location from map',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return LocationPicker(
                            onLocationSelected: (LatLng userLocation) {
                              setState(() {
                                userSelectedLatLng = userLocation;
                                selectedLocation =
                                    'Lat: ${userLocation.latitude}, Lng: ${userLocation.longitude}';
                              });
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.location_on, color: Colors.white),
                    label: const Text(
                      'Select Location from Map',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Selected Location: $selectedLocation',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number should be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: paymentMethods[0], // Default selection
                    items: paymentMethods.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: hasCalled,
                        onChanged: (value) {
                          setState(() {
                            hasCalled = value ?? false;
                          });
                        },
                      ),
                      const Text("I have made the call."),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!hasCalled) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please call before completing purchase.'),
                            ),
                          );
                          return;
                        }
                        await saveLocationToFirestore();
                        final smsMessage = createSmsMessage(selectedLocation);
                        final url = Uri.parse('sms:?body=$smsMessage');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print('Could not launch SMS app');
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Purchase Completed Successfully!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Proceed'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final Uri phoneNumber = Uri.parse('tel:+919510704785');
                      if (await canLaunchUrl(phoneNumber)) {
                        await launchUrl(phoneNumber);
                        setState(() {
                          hasCalled = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Could not launch call')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Call Now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
