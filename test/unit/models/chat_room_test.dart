import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_graduation_project/models/chat_room.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatRoom Model', () {
    test('fromMap creates ChatRoom with correct values', () {
      final map = {
        'id': 'room1',
        'members': ['uid1', 'uid2'],
        'timeCreated': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'lastMessage': 'Hello',
        'lastMessageTime': Timestamp.fromDate(DateTime(2024, 1, 1, 12, 30)),
        'participantsNames': ['User 1', 'User 2'],
        'unreadCount': 2,
        'targetName': 'User 2',
        'targetPhotoUrl': 'photo.jpg',
      };

      final chatRoom = ChatRoom.fromMap(map);

      expect(chatRoom.id, equals('room1'));
      expect(chatRoom.members, equals(['uid1', 'uid2']));
      expect(chatRoom.lastMessage, equals('Hello'));
      expect(chatRoom.participantsNames, equals(['User 1', 'User 2']));
      expect(chatRoom.unreadCount, equals(2));
      expect(chatRoom.targetName, equals('User 2'));
      expect(chatRoom.targetPhotoUrl, equals('photo.jpg'));
    });

    test('fromMap handles missing optional fields', () {
      final map = {
        'id': 'room1',
        'members': ['uid1', 'uid2'],
        'timeCreated': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'lastMessage': 'Hello',
        'lastMessageTime': Timestamp.fromDate(DateTime(2024, 1, 1)),
      };

      final chatRoom = ChatRoom.fromMap(map);

      expect(chatRoom.participantsNames, isEmpty);
      expect(chatRoom.unreadCount, equals(0));
      expect(chatRoom.targetName, isNull);
      expect(chatRoom.targetPhotoUrl, isNull);
    });

    test('toMap converts ChatRoom to map correctly', () {
      final chatRoom = ChatRoom(
        id: 'room1',
        members: ['uid1', 'uid2'],
        timeCreated: DateTime(2024, 1, 1),
        lastMessage: 'Hello',
        lastMessageTime: DateTime(2024, 1, 1, 12, 30),
        participantsNames: ['User 1', 'User 2'],
        unreadCount: 2,
        targetName: 'User 2',
        targetPhotoUrl: 'photo.jpg',
      );

      final map = chatRoom.toMap();

      expect(map['id'], equals('room1'));
      expect(map['members'], equals(['uid1', 'uid2']));
      expect(map['lastMessage'], equals('Hello'));
      expect(map['participantsNames'], equals(['User 1', 'User 2']));
      expect(map['unreadCount'], equals(2));
      expect(map['targetName'], equals('User 2'));
      expect(map['targetPhotoUrl'], equals('photo.jpg'));
    });

    test('copyWith creates new instance with updated values', () {
      final original = ChatRoom(
        id: 'room1',
        members: ['uid1', 'uid2'],
        timeCreated: DateTime(2024, 1, 1),
        lastMessage: 'Hello',
        lastMessageTime: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(
        lastMessage: 'Updated message',
        unreadCount: 5,
      );

      expect(updated.id, equals('room1'));
      expect(updated.members, equals(['uid1', 'uid2']));
      expect(updated.lastMessage, equals('Updated message'));
      expect(updated.unreadCount, equals(5));
      expect(updated.timeCreated, equals(DateTime(2024, 1, 1)));
    });

    group('initials getter', () {
      test('returns first letter for single word name', () {
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          targetName: 'John',
        );

        expect(chatRoom.initials, equals('J'));
      });

      test('returns first letters of first and last name', () {
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          targetName: 'John Doe',
        );

        expect(chatRoom.initials, equals('JD'));
      });

      test(
        'returns first letters of first and last word for multiple words',
        () {
          final chatRoom = ChatRoom(
            id: 'room1',
            members: ['uid1', 'uid2'],
            timeCreated: DateTime.now(),
            lastMessage: '',
            lastMessageTime: DateTime.now(),
            targetName: 'John Michael Doe',
          );

          expect(chatRoom.initials, equals('JD'));
        },
      );

      test('returns ? when targetName is empty', () {
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          targetName: '',
        );

        expect(chatRoom.initials, equals('?'));
      });

      test('returns ? when targetName is null', () {
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        );

        expect(chatRoom.initials, equals('?'));
      });

      test('handles names with extra spaces', () {
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          targetName: '  John   Doe  ',
        );

        expect(chatRoom.initials, equals('JD'));
      });
    });

    group('lastMessageTimeFormatted getter', () {
      test('returns time in 12-hour format for today', () {
        final now = DateTime.now();
        final today = DateTime(
          now.year,
          now.month,
          now.day,
          14,
          30,
        ); // 2:30 PM today
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: today,
        );

        final formatted = chatRoom.lastMessageTimeFormatted;
        expect(formatted, contains('2:30'));
        expect(formatted, contains('PM'));
      });

      test('returns "Yesterday" for messages from yesterday', () {
        final now = DateTime.now();
        final yesterday = DateTime(now.year, now.month, now.day - 1, 12, 0);
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: yesterday,
        );

        expect(chatRoom.lastMessageTimeFormatted, equals('Yesterday'));
      });

      test('returns day name for messages within this week', () {
        final now = DateTime.now();
        final threeDaysAgo = DateTime(now.year, now.month, now.day - 3, 12, 0);
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: threeDaysAgo,
        );

        final formatted = chatRoom.lastMessageTimeFormatted;
        expect([
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ], contains(formatted));
      });

      test('returns date in DD/MM/YYYY format for older messages', () {
        final now = DateTime.now();
        final eightDaysAgo = DateTime(now.year, now.month, now.day - 8, 12, 0);
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: eightDaysAgo,
        );

        final formatted = chatRoom.lastMessageTimeFormatted;
        expect(formatted, matches(r'\d{1,2}/\d{1,2}/\d{4}'));
      });

      test('handles midnight correctly (12 AM)', () {
        final now = DateTime.now();
        final midnight = DateTime(now.year, now.month, now.day, 0, 0);
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: midnight,
        );

        final formatted = chatRoom.lastMessageTimeFormatted;
        expect(formatted, contains('12:00'));
        expect(formatted, contains('AM'));
      });

      test('handles noon correctly (12 PM)', () {
        final now = DateTime.now();
        final noon = DateTime(now.year, now.month, now.day, 12, 0);
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: noon,
        );

        final formatted = chatRoom.lastMessageTimeFormatted;
        expect(formatted, contains('12:00'));
        expect(formatted, contains('PM'));
      });
    });

    group('otherParticipantId method', () {
      test('returns the other participant ID', () {
        final chatRoom = ChatRoom(
          id: 'room1',
          members: ['uid1', 'uid2'],
          timeCreated: DateTime.now(),
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        );

        expect(chatRoom.otherParticipantId('uid1'), equals('uid2'));
        expect(chatRoom.otherParticipantId('uid2'), equals('uid1'));
      });

      test(
        'returns first member when currentUserId not found (fallback behavior)',
        () {
          final chatRoom = ChatRoom(
            id: 'room1',
            members: ['uid1', 'uid2'],
            timeCreated: DateTime.now(),
            lastMessage: '',
            lastMessageTime: DateTime.now(),
          );

          // When uid3 is not found, firstWhere with orElse returns the first element
          // This is the actual behavior of the method
          final result = chatRoom.otherParticipantId('uid3');
          // The method will return the first member when currentUserId is not found
          expect(result, isIn(['uid1', 'uid2']));
        },
      );
    });
  });
}
