import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samparka/components/chatbox.dart';
import 'package:samparka/const/colors.dart';
import 'package:samparka/services/auth/auth_services.dart';
import 'package:samparka/services/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthServices _authServices = AuthServices();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String? _replyMessage; // To store the message being replied to
  String?
      _replyMessageSender; // To store the sender of the message being replied to

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(const Duration(seconds: 1), () => scrollDown());
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      // Include reply message and original sender info if available
      await _chatService.sendMessage(
        widget.receiverId,
        _controller.text,
        replyMessage: _replyMessage,
        replyMessageSender: _replyMessageSender,
      );

      _controller.clear();
      setState(() {
        _replyMessage = null; // Clear the reply message after sending
        _replyMessageSender = null;
      });
    }
    scrollDown();
  }

  // Function to select a message for replying
  void selectReplyMessage(String message, String sender) {
    setState(() {
      _replyMessage = message;
      _replyMessageSender = sender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 136, 255),
        foregroundColor: Colors.white,
        title: Text(
          widget.receiverEmail,
          style: const TextStyle(fontSize: 18),
        ),
        actions: const [
          Icon(Icons.call),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messageList(),
          ),
          if (_replyMessage != null)
            _buildReplyPreview(), // Show reply preview if a message is selected
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: const Border(left: BorderSide(color: primaryColor, width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _replyMessage!,
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _replyMessage =
                    null; // Remove reply message when close button is pressed
                _replyMessageSender = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _messageList() {
    String senderId = _authServices.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if there are any messages, if so, scroll to the bottom
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          Future.delayed(
            const Duration(milliseconds: 100),
            () => scrollDown(),
          );
        }

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _messageItems(doc)).toList(),
        );
      },
    );
  }

  Widget _messageItems(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser =
        data['senderId'] == _authServices.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return GestureDetector(
      // Wrap the message in a GestureDetector
      onTap: () {
        // Call selectReplyMessage when a message is tapped
        selectReplyMessage(data['message'], data['senderId']);
      },
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Check if there's a reply message
            if (data['replyMessage'] != null &&
                data['replyMessageSender'] != null)
              ChatBubble(
                  message: data['message'],
                  reply: data['replyMessage'],
                  isCurrentUser: isCurrentUser),

            if (data['replyMessage'] == null &&
                data['replyMessageSender'] == null)
              ChatBubble(
                  message: data['message'],
                  reply: "",
                  isCurrentUser: isCurrentUser),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, left: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type a message...",
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
