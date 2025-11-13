// chatlist_event.dart
import 'package:depi_graduation_project/models/chat_room.dart';

abstract class ChatListEvent {}

class LoadChatRooms extends ChatListEvent {}

class ChatRoomsUpdated extends ChatListEvent {
  final List<ChatRoom> chatRooms;
  ChatRoomsUpdated({required this.chatRooms});
}

class DeleteChatRoom extends ChatListEvent {
  final String chatRoomId;
  DeleteChatRoom({required this.chatRoomId});
}