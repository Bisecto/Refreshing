abstract class NotificationEvent {}

class LoadNotificationsEvent extends NotificationEvent {}

class LoadUnreadCountEvent extends NotificationEvent {}

class MarkAllNotificationsAsReadEvent extends NotificationEvent {}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsReadEvent({required this.notificationId});
}

class RefreshNotificationsEvent extends NotificationEvent {}

