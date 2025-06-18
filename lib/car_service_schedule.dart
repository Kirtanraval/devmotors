import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarServiceSchedule extends StatefulWidget {
  @override
  _CarServiceScheduleState createState() => _CarServiceScheduleState();
}

class _CarServiceScheduleState extends State<CarServiceSchedule> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _carDetailsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendInquiry() async {
    final String name = _nameController.text;
    final String carDetails = _carDetailsController.text;
    final String date = _dateController.text;
    final String message = _messageController.text;

    final String formattedMessage =
        "Service Inquiry:\nName: $name\nCar: $carDetails\nDate: $date\nMessage: $message";

    final Uri whatsappUri = Uri.parse(
        'https://wa.me/919510704785?text=${Uri.encodeComponent(formattedMessage)}');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title:
            Text('Schedule Car Service', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _carDetailsController,
                decoration: InputDecoration(labelText: 'Car Details'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your car details' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration:
                    InputDecoration(labelText: 'Preferred Service Date'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a date' : null,
              ),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Additional Message'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendInquiry();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child:
                    Text('Send Inquiry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
