import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/notification/notification_model.dart';
import '../../repository/auth_service.dart';
import '../../repository/notification_service.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/shared_preferences.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;
  List<NotificationModel> _currentNotifications = [];
  int _currentUnreadCount = 0;
  final AuthRepository authService;
  bool _useAutoTokens = true;
  NotificationBloc({required NotificationService notificationService, required this.authService,

    bool useAutoTokens = true,})
    :_useAutoTokens = useAutoTokens, _notificationService = notificationService,
      super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<LoadUnreadCountEvent>(_onLoadUnreadCount);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllAsRead);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<RefreshNotificationsEvent>(_onRefreshNotifications);
  }

  // Getters for accessing current state
  List<NotificationModel> get currentNotifications => _currentNotifications;

  int get currentUnreadCount => _currentUnreadCount;

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final response = await _notificationService.getNotifications(token);

      _currentNotifications = response.notifications;
      _currentUnreadCount = response.unreadCount;

      emit(
        NotificationLoaded(
          notifications: _currentNotifications,
          unreadCount: _currentUnreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onLoadUnreadCount(
    LoadUnreadCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final response = await _notificationService.getUnreadCount(token);
      _currentUnreadCount = response.unreadCount;

      emit(UnreadCountLoaded(unreadCount: _currentUnreadCount));
    } catch (e) {
      // Silently fail for unread count as it's not critical
      emit(UnreadCountLoaded(unreadCount: 0));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationMarkingAsRead());
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _notificationService.markAllAsRead(token);

      if (result['success'] == true) {
        // Update local state
        _currentNotifications =
            _currentNotifications
                .map((notification) => notification.copyWith(isRead: true))
                .toList();
        _currentUnreadCount = 0;

        emit(
          NotificationMarkedAsRead(message: 'All notifications marked as read'),
        );
        emit(
          NotificationLoaded(
            notifications: _currentNotifications,
            unreadCount: _currentUnreadCount,
          ),
        );
      } else {
        emit(
          NotificationError(
            message:
                result['message'] ?? 'Failed to mark notifications as read',
          ),
        );
      }
    } catch (e) {
      emit(NotificationError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Optimistically update the UI
      final updatedNotifications =
          _currentNotifications.map((notification) {
            if (notification.id == event.notificationId &&
                !notification.isRead) {
              _currentUnreadCount =
                  _currentUnreadCount > 0 ? _currentUnreadCount - 1 : 0;
              return notification.copyWith(isRead: true);
            }
            return notification;
          }).toList();

      _currentNotifications = updatedNotifications;

      emit(
        NotificationLoaded(
          notifications: _currentNotifications,
          unreadCount: _currentUnreadCount,
        ),
      );

      // Make API call in background
      try {
        String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

        await _notificationService.markNotificationAsRead(
          event.notificationId,
          token,
        );
      } catch (e) {
        // If API call fails, revert the optimistic update
        final revertedNotifications =
            _currentNotifications.map((notification) {
              if (notification.id == event.notificationId) {
                _currentUnreadCount++;
                return notification.copyWith(isRead: false);
              }
              return notification;
            }).toList();

        _currentNotifications = revertedNotifications;

        emit(
          NotificationLoaded(
            notifications: _currentNotifications,
            unreadCount: _currentUnreadCount,
          ),
        );
      }
    } catch (e) {
      emit(NotificationError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final response = await _notificationService.getNotifications(token);

      _currentNotifications = response.notifications;
      _currentUnreadCount = response.unreadCount;

      emit(
        NotificationLoaded(
          notifications: _currentNotifications,
          unreadCount: _currentUnreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationError(message: _getErrorMessage(e)));
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().toLowerCase().contains('network') ||
        error.toString().toLowerCase().contains('connection')) {
      return 'Network error. Please check your connection and try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
