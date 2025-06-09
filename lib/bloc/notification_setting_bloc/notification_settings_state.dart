import '../../model/notification/notification_setting.dart';

abstract class NotificationSettingsState {}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final NotificationSettingsModel settings;
  final bool hasUnsavedChanges;

  NotificationSettingsLoaded({
    required this.settings,
    this.hasUnsavedChanges = false,
  });
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;

  NotificationSettingsError({required this.message});
}

class NotificationSettingsSaving extends NotificationSettingsState {}

class NotificationSettingsSaved extends NotificationSettingsState {
  final String message;

  NotificationSettingsSaved({required this.message});
}

class NotificationSettingsUpdateFailed extends NotificationSettingsState {
  final String message;

  NotificationSettingsUpdateFailed({required this.message});
}