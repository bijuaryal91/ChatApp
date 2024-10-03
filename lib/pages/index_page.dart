import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samparka/components/usertile.dart';
import 'package:samparka/pages/chat_page.dart';
import 'package:samparka/services/auth/auth_services.dart';
import 'package:samparka/services/chat/chat_service.dart';

class Indexpage extends StatelessWidget {
  Indexpage({super.key});

  final ChatService _chatService = ChatService();
  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 136, 255),
        foregroundColor: Colors.white,
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () {
              _authServices.signout(context: context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _getUsersList(),
    );
  }

  Widget _getUsersList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUser(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUser(Map<String, dynamic> userData, BuildContext context) {
    // Check if the user is not the current user
    if (userData['email'] != _authServices.getCurrentUser()!.email) {
      return StreamBuilder<Map<String, dynamic>?>(
        stream: _chatService.getLastMessageStream(
            userData['uid'], _authServices.getCurrentUser()!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              title: Text(userData['fname'] + " " + userData['lname']),
              subtitle: const Text("......"),
            );
          } else if (snapshot.hasError) {
            return ListTile(
              title: Text(userData['fname'] + " " + userData['lname']),
              subtitle: const Text('Error fetching last message'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return UserTile(
              text: userData['fname'] + " " + userData['lname'],
              lastMessage:
                  'No messages yet', // Default message if no messages found
              lastMessageColor: Colors.grey.shade600,
              lastMessageWeight: FontWeight.normal,
              time: '', // No time to display if no messages
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiverEmail: userData['email'],
                      receiverId: userData['uid'],
                    ),
                  ),
                );
              },
            );
          }

          // Handle the fetched last message
          final lastMessageData = snapshot.data!;
          String lastMessageText = lastMessageData['message'] ?? '';
          bool isSentByCurrentUser = lastMessageData['senderId'] ==
              _authServices.getCurrentUser()!.uid;

          // Prepend 'You: ' if the last message is sent by the current user
          if (isSentByCurrentUser) {
            lastMessageText = 'You: $lastMessageText';
          }

          return UserTile(
            text: userData['fname'] + " " + userData['lname'],
            lastMessage: lastMessageText,
            lastMessageColor:
                isSentByCurrentUser ? Colors.grey.shade600 : Colors.black,
            lastMessageWeight:
                isSentByCurrentUser ? FontWeight.normal : FontWeight.bold,
            time: _formatTimestamp(lastMessageData[
                'timestamp']), // Format and pass the timestamp if needed
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receiverEmail: userData['email'],
                    receiverId: userData['uid'],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container(); // Return an empty container for the current user
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to a string
    String formattedTime =
        DateFormat.jm().format(dateTime); // This will return  "11:12 PM" format

    return formattedTime;
  }
}
