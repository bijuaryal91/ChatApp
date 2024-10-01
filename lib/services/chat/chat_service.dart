import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samparka/models/message.dart';

class ChatService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _fireStore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

// Send Message
  Future<void> sendMessage(String receiverId, String message,
      {String? replyMessage, String? replyMessageSender}) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message object with optional reply message fields
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      replyMessage: replyMessage, // Add replyMessage (if provided)
      replyMessageSender:
          replyMessageSender, // Add replyMessageSender (if provided)
    );

    // Sort user IDs to generate a consistent chat room ID
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatId = ids.join("_");

    // Add the new message to the Firestore chat room
    await _fireStore
        .collection('chat_rooms')
        .doc(chatId)
        .collection("messages")
        .add(
          newMessage.toMap(), // Convert message to map and add to Firestore
        );
  }

  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatId = ids.join("_");
    return _fireStore
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
