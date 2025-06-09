abstract class NotificationSettingsEvent {}

class LoadNotificationSettingsEvent extends NotificationSettingsEvent {}

class UpdateNotificationSettingEvent extends NotificationSettingsEvent {
  final String settingKey;
  final bool value;

  UpdateNotificationSettingEvent({
    required this.settingKey,
    required this.value,
  });
}

class UpdateAllNotificationsEvent extends NotificationSettingsEvent {
  final bool value;

  UpdateAllNotificationsEvent({required this.value});
}

class SaveNotificationSettingsEvent extends NotificationSettingsEvent {}

class ResetNotificationSettingsEvent extends NotificationSettingsEvent {}
