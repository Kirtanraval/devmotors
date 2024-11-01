import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'purchase_page.dart'; // Import the PurchasePage
import 'payment.dart'; // Import the PaymentPage

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget content() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null)
              Text(
                user!.email ?? 'No Email Found',
                style: const TextStyle(fontSize: 24),
              ),
            if (user == null)
              const Text(
                'No user is signed in.',
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }

  void _sendFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'kkirtanraval@gmail.com',
      queryParameters: {
        'subject': 'User Feedback',
        'body': 'Enter your feedback here...'
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        // Show dialog if no email clients are available
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No Email Client Found'),
            content:
                const Text('Please install an email client to send feedback.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error launching email app: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PurchaseDetailsPage(), // Navigate to PurchasePage
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.payment), // Payment Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaymentPage(), // Navigate to PaymentPage
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.feedback), // Feedback Icon
            onPressed: _sendFeedback, // Open email client
          ),
        ],
      ),
      body: content(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: signout,
            child: const Icon(Icons.login_rounded),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              final Uri whatsapp = Uri.parse(
                  'https://wa.me/919510704785'); // Corrected number format
              if (await canLaunchUrl(whatsapp)) {
                await launchUrl(whatsapp);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch WhatsApp')),
                );
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.chat),
          ),
        ],
      ),
    );
  }
}
