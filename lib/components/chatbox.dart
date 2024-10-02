import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String reply;
  final bool isCurrentUser;
  final String timestamp;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.reply,
      required this.isCurrentUser,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.75, // Max width 75% of screen
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Colors.blue
              : const Color(0xFFFFFFFF), // White for other user's message
          borderRadius: BorderRadius.only(
            topLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
            topRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (reply.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2), // Light gray for reply
                  borderRadius: BorderRadius.only(
                    topLeft:
                        isCurrentUser ? const Radius.circular(12) : Radius.zero,
                    topRight:
                        isCurrentUser ? Radius.zero : const Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: reply.length < message.length
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.reply,
                      color: isCurrentUser
                          ? Colors.white
                          : Colors.black87, // Slightly darker icon
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      // Use Flexible to adjust reply width
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width *
                              0.75, // Max width for the reply
                        ),
                        child: Text(
                          reply,
                          style: TextStyle(
                            color: isCurrentUser
                                ? Colors.white
                                : Colors.black87, // Darker text for readability
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow
                              .visible, // Allow text to overflow if needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 4),
              child: Text(
                message,
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.white
                      : Colors.black, // Standard black text for messages
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, bottom: 4),
              child: Text(
                timestamp, // Example: "10:15 AM"
                style: TextStyle(
                  fontSize: 11,
                  color: isCurrentUser
                      ? const Color.fromARGB(255, 240, 239, 239)
                      : Colors.grey.shade600, // Subtle timestamp color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
