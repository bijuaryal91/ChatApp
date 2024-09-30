import 'dart:async';
import 'package:flutter/material.dart';
import 'package:samparka/services/auth/login_or_register.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _initializeApp(); // Call the initialization function
  }

  Future<void> _initializeApp() async {
    // Simulate a loading process, like fetching data from Firebase
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading time
    // Add your database loading logic here
    // For example: await loadDataFromFirebase();

    setState(() {
      isLoading = false; // Update loading state to false
    });

    // Navigate to the main page after loading is complete
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrRegister(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 192,
          253), // Set the background color for the entire Scaffold
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo displayed at the top
            Image.asset(
              'assets/background.png',
              height: MediaQuery.of(context).size.height *
                  0.2, // Set desired height for logo
              width: MediaQuery.of(context).size.width *
                  0.5, // Set desired width for logo
              fit: BoxFit.contain,
            ),
            const SizedBox(
                height: 20), // Space between logo and loading indicator
            // Loading indicator displayed below the logo
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ) // Show loading indicator while loading
                : const SizedBox.shrink(), // Empty widget when not loading
          ],
        ),
      ),
    );
  }
}
