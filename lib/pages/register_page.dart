import 'package:flutter/material.dart';
import 'package:samparka/components/my_button.dart';
import 'package:samparka/components/my_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _cpwController = TextEditingController();
  final void Function()? onTap;
  RegisterPage({super.key, this.onTap});

  void register() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 16),
              MyField(
                labelText: "Confirm Password",
                hintText: "",
                obscure: true,
                controller: _cpwController,
              ),
              const SizedBox(height: 24),
              MyButton(
                text: "Signup",
                onPressed: register,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Login",
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
