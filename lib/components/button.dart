import 'package:flutter/material.dart';
import 'package:samparka/const/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: primaryColor),
      child: Text(
        text,
        style: const TextStyle(color: textWhite),
      ),
    );
  }
}
