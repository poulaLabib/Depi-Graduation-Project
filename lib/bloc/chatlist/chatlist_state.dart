// chatlist_state.dart
import 'package:depi_graduation_project/models/chat_room.dart';

abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatRoom> chatRooms;
  ChatListLoaded({required this.chatRooms});
}

class ChatListError extends ChatListState {
  final String message;
  ChatListError({required this.message});
}