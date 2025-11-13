import 'package:depi_graduation_project/models/message.dart';

abstract class ChatRoomEvent {}

class LoadMessages extends ChatRoomEvent {}

class MarkMessagesAsRead extends ChatRoomEvent {}

class SendMessage extends ChatRoomEvent {
  final String content;
  SendMessage(this.content);
}

class DeleteMessage extends ChatRoomEvent {
  final String messageId;
  DeleteMessage(this.messageId);
}

class EditMessage extends ChatRoomEvent {
  final String messageId;
  final String newContent;
  EditMessage({
    required this.messageId,
    required this.newContent,
  });
}

class MessagesUpdated extends ChatRoomEvent {
  final List<Message> messages;
  MessagesUpdated(this.messages);
}