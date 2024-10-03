import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samparka/components/chatbox.dart';
import 'package:samparka/const/colors.dart';
import 'package:samparka/provider/theme_provider.dart';
import 'package:samparka/services/auth/auth_services.dart';
import 'package:samparka/services/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String receiverEmail;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.userName,
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
  final Map<String, double> _slideOffsets = {};

  // This method updates the slide offset of a message
  void _onHorizontalDragUpdate(
      String messageId, DragUpdateDetails details, bool isCurrentUser) {
    setState(() {
      // Update the slide offset based on drag direction
      double delta = details.primaryDelta ?? 0;
      _slideOffsets[messageId] = (_slideOffsets[messageId] ?? 0) + delta;

      // Limit the slide offset to a maximum of 100 pixels
      if (_slideOffsets[messageId]! > 100) {
        _slideOffsets[messageId] = 100;
      } else if (_slideOffsets[messageId]! < -100) {
        _slideOffsets[messageId] = -100;
      }
    });
  }

  // This method is called when the drag ends
  void _onHorizontalDragEnd(
      String messageId, bool isCurrentUser, String message, String sender) {
    // Trigger reply action if slid enough
    if (isCurrentUser && _slideOffsets[messageId]! < -50) {
      // Reply on left swipe for current user's message
      selectReplyMessage(message, sender);
    } else if (!isCurrentUser && _slideOffsets[messageId]! > 50) {
      // Reply on right swipe for received message
      selectReplyMessage(message, sender);
    }

    // Reset slide offset after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _slideOffsets[messageId] = 0;
      });
    });
  }

  String? _replyMessage; // To store the message being replied to
  String?
      _replyMessageSender; // To store the sender of the message being replied to
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Only scroll down when the text field is focused and the emoji picker is not visible
        if (!_showEmojiPicker) {
          Future.delayed(const Duration(seconds: 1), () => scrollDown());
        }
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
        _showEmojiPicker = false;
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

  void _onEmojiSelected(Emoji emoji) {
    setState(() {
      _controller.text += emoji.emoji; // Append selected emoji to input
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      // Unfocus the text field when emoji picker is opened
      if (_showEmojiPicker) {
        _focusNode.unfocus(); // Unfocus to prevent scrolling
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme
            ? const Color.fromARGB(255, 41, 40, 40)
            : const Color.fromARGB(255, 8, 136, 255),
        foregroundColor: Colors.white,
        titleSpacing: -5, // Reduce the gap between back button and title
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: Icon(
                Icons.person,
                color: Colors.grey.shade600,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.userName,
              style: const TextStyle(fontSize: 18),
            ),
          ],
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
          if (_showEmojiPicker) // Show emoji picker when toggled
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) => _onEmojiSelected(emoji),
              ),
            ),
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
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        // Check if there are any messages, if so, scroll to the bottom
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          Future.delayed(
            const Duration(milliseconds: 100),
            () => scrollDown(),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return ListView(
            controller: _scrollController,
            children:
                snapshot.data!.docs.map((doc) => _messageItems(doc)).toList(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("An error occurred: ${snapshot.error}"));
        } else {
          // While waiting for data or if it's null
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _messageItems(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['senderId'] == _authServices.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // Message ID to track each message's slide offset
    String messageId = doc.id;
    _slideOffsets[messageId] = _slideOffsets[messageId] ?? 0;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _onHorizontalDragUpdate(messageId, details, isCurrentUser);
      },
      onHorizontalDragEnd: (details) {
        _onHorizontalDragEnd(
            messageId, isCurrentUser, data['message'], data['senderId']);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform:
            Matrix4.translationValues(_slideOffsets[messageId] ?? 0, 0, 0),
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
                isCurrentUser: isCurrentUser,
                timestamp: formatTimestamp(data['timestamp']),
              ),
            if (data['replyMessage'] == null &&
                data['replyMessageSender'] == null)
              ChatBubble(
                message: data['message'],
                reply: "",
                isCurrentUser: isCurrentUser,
                timestamp: formatTimestamp(
                  data['timestamp'],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to a string
    String formattedTime =
        DateFormat.jm().format(dateTime); // This will return  "11:12 PM" format

    return formattedTime;
  }

  Widget _buildUserInput() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type a message...",
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: _toggleEmojiPicker, // Toggle emoji picker
          ),
          const SizedBox(width: 8),
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
