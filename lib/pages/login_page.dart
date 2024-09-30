import 'package:flutter/material.dart';
import 'package:samparka/services/auth/auth_services.dart';
import 'package:samparka/components/button.dart';
import 'package:samparka/components/textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Chat App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              MyField(
                labelText: "Email",
                hintText: "",
                obscure: false,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              MyField(
                labelText: "Password",
                hintText: "",
                obscure: true,
                controller: _pwController,
              ),
              const SizedBox(height: 24),
              MyButton(
                text: "Login",
                onPressed: () async {
                  await AuthServices().signin(
                      email: _emailController.text,
                      password: _pwController.text,
                      context: context);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
