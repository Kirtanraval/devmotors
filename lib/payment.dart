import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatelessWidget {
  final String upiId = "kkirtanraval@okhdfcbank"; // Your UPI ID
  final String mobileNumber = "919510704785"; // Your mobile number
  final String amount =
      "Enter Your Payment Amount"; // Sample amount for the transaction
  final String transactionId = "TRX12345"; // Example transaction ID

  const PaymentPage({super.key});

  Future<void> payUsingMobile(BuildContext context) async {
    final Uri upiUri = Uri.parse(
      'upi://pay?pa=$upiId&pn=KirtanRaval&mc=YourMerchantCode&tid=$transactionId&tn=Payment for order&am=$amount',
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
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(
            color: Colors.white), // White back navigation arrow
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 178, 178, 178),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Make a Payment:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            // Add the image here
            Image.asset(
              'assets/images/pay1.png', // Path to your image asset
              height: 200.0,
              width: 500.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Amount: ₹$amount',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => payUsingMobile(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 27, 72, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Pay to UPI ID',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
