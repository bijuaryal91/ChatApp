import 'package:flutter/material.dart';
import 'package:samparka/components/button.dart';
import 'package:samparka/services/auth/login_or_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage({super.key});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool _isLoading = true;
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenWelcomePage = prefs.getBool('hasSeenWelcomePage');

    if (hasSeenWelcomePage == true) {
      _navigateToHome();
    } else {
      setState(() {
        _isFirstTime = true; // Show welcome page
        _isLoading = false;
      });
    }
  }

  _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  _agreeAndContinue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcomePage', true);
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : _isFirstTime
              ? WelcomePage(
                  onAgree: _agreeAndContinue,
                )
              : const LoginOrRegister(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final VoidCallback onAgree;

  const WelcomePage({super.key, required this.onAgree});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display image/logo and text here
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit:
                    BoxFit.cover, // Ensures the image fills the circle properly
              ),
            ),
          ), // Use your logo here
          const SizedBox(height: 20),
          const Text(
            "Welcome to Samparka",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Read our Privacy Policy. Tap 'Agree and Continue' to accept Terms of Service.",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          MyButton(text: "Agree and Continue", onPressed: onAgree)
        ],
      ),
    );
  }
}
