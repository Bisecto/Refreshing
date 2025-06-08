// notification_state.dart
import '../../model/notification/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
  });
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}

class NotificationMarkingAsRead extends NotificationState {}

class NotificationMarkedAsRead extends NotificationState {
  final String message;

  NotificationMarkedAsRead({required this.message});
}

class UnreadCountLoaded extends NotificationState {
  final int unreadCount;

  UnreadCountLoaded({required this.unreadCount});
}