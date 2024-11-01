import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For Snackbar feedback

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;

  // Function to reset password
  reset() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Get.snackbar("Success", "Password reset email sent successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green, // Green for success
          colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red, // Red for error
          colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: 'Enter Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (email.text.isEmpty || !email.text.contains('@')) {
                  Get.snackbar("Error", "Please enter a valid email address",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                } else {
                  reset();
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Send Password Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}
