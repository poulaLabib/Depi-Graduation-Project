import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> members;
  final DateTime timeCreated;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<String> participantsNames;
  final int unreadCount;
  final String? targetName;
  final String? targetPhotoUrl;

  ChatRoom({
    required this.id,
    required this.members,
    required this.timeCreated,
    required this.lastMessage,
    required this.lastMessageTime,
    this.participantsNames = const [],
    this.unreadCount = 0,
    this.targetName,
    this.targetPhotoUrl,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      timeCreated: (map['timeCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      participantsNames: List<String>.from(
        map['participantsNames'] ?? const <String>[],
      ),
      unreadCount: (map['unreadCount'] ?? 0) as int,
      targetName: map['targetName'] as String?,
      targetPhotoUrl: map['targetPhotoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'members': members,
      'timeCreated': Timestamp.fromDate(timeCreated),
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'participantsNames': participantsNames,
      'unreadCount': unreadCount,
      'targetName': targetName,
      'targetPhotoUrl': targetPhotoUrl,
    };
  }

  ChatRoom copyWith({
    String? id,
    List<String>? members,
    DateTime? timeCreated,
    String? lastMessage,
    DateTime? lastMessageTime,
    List<String>? participantsNames,
    int? unreadCount,
    String? targetName,
    String? targetPhotoUrl,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      members: members ?? this.members,
      timeCreated: timeCreated ?? this.timeCreated,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      participantsNames: participantsNames ?? this.participantsNames,
      unreadCount: unreadCount ?? this.unreadCount,
      targetName: targetName ?? this.targetName,
      targetPhotoUrl: targetPhotoUrl ?? this.targetPhotoUrl,
    );
  }

  String get initials {
    final name = targetName ?? '';
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String get lastMessageTimeFormatted {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inDays == 0) {
      final hour = lastMessageTime.hour;
      final minute = lastMessageTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[lastMessageTime.weekday - 1];
    } else {
      return '${lastMessageTime.day}/${lastMessageTime.month}/${lastMessageTime.year}';
    }
  }

  String otherParticipantId(String currentUserId) {
    return members.firstWhere(
      (member) => member != currentUserId,
      orElse: () => '',
    );
  }
}
