import 'package:dm/homepage.dart';
import 'package:dm/login.dart';
import 'package:dm/verifyemail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Ensure the stream connection is active before handling data
          if (snapshot.connectionState == ConnectionState.active) {
            // If the user is not logged in, show the Login page
            if (!snapshot.hasData || snapshot.data == null) {
              return const Login();
            }

            // If the user is logged in, check email verification status
            User? user = snapshot.data;
            if (user != null && !user.emailVerified) {
              return const Verify(); // Go to email verification page if not verified
            }

            // If the user is logged in and their email is verified, go to Homepage
            return HomeScreen();
          }

          // Show a loading spinner while waiting for Firebase auth state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
