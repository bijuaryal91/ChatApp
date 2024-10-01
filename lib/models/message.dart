import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String? replyMessage; // Optional field for the reply message
  final String?
      replyMessageSender; // Optional field for the sender of the reply message

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.replyMessage, // Initialize optional replyMessage
    this.replyMessageSender, // Initialize optional replyMessageSender
  });

  // Convert the Message object to a map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'replyMessage': replyMessage, // Include replyMessage if available
      'replyMessageSender':
          replyMessageSender, // Include replyMessageSender if available
    };
  }

  // Create a Message object from a Firestore document
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: map['timestamp'],
      replyMessage: map['replyMessage'], // Parse replyMessage if available
      replyMessageSender:
          map['replyMessageSender'], // Parse replyMessageSender if available
    );
  }
}
