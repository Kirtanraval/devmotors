import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatelessWidget {
  final String upiId = "kkirtanraval@okhdfcbank"; // Your UPI ID
  final String mobileNumber = "919510704785"; // Your mobile number

  const PaymentPage({super.key});

  Future<void> payUsingMobile(BuildContext context) async {
    // Create a URI for UPI payment using the mobile number
    final Uri upiUri = Uri.parse(
      'upi://pay?pa=$upiId&pn=KirtanRaval&mc=YourMerchantCode&tid=YourTransactionId&tn=Payment for order',
    );

    try {
      if (await canLaunchUrl(upiUri)) {
        await launchUrl(upiUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No UPI app installed or cannot be launched.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching UPI apps: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () => payUsingMobile(context), // Call payment method
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue,
            ),
            child: const Text('Pay to UPI ID',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
