import 'package:flutter/material.dart';
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
              AuthServices().signout(context: context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _getUsersList(),
    );
  }

  Widget _getUsersList() {
    return StreamBuilder(
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
    if (userData['email'] != _authServices.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                  receiverEmail: userData['email'],
                  receiverId: userData['uid']),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
