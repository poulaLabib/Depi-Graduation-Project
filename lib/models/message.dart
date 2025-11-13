import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime timeCreated;
  final bool isRead;
  final bool isEdited;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.timeCreated,
    required this.isRead,
    required this.isEdited,
  });

  // Factory constructor to create a Message from Firestore map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timeCreated: (map['timeCreated'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
      isEdited: map['isEdited'] ?? false,
    );
  }

  // Convert Message to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeCreated': Timestamp.fromDate(timeCreated),
      'isRead': isRead,
      'isEdited': isEdited,
    };
  }

  // Optional copyWith for updates
  Message copyWith({
    String? id,
    String? content,
    String? senderId,
    String? receiverId,
    DateTime? timeCreated,
    bool? isRead,
    bool? isEdited,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      timeCreated: timeCreated ?? this.timeCreated,
      isRead: isRead ?? this.isRead,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
