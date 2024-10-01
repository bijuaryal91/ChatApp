import 'package:flutter/material.dart';
import 'package:samparka/const/colors.dart';
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
      backgroundColor: textWhite,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
                    style: TextStyle(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Sign Up",
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
