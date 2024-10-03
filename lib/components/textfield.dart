import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samparka/provider/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextField(
      controller: controller,
      style: TextStyle(
        color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
      ),
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
