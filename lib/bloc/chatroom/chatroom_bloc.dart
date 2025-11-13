import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/models/message.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'chatroom_event.dart';
import 'chatroom_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRoomFirestoreService service;
  final String chatRoomId;
  final String currentUserId;
  final String receiverId;

  ChatRoomBloc({
    required ChatRoomFirestoreService chatRoomService,
    required this.chatRoomId,
    required this.currentUserId,
    required this.receiverId,
  })  : service = chatRoomService,
        super(ChatRoomInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(ChatRoomLoading());
      await emit.forEach<List<Message>>(
        service.getMessagesStream(chatRoomId),
        onData: (messages) => ChatRoomLoaded(messages: messages),
        onError: (error, _) =>
            ChatRoomError(message: error.toString()),
      );
    });

    on<MessagesUpdated>((event, emit) {
      emit(ChatRoomLoaded(messages: event.messages));
    });

    on<SendMessage>((event, emit) async {
      if (event.content.trim().isEmpty) return;

      try {
        await service.addMessage(
          chatRoomId,
          event.content,
          currentUserId,
          receiverId,
        );
      } catch (e) {
        emit(ChatRoomError(message: 'Failed to send message: $e'));
      }
    });

    on<DeleteMessage>((event, emit) async {
      try {
        await service.deleteMessage(chatRoomId, event.messageId);
      } catch (e) {
        emit(ChatRoomError(message: 'Failed to delete message: $e'));
      }
    });

    on<EditMessage>((event, emit) async {
      try {
        await service.updateMessage(
          chatRoomId,
          event.messageId,
          event.newContent,
        );
      } catch (e) {
        emit(ChatRoomError(message: 'Failed to edit message: $e'));
      }
    });

    on<MarkMessagesAsRead>((event, emit) async {
      try {
        await service.markAllAsRead(chatRoomId, currentUserId);
      } catch (e) {
        // no state change, just surface the issue in logs if needed
      }
    });

    add(LoadMessages());
  }
}