import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String reply;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.reply,
      required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color.fromARGB(255, 8, 136, 255)
            : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      child: Column(
        children: [
          if (reply.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: Color.fromARGB(120, 0, 0, 0),
              ),
              child: Text(
                reply,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
