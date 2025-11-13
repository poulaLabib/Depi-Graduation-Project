// chatlist_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/models/chat_room.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';

import 'chatlist_event.dart';
import 'chatlist_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRoomFirestoreService service;
  final AuthenticationService auth;

  ChatListBloc({
    required ChatRoomFirestoreService chatRoomService,
    required this.auth,
  })  : service = chatRoomService,
        super(ChatListInitial()) {
    on<LoadChatRooms>((event, emit) async {
      emit(ChatListLoading());
      await emit.forEach<List<ChatRoom>>(
        service.getChatRoomStream(auth.currentUser!.uid),
        onData: (rooms) => ChatListLoaded(chatRooms: rooms),
        onError: (error, _) =>
            ChatListError(message: error.toString()),
      );
    });

    on<ChatRoomsUpdated>((event, emit) {
      emit(ChatListLoaded(chatRooms: event.chatRooms));
    });

    on<DeleteChatRoom>((event, emit) async {
      try {
        await service.deleteChatRoom(event.chatRoomId);
      } catch (e) {
        emit(ChatListError(message: 'Failed to delete room: $e'));
      }
    });

    add(LoadChatRooms());
  }
}