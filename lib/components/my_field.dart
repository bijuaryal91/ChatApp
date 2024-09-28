import 'package:flutter/material.dart';

class MyField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  const MyField(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.obscure,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      keyboardType: TextInputType.emailAddress,
      obscureText: obscure,
    );
  }
}
