import 'package:dm/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  // Signup function
  signup() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red, // Red background for error
          colorText: Colors.white);
      return;
    }

    if (!email.text.contains('@')) {
      Get.snackbar("Error", "Please enter a valid email address",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (password.text.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Get.snackbar("Success", "Account created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green, // Green for success
          colorText: Colors.white);
      Get.offAll(() => const Wrapper()); // Navigate to Wrapper after signup
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = e.message ?? 'An unknown error occurred.';
      }

      Get.snackbar("Error", errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
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
        title: const Text("Sign up"),
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
            TextField(
              controller: password,
              decoration: const InputDecoration(hintText: 'Enter Password'),
              obscureText: true, // Hides password input
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signup,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
