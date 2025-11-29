import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_bloc.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_event.dart';
import 'package:depi_graduation_project/bloc/chatlist/chatlist_state.dart';
import 'package:depi_graduation_project/models/chat_room.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockChatRoomFirestoreService extends Mock
    implements ChatRoomFirestoreService {}

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUser extends Mock implements User {}

void main() {
  late ChatListBloc chatListBloc;
  late MockChatRoomFirestoreService mockChatRoomService;
  late MockAuthenticationService mockAuthService;
  late MockUser mockUser;

  setUp(() {
    mockChatRoomService = MockChatRoomFirestoreService();
    mockAuthService = MockAuthenticationService();
    mockUser = MockUser();

    when(() => mockAuthService.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    registerFallbackValue(mockUser);

    chatListBloc = ChatListBloc(
      chatRoomService: mockChatRoomService,
      auth: mockAuthService,
    );
  });

  tearDown(() {
    chatListBloc.close();
  });

  group('ChatListBloc', () {
    test('initial state is ChatListInitial', () {
      expect(chatListBloc.state, isA<ChatListInitial>());
    });

    blocTest<ChatListBloc, ChatListState>(
      'emits ChatListLoading then ChatListLoaded when LoadChatRooms succeeds',
      setUp: () {
        final chatRooms = [
          ChatRoom(
            id: 'room1',
            members: ['uid1', 'uid2'],
            timeCreated: DateTime.now(),
            lastMessage: 'Hello',
            lastMessageTime: DateTime.now(),
          ),
        ];
        when(() => mockChatRoomService.getChatRoomStream(any()))
            .thenAnswer((_) => Stream.value(chatRooms));
      },
      build: () => chatListBloc,
      act: (bloc) => bloc.add(LoadChatRooms()),
      expect: () => [
        isA<ChatListLoading>(),
        isA<ChatListLoaded>(),
      ],
      verify: (_) {
        verify(() => mockChatRoomService.getChatRoomStream('test-uid'))
            .called(1);
      },
    );

    blocTest<ChatListBloc, ChatListState>(
      'emits ChatListError when LoadChatRooms fails',
      setUp: () {
        when(() => mockChatRoomService.getChatRoomStream(any()))
            .thenAnswer((_) => Stream.error(Exception('Error loading rooms')));
      },
      build: () => chatListBloc,
      act: (bloc) => bloc.add(LoadChatRooms()),
      expect: () => [
        isA<ChatListLoading>(),
        isA<ChatListError>(),
      ],
    );

    blocTest<ChatListBloc, ChatListState>(
      'emits ChatListLoaded when ChatRoomsUpdated is added',
      setUp: () {
        final chatRooms = [
          ChatRoom(
            id: 'room1',
            members: ['uid1', 'uid2'],
            timeCreated: DateTime.now(),
            lastMessage: 'Hello',
            lastMessageTime: DateTime.now(),
          ),
        ];
        when(() => mockChatRoomService.getChatRoomStream(any()))
            .thenAnswer((_) => Stream.value(chatRooms));
      },
      build: () => chatListBloc,
      seed: () => ChatListLoaded(chatRooms: []),
      act: (bloc) {
        final chatRooms = [
          ChatRoom(
            id: 'room1',
            members: ['uid1', 'uid2'],
            timeCreated: DateTime.now(),
            lastMessage: 'Hello',
            lastMessageTime: DateTime.now(),
          ),
        ];
        bloc.add(ChatRoomsUpdated(chatRooms: chatRooms));
      },
      expect: () => [
        isA<ChatListLoaded>(),
      ],
    );

    blocTest<ChatListBloc, ChatListState>(
      'calls deleteChatRoom when DeleteChatRoom is added',
      setUp: () {
        when(() => mockChatRoomService.deleteChatRoom(any()))
            .thenAnswer((_) async => {});
        when(() => mockChatRoomService.getChatRoomStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatListBloc,
      act: (bloc) => bloc.add(DeleteChatRoom(chatRoomId: 'room1')),
      verify: (_) {
        verify(() => mockChatRoomService.deleteChatRoom('room1')).called(1);
      },
    );

    blocTest<ChatListBloc, ChatListState>(
      'emits ChatListError when DeleteChatRoom fails',
      setUp: () {
        when(() => mockChatRoomService.deleteChatRoom(any()))
            .thenThrow(Exception('Delete failed'));
        when(() => mockChatRoomService.getChatRoomStream(any()))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => chatListBloc,
      act: (bloc) => bloc.add(DeleteChatRoom(chatRoomId: 'room1')),
      expect: () => [
        isA<ChatListError>(),
      ],
    );
  });
}

