abstract class NotificationsEvent {}

class LoadNotifications extends NotificationsEvent {}

class MarkNotificationAsRead extends NotificationsEvent {
  final String notificationId;

  MarkNotificationAsRead({required this.notificationId});
}

class MarkAllAsRead extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final String notificationId;

  DeleteNotification({required this.notificationId});
}

