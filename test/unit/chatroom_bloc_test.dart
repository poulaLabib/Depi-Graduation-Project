import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/chatroom/chatroom_bloc.dart';
import 'package:depi_graduation_project/bloc/chatroom/chatroom_event.dart';
import 'package:depi_graduation_project/bloc/chatroom/chatroom_state.dart';
import 'package:depi_graduation_project/models/message.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockChatRoomFirestoreService extends Mock
    implements ChatRoomFirestoreService {}

void main() {
  late ChatRoomBloc chatRoomBloc;
  late MockChatRoomFirestoreService mockChatRoomService;

  const chatRoomId = 'test-room-id';
  const currentUserId = 'current-user-id';
  const receiverId = 'receiver-user-id';

  setUp(() {
    mockChatRoomService = MockChatRoomFirestoreService();

    chatRoomBloc = ChatRoomBloc(
      chatRoomService: mockChatRoomService,
      chatRoomId: chatRoomId,
      currentUserId: currentUserId,
      receiverId: receiverId,
    );
  });

  tearDown(() {
    chatRoomBloc.close();
  });

  group('ChatRoomBloc', () {
    test('initial state is ChatRoomInitial', () {
      expect(chatRoomBloc.state, isA<ChatRoomInitial>());
    });

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits ChatRoomLoading then ChatRoomLoaded when LoadMessages succeeds',
      setUp: () {
        final messages = [
          Message(
            id: 'msg1',
            content: 'Hello',
            senderId: currentUserId,
            receiverId: receiverId,
            timeCreated: DateTime.now(),
            isRead: false,
            isEdited: false,
          ),
        ];
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value(messages));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(LoadMessages()),
      expect: () => [
        isA<ChatRoomLoading>(),
        isA<ChatRoomLoaded>(),
      ],
      verify: (_) {
        verify(() => mockChatRoomService.getMessagesStream(chatRoomId))
            .called(1);
      },
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits ChatRoomError when LoadMessages fails',
      setUp: () {
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.error(Exception('Error loading messages')));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(LoadMessages()),
      expect: () => [
        isA<ChatRoomLoading>(),
        isA<ChatRoomError>(),
      ],
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits ChatRoomLoaded when MessagesUpdated is added',
      setUp: () {
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      seed: () => ChatRoomLoaded(messages: []),
      act: (bloc) {
        final messages = [
          Message(
            id: 'msg1',
            content: 'Hello',
            senderId: currentUserId,
            receiverId: receiverId,
            timeCreated: DateTime.now(),
            isRead: false,
            isEdited: false,
          ),
        ];
        bloc.add(MessagesUpdated(messages));
      },
      expect: () => [
        isA<ChatRoomLoaded>(),
      ],
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'calls addMessage when SendMessage is added with non-empty content',
      setUp: () {
        when(() => mockChatRoomService.addMessage(
              any(),
              any(),
              any(),
              any(),
            )).thenAnswer((_) async => {});
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(SendMessage('Hello')),
      verify: (_) {
        verify(() => mockChatRoomService.addMessage(
              chatRoomId,
              'Hello',
              currentUserId,
              receiverId,
            )).called(1);
      },
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'does not call addMessage when SendMessage is added with empty content',
      setUp: () {
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(SendMessage('   ')),
      verify: (_) {
        verifyNever(() => mockChatRoomService.addMessage(
              any(),
              any(),
              any(),
              any(),
            ));
      },
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits ChatRoomError when SendMessage fails',
      setUp: () {
        when(() => mockChatRoomService.addMessage(
              any(),
              any(),
              any(),
              any(),
            )).thenThrow(Exception('Send failed'));
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(SendMessage('Hello')),
      expect: () => [
        isA<ChatRoomError>(),
      ],
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'calls deleteMessage when DeleteMessage is added',
      setUp: () {
        when(() => mockChatRoomService.deleteMessage(any(), any()))
            .thenAnswer((_) async => {});
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(DeleteMessage('msg1')),
      verify: (_) {
        verify(() => mockChatRoomService.deleteMessage(chatRoomId, 'msg1'))
            .called(1);
      },
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits ChatRoomError when DeleteMessage fails',
      setUp: () {
        when(() => mockChatRoomService.deleteMessage(any(), any()))
            .thenThrow(Exception('Delete failed'));
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(DeleteMessage('msg1')),
      expect: () => [
        isA<ChatRoomError>(),
      ],
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'calls updateMessage when EditMessage is added',
      setUp: () {
        when(() => mockChatRoomService.updateMessage(any(), any(), any()))
            .thenAnswer((_) async => {});
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(EditMessage(
            messageId: 'msg1',
            newContent: 'Updated message',
          )),
      verify: (_) {
        verify(() => mockChatRoomService.updateMessage(
              chatRoomId,
              'msg1',
              'Updated message',
            )).called(1);
      },
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits ChatRoomError when EditMessage fails',
      setUp: () {
        when(() => mockChatRoomService.updateMessage(any(), any(), any()))
            .thenThrow(Exception('Edit failed'));
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(EditMessage(
            messageId: 'msg1',
            newContent: 'Updated message',
          )),
      expect: () => [
        isA<ChatRoomError>(),
      ],
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'calls markAllAsRead when MarkMessagesAsRead is added',
      setUp: () {
        when(() => mockChatRoomService.markAllAsRead(any(), any()))
            .thenAnswer((_) async => {});
        when(() => mockChatRoomService.getMessagesStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatRoomBloc,
      act: (bloc) => bloc.add(MarkMessagesAsRead()),
      verify: (_) {
        verify(() => mockChatRoomService.markAllAsRead(chatRoomId, currentUserId))
            .called(1);
      },
    );
  });
}

