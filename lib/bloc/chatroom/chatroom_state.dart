import 'package:depi_graduation_project/models/message.dart';

abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final List<Message> messages;
  ChatRoomLoaded({required this.messages});
}

class ChatRoomError extends ChatRoomState {
  final String message;
  ChatRoomError({required this.message});
}