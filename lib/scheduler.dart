import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchedulerPage extends StatefulWidget {
  @override
  _SchedulerPageState createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _launchSMS() async {
    String message = """
Name: ${_nameController.text}
Service: ${_serviceTypeController.text}
Date: ${_dateController.text}
Details: ${_messageController.text}
""";

    final Uri smsUri =
        Uri.parse("sms:+919510704785?body=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch SMS app')),
      );
    }

    _clearFields();
  }

  void _clearFields() {
    _nameController.clear();
    _serviceTypeController.clear();
    _dateController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Schedule Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _serviceTypeController,
              decoration: InputDecoration(labelText: 'Service Type'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Preferred Date'),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Additional Message'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchSMS,
              child: Text('Send via SMS App'),
            ),
          ],
        ),
      ),
    );
  }
}
