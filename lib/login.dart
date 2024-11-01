import 'package:dm/forgot.dart';
import 'package:dm/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      // Show a welcome Snackbar on successful login
      Get.snackbar("Success", "Welcome, ${email.text}!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Message", e.code,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error Message", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(hintText: 'Enter Email'),
                  ),
                  TextField(
                    controller: password,
                    decoration:
                        const InputDecoration(hintText: 'Enter Password'),
                    obscureText: true, // For hiding the password
                  ),
                  ElevatedButton(
                      onPressed: (() => signIn()), child: const Text("Login")),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: (() => Get.to(const Signup())),
                      child: const Text("Register Now")),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: (() => Get.to(const Forgot())),
                      child: const Text("Forgot Password ?"))
                ],
              ),
            ),
          );
  }
}
