import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String messageId;
  String senderId;
  String text;
  DateTime timestamp;
  String username;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'senderId': senderId,
    'text': text,
    'timestamp': timestamp,
    'username': username,
  };

  static ChatMessage fromJson(Map<String, dynamic> json) => ChatMessage(
    messageId: json['messageId'],
    senderId: json['senderId'],
    text: json['text'],
    timestamp: (json['timestamp'] as Timestamp).toDate(),
    username: json['username'],
  );
}