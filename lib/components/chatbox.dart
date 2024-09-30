import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color.fromARGB(255, 8, 136, 255)
            : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
