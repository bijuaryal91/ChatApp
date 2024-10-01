import 'package:flutter/material.dart';
import 'package:samparka/const/colors.dart';
import 'package:samparka/services/auth/auth_services.dart';
import 'package:samparka/components/button.dart';
import 'package:samparka/components/textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _cpwController = TextEditingController();
  final void Function()? onTap;
  RegisterPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: textWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit
                        .cover, // Ensures the image fills the circle properly
                  ),
                ),
              ),
              const SizedBox(height: 15),
              MyField(
                labelText: "Email",
                hintText: "",
                obscure: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              MyField(
                labelText: "Password",
                hintText: "",
                obscure: true,
                controller: _pwController,
              ),
              const SizedBox(height: 14),
              MyField(
                labelText: "Confirm Password",
                hintText: "",
                obscure: true,
                controller: _cpwController,
              ),
              const SizedBox(height: 14),
              MyButton(
                text: "Signup",
                onPressed: () async {
                  if (_pwController.text == _cpwController.text) {
                    await AuthServices().signup(
                        email: _emailController.text,
                        password: _pwController.text,
                        context: context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password doesn't Matched!",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: error,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: textGrey,
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
