import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_event.dart';
import 'package:depi_graduation_project/bloc/notifications/notifications_state.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationFirestoreService notificationService;
  final AuthenticationService auth;

  NotificationsBloc({
    required this.notificationService,
    required this.auth,
  }) : super(LoadingNotifications()) {
    on<LoadNotifications>((event, emit) async {
      await emit.forEach(
        notificationService.getNotificationsStream(
          receiverId: auth.currentUser!.uid,
        ),
        onData: (notifications) {
          final unreadCount = notifications.where((n) => !n.isRead).length;
          return DisplayNotifications(
            notifications: notifications,
            unreadCount: unreadCount,
          );
        },
      );
    });

    on<MarkNotificationAsRead>((event, emit) async {
      await notificationService.markAsRead(
        notificationId: event.notificationId,
      );
    });

    on<MarkAllAsRead>((event, emit) async {
      emit(LoadingNotifications());
      await notificationService.markAllAsRead(
        receiverId: auth.currentUser!.uid,
      );
      add(LoadNotifications());
    });

    on<DeleteNotification>((event, emit) async {
      await notificationService.deleteNotification(
        notificationId: event.notificationId,
      );
    });

    add(LoadNotifications());
  }
}

