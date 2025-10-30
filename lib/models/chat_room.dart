import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> members;
  final DateTime timeCreated;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatRoom({
    required this.id,
    required this.members,
    required this.timeCreated,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  // Factory constructor to create a ChatRoom from a Firestore map
  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      timeCreated: (map['timeCreated'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
    );
  }

  // Convert ChatRoom to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'members': members,
      'timeCreated': Timestamp.fromDate(timeCreated),
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }

  // Optional copyWith for updates
  ChatRoom copyWith({
    String? id,
    List<String>? members,
    DateTime? timeCreated,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      members: members ?? this.members,
      timeCreated: timeCreated ?? this.timeCreated,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}
