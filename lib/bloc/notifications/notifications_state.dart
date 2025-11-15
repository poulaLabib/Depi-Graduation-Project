import 'package:depi_graduation_project/models/notification.dart';

abstract class NotificationsState {}

class LoadingNotifications extends NotificationsState {}

class DisplayNotifications extends NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  DisplayNotifications({
    required this.notifications,
    required this.unreadCount,
  });
}

class ErrorLoadingNotifications extends NotificationsState {
  final String message;

  ErrorLoadingNotifications({required this.message});
}

