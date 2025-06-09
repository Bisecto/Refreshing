import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/notification/notification_setting.dart';
import '../../repository/auth_service.dart';
import '../../repository/notification_setting_service.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/shared_preferences.dart';
import 'notification_settings_event.dart';
import 'notification_settings_state.dart';

class NotificationSettingsBloc extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final NotificationSettingsService _settingsService;
  NotificationSettingsModel? _currentSettings;
  NotificationSettingsModel? _originalSettings;
  final AuthRepository authService;
  bool _useAutoTokens = true;
  NotificationSettingsBloc({required NotificationSettingsService settingsService, required this.authService,

    bool useAutoTokens = true,})
      : _useAutoTokens = useAutoTokens,_settingsService = settingsService,
        super(NotificationSettingsInitial()) {
    on<LoadNotificationSettingsEvent>(_onLoadSettings);
    on<UpdateNotificationSettingEvent>(_onUpdateSetting);
    on<UpdateAllNotificationsEvent>(_onUpdateAllNotifications);
    on<SaveNotificationSettingsEvent>(_onSaveSettings);
    on<ResetNotificationSettingsEvent>(_onResetSettings);
  }

  // Getters for accessing current state
  NotificationSettingsModel? get currentSettings => _currentSettings;
  bool get hasUnsavedChanges => _currentSettings != _originalSettings;

  Future<void> _onLoadSettings(
      LoadNotificationSettingsEvent event,
      Emitter<NotificationSettingsState> emit,
      ) async {
    try {
      emit(NotificationSettingsLoading());
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final settings = await _settingsService.getNotificationSettings(token);
      _currentSettings = settings;
      _originalSettings = settings;

      emit(NotificationSettingsLoaded(settings: settings));
    } catch (e) {
      emit(NotificationSettingsError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onUpdateSetting(
      UpdateNotificationSettingEvent event,
      Emitter<NotificationSettingsState> emit,
      ) async {
    if (_currentSettings == null) return;

    try {
      // Update the specific setting
      NotificationSettingsModel updatedSettings;

      switch (event.settingKey) {
        case 'allNotifications':
          updatedSettings = _currentSettings!.copyWith(allNotifications: event.value);
          // If turning off all notifications, turn off all individual settings too
          if (!event.value) {
            updatedSettings = _turnOffAllSettings(updatedSettings);
          }
          break;
        case 'orderReady':
          updatedSettings = _currentSettings!.copyWith(orderReady: event.value);
          break;
        case 'paymentSuccessful':
          updatedSettings = _currentSettings!.copyWith(paymentSuccessful: event.value);
          break;
        case 'orderCancelled':
          updatedSettings = _currentSettings!.copyWith(orderCancelled: event.value);
          break;
        case 'subscriptionDue':
          updatedSettings = _currentSettings!.copyWith(subscriptionDue: event.value);
          break;
        case 'subscriptionExpired':
          updatedSettings = _currentSettings!.copyWith(subscriptionExpired: event.value);
          break;
        case 'promotions':
          updatedSettings = _currentSettings!.copyWith(promotions: event.value);
          break;
        case 'newProducts':
          updatedSettings = _currentSettings!.copyWith(newProducts: event.value);
          break;
        case 'specialOffers':
          updatedSettings = _currentSettings!.copyWith(specialOffers: event.value);
          break;
        case 'accountUpdates':
          updatedSettings = _currentSettings!.copyWith(accountUpdates: event.value);
          break;
        case 'securityAlerts':
          updatedSettings = _currentSettings!.copyWith(securityAlerts: event.value);
          break;
        case 'deliveryUpdates':
          updatedSettings = _currentSettings!.copyWith(deliveryUpdates: event.value);
          break;
        case 'estimatedDelivery':
          updatedSettings = _currentSettings!.copyWith(estimatedDelivery: event.value);
          break;
        case 'reviewReminders':
          updatedSettings = _currentSettings!.copyWith(reviewReminders: event.value);
          break;
        case 'emailNotifications':
          updatedSettings = _currentSettings!.copyWith(emailNotifications: event.value);
          break;
        case 'pushNotifications':
          updatedSettings = _currentSettings!.copyWith(pushNotifications: event.value);
          break;
        case 'smsNotifications':
          updatedSettings = _currentSettings!.copyWith(smsNotifications: event.value);
          break;
        default:
          return;
      }

      // Check if turning on any setting should enable "all notifications"
      if (event.value && !updatedSettings.allNotifications && _hasAnyNotificationEnabled(updatedSettings)) {
        updatedSettings = updatedSettings.copyWith(allNotifications: true);
      }

      _currentSettings = updatedSettings;

      emit(NotificationSettingsLoaded(
        settings: updatedSettings,
        hasUnsavedChanges: _hasChanges(),
      ));
    } catch (e) {
      emit(NotificationSettingsError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onUpdateAllNotifications(
      UpdateAllNotificationsEvent event,
      Emitter<NotificationSettingsState> emit,
      ) async {
    if (_currentSettings == null) return;

    try {
      NotificationSettingsModel updatedSettings = _currentSettings!.copyWith(
        allNotifications: event.value,
      );

      // If turning off all notifications, turn off all individual settings
      if (!event.value) {
        updatedSettings = _turnOffAllSettings(updatedSettings);
      } else {
        // If turning on all notifications, turn on key settings
        updatedSettings = _turnOnKeySettings(updatedSettings);
      }

      _currentSettings = updatedSettings;

      emit(NotificationSettingsLoaded(
        settings: updatedSettings,
        hasUnsavedChanges: _hasChanges(),
      ));
    } catch (e) {
      emit(NotificationSettingsError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onSaveSettings(
      SaveNotificationSettingsEvent event,
      Emitter<NotificationSettingsState> emit,
      ) async {
    if (_currentSettings == null) return;

    try {
      emit(NotificationSettingsSaving());
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _settingsService.updateNotificationSettings(_currentSettings!,token);

      if (result['success'] == true) {
        _originalSettings = _currentSettings;
        emit(NotificationSettingsSaved(message: 'Settings saved successfully'));
        emit(NotificationSettingsLoaded(
          settings: _currentSettings!,
          hasUnsavedChanges: false,
        ));
      } else {
        emit(NotificationSettingsUpdateFailed(
          message: result['message'] ?? 'Failed to save settings',
        ));
        emit(NotificationSettingsLoaded(
          settings: _currentSettings!,
          hasUnsavedChanges: _hasChanges(),
        ));
      }
    } catch (e) {
      emit(NotificationSettingsUpdateFailed(message: _getErrorMessage(e)));
      emit(NotificationSettingsLoaded(
        settings: _currentSettings!,
        hasUnsavedChanges: _hasChanges(),
      ));
    }
  }

  Future<void> _onResetSettings(
      ResetNotificationSettingsEvent event,
      Emitter<NotificationSettingsState> emit,
      ) async {
    if (_originalSettings == null) return;

    _currentSettings = _originalSettings;
    emit(NotificationSettingsLoaded(
      settings: _currentSettings!,
      hasUnsavedChanges: false,
    ));
  }

  // Helper methods
  NotificationSettingsModel _turnOffAllSettings(NotificationSettingsModel settings) {
    return settings.copyWith(
      orderReady: false,
      paymentSuccessful: false,
      orderCancelled: false,
      subscriptionDue: false,
      subscriptionExpired: false,
      promotions: false,
      newProducts: false,
      specialOffers: false,
      accountUpdates: false,
      securityAlerts: false,
      deliveryUpdates: false,
      estimatedDelivery: false,
      reviewReminders: false,
      emailNotifications: false,
      pushNotifications: false,
      smsNotifications: false,
    );
  }

  NotificationSettingsModel _turnOnKeySettings(NotificationSettingsModel settings) {
    return settings.copyWith(
      orderReady: true,
      paymentSuccessful: true,
      deliveryUpdates: true,
      securityAlerts: true,
      pushNotifications: true,
      emailNotifications: true,
    );
  }

  bool _hasAnyNotificationEnabled(NotificationSettingsModel settings) {
    return settings.orderReady ||
        settings.paymentSuccessful ||
        settings.orderCancelled ||
        settings.subscriptionDue ||
        settings.subscriptionExpired ||
        settings.promotions ||
        settings.newProducts ||
        settings.specialOffers ||
        settings.accountUpdates ||
        settings.securityAlerts ||
        settings.deliveryUpdates ||
        settings.estimatedDelivery ||
        settings.reviewReminders;
  }

  bool _hasChanges() {
    if (_originalSettings == null || _currentSettings == null) return false;
    return _originalSettings!.toUpdateJson().toString() != _currentSettings!.toUpdateJson().toString();
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().toLowerCase().contains('network') ||
        error.toString().toLowerCase().contains('connection')) {
      return 'Network error. Please check your connection and try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}