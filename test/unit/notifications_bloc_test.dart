import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_bloc.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_event.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_state.dart';
import 'package:depi_graduation_project/models/notification.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockNotificationFirestoreService extends Mock
    implements NotificationFirestoreService {}

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUser extends Mock implements User {}

void main() {
  late NotificationsBloc notificationsBloc;
  late MockNotificationFirestoreService mockNotificationService;
  late MockAuthenticationService mockAuthService;
  late MockUser mockUser;

  setUp(() {
    mockNotificationService = MockNotificationFirestoreService();
    mockAuthService = MockAuthenticationService();
    mockUser = MockUser();

    when(() => mockAuthService.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    registerFallbackValue(mockUser);

    // Mock the stream that's called on initialization
    when(() => mockNotificationService.getNotificationsStream(
          receiverId: any(named: 'receiverId'),
        )).thenAnswer((_) => Stream.value([]));

    notificationsBloc = NotificationsBloc(
      notificationService: mockNotificationService,
      auth: mockAuthService,
    );
  });

  tearDown(() {
    notificationsBloc.close();
  });

  group('NotificationsBloc', () {
    test('initial state is LoadingNotifications', () {
      expect(notificationsBloc.state, isA<LoadingNotifications>());
    });

    blocTest<NotificationsBloc, NotificationsState>(
      'emits DisplayNotifications when LoadNotifications succeeds',
      setUp: () {
        final notifications = [
          NotificationModel(
            id: 'notif1',
            receiverId: 'test-uid',
            senderId: 'sender1',
            senderName: 'Sender',
            type: 'message',
            message: 'Hello',
            createdAt: DateTime.now(),
            isRead: false,
          ),
          NotificationModel(
            id: 'notif2',
            receiverId: 'test-uid',
            senderId: 'sender2',
            senderName: 'Sender 2',
            type: 'poke',
            message: 'Poked you',
            createdAt: DateTime.now(),
            isRead: true,
          ),
        ];
        when(() => mockNotificationService.getNotificationsStream(
              receiverId: any(named: 'receiverId'),
            )).thenAnswer((_) => Stream.value(notifications));
      },
      build: () => notificationsBloc,
      act: (bloc) => bloc.add(LoadNotifications()),
      expect: () => [
        isA<DisplayNotifications>(),
      ],
      verify: (_) {
        verify(() => mockNotificationService.getNotificationsStream(
              receiverId: 'test-uid',
            )).called(2); // Once on initialization, once in the test
      },
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'calculates unreadCount correctly',
      setUp: () {
        final notifications = [
          NotificationModel(
            id: 'notif1',
            receiverId: 'test-uid',
            senderId: 'sender1',
            senderName: 'Sender',
            type: 'message',
            message: 'Hello',
            createdAt: DateTime.now(),
            isRead: false,
          ),
          NotificationModel(
            id: 'notif2',
            receiverId: 'test-uid',
            senderId: 'sender2',
            senderName: 'Sender 2',
            type: 'poke',
            message: 'Poked you',
            createdAt: DateTime.now(),
            isRead: false,
          ),
          NotificationModel(
            id: 'notif3',
            receiverId: 'test-uid',
            senderId: 'sender3',
            senderName: 'Sender 3',
            type: 'message',
            message: 'Read',
            createdAt: DateTime.now(),
            isRead: true,
          ),
        ];
        when(() => mockNotificationService.getNotificationsStream(
              receiverId: any(named: 'receiverId'),
            )).thenAnswer((_) => Stream.value(notifications));
      },
      build: () => notificationsBloc,
      act: (bloc) => bloc.add(LoadNotifications()),
      expect: () => [
        predicate<DisplayNotifications>((state) => state.unreadCount == 2),
      ],
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'calls markAsRead when MarkNotificationAsRead is added',
      setUp: () {
        when(() => mockNotificationService.markAsRead(
              notificationId: any(named: 'notificationId'),
            )).thenAnswer((_) async => {});
        when(() => mockNotificationService.getNotificationsStream(
              receiverId: any(named: 'receiverId'),
            )).thenAnswer((_) => Stream.value([]));
      },
      build: () => notificationsBloc,
      act: (bloc) => bloc.add(MarkNotificationAsRead(notificationId: 'notif1')),
      verify: (_) {
        verify(() => mockNotificationService.markAsRead(
              notificationId: 'notif1',
            )).called(1);
      },
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'emits LoadingNotifications then reloads when MarkAllAsRead is added',
      setUp: () {
        when(() => mockNotificationService.markAllAsRead(
              receiverId: any(named: 'receiverId'),
            )).thenAnswer((_) async => {});
        when(() => mockNotificationService.getNotificationsStream(
              receiverId: any(named: 'receiverId'),
            )).thenAnswer((_) => Stream.value([]));
      },
      build: () => notificationsBloc,
      act: (bloc) => bloc.add(MarkAllAsRead()),
      expect: () => [
        isA<LoadingNotifications>(),
        isA<DisplayNotifications>(),
      ],
      verify: (_) {
        verify(() => mockNotificationService.markAllAsRead(
              receiverId: 'test-uid',
            )).called(1);
        verify(() => mockNotificationService.getNotificationsStream(
              receiverId: 'test-uid',
            )).called(2); // Once initially, once after markAllAsRead
      },
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'calls deleteNotification when DeleteNotification is added',
      setUp: () {
        when(() => mockNotificationService.deleteNotification(
              notificationId: any(named: 'notificationId'),
            )).thenAnswer((_) async => {});
        when(() => mockNotificationService.getNotificationsStream(
              receiverId: any(named: 'receiverId'),
            )).thenAnswer((_) => Stream.value([]));
      },
      build: () => notificationsBloc,
      act: (bloc) => bloc.add(DeleteNotification(notificationId: 'notif1')),
      verify: (_) {
        verify(() => mockNotificationService.deleteNotification(
              notificationId: 'notif1',
            )).called(1);
      },
    );
  });
}

