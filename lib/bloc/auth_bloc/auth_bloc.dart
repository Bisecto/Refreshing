import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:refreshing_co/model/user_data.dart';
import 'package:refreshing_co/model/user_model.dart';
import 'package:refreshing_co/repository/auth_service.dart';
import 'package:refreshing_co/res/apis.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/utills/shared_preferences.dart';

import '../../model/error_model.dart';
import '../../res/sharedpref_key.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authService; // Use the enhanced AuthService

  AuthBloc({required AuthRepository authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<ForceLogout>(_onForceLogout);
  }

  // Keep your existing AuthRepository for backward compatibility
  AuthRepository authRepository = AuthRepository();

  Future<void> _onSignUpRequested(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      // Validate passwords match
      if (event.password != event.confirmPassword) {
        emit(AuthError(message: 'Passwords do not match'));
        return;
      }

      // Validate password strength
      if (event.password.length < 8) {
        emit(AuthError(message: 'Password must be at least 8 characters long'));
        return;
      }

      Map<String, String> data = {
        "email": event.email,
        "password": event.password,
        "confirmPassword": event.confirmPassword,
        "username": event.username,
      };

      final result = await authRepository.authPostRequest(
        data,
        AppApis.signUpApi,
      );

      if (result.statusCode == 200 || result.statusCode == 201) {
        emit(
          AuthSignUpSuccess(
            email: event.email,
            message: json.decode(result.body)['message'] ?? 'OTP sent to your email',
          ),
        );
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(json.decode(result.body));
        emit(AuthError(message: errorModel.message!));
      }
    } catch (e) {
      emit(AuthError(message: 'Network error. Please try again.'));
    }
  }

  Future<void> _onSignInRequested(
      SignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final result = await authRepository.authPostRequest({
        'email': event.email,
        'password': event.password,
      }, AppApis.login);

      if (result.statusCode == 200 || result.statusCode == 201) {
        UserData userData = UserData.fromJson(json.decode(result.body));

        // Save authentication data
        await _saveAuthData(
          userData.accessToken!,
          userData.refreshToken!,
          userData.toJson(),
        );

        // Get location (non-blocking)
        Position? position;
        Placemark? placemark;

        try {
          position = await AppUtils().determinePosition();
          if (position != null) {
            placemark = await AppUtils().getAddressFromLatLng(position);
          }
        } catch (e) {
          print('Location error during sign in: $e');
          // Continue without location - don't fail sign in for location issues
        }

        emit(
          AuthSignInSuccess(
            token: userData.accessToken!,
            user: userData.user!,
            position: position ?? _getDefaultPosition(),
            placemark: placemark ?? Placemark(),
          ),
        );
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(json.decode(result.body));
        emit(AuthError(message: errorModel.message ?? 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError(message: 'Network error. Please try again.'));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await _clearAuthData();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError(message: 'Failed to sign out'));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      print(14567);
      // Use the enhanced AuthService for token validation and refresh
      final tokenResult = await _authService.getValidToken();
print(tokenResult);
      if (tokenResult['success'] != true) {
        print('No valid token available: ${tokenResult['message']}');
        emit(AuthInitial());
        return;
      }

      final String token = tokenResult['token'];
      final bool wasRefreshed = tokenResult['refreshed'] ?? false;

      // Get user data (might be updated from token refresh)
      User user;
      if (tokenResult['user'] != null) {
        // Use updated user data from token refresh/validation
        user = User.fromJson(tokenResult['user']);
        // Update stored user data
        await SharedPref.putString(
          SharedPrefKey.userDataKey,
          json.encode({'user': tokenResult['user']}),
        );
      } else {
        // Fallback to stored user data
        final userString = await SharedPref.getString(SharedPrefKey.userDataKey);
        if (userString.isEmpty) {
          print('No user data available');
          emit(AuthInitial());
          return;
        }

        try {
          final userData = json.decode(userString);
          user = User.fromJson(userData['user']);
        } catch (e) {
          print('Invalid user data format: $e');
          emit(AuthInitial());
          return;
        }
      }

      // Get location (non-blocking)
      Position? position;
      Placemark? placemark;

      try {
        position = await AppUtils().determinePosition();
        if (position != null) {
          placemark = await AppUtils().getAddressFromLatLng(position);
        }
      } catch (e) {
        print('Location error: $e');
        // Continue without location - don't fail auth for location issues
      }

      // Emit authenticated state
      emit(
        AuthAuthenticated(
          position: position ?? _getDefaultPosition(),
          token: token,
          user: user,
          placemark: placemark ?? Placemark(),
          tokenWasRefreshed: wasRefreshed,
        ),
      );

      if (wasRefreshed) {
        print('Token was automatically refreshed during auth check');
      }

      print('Auth check successful for user: ${user.email}');
    } catch (e) {
      print('Auth check error: $e');
      emit(AuthInitial());
    }
  }

  Future<void> _onRefreshToken(
      RefreshTokenEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(TokenRefreshing());

    try {
      final result = await _authService.refreshToken();

      if (result['success'] == true) {
        final newToken = result['accessToken'];
        final userData = result['user'];

        if (userData != null) {
          final user = User.fromJson(userData);
          emit(TokenRefreshed(newToken: newToken, user: user));

          // Trigger auth check to update full state
          add(CheckAuthStatus());
        } else {
          emit(AuthError(message: 'Token refreshed but user data missing'));
        }
      } else {
        emit(AuthError(message: result['message'] ?? 'Token refresh failed'));
        // Force logout on refresh failure
        add(ForceLogout());
      }
    } catch (e) {
      emit(AuthError(message: 'Token refresh error: $e'));
      add(ForceLogout());
    }
  }

  Future<void> _onForceLogout(
      ForceLogout event,
      Emitter<AuthState> emit,
      ) async {
    try {
      // Clear all stored data
      await SharedPref.remove(SharedPrefKey.authTokenKey);
      await SharedPref.remove(SharedPrefKey.refreshTokenKey);
      await SharedPref.remove(SharedPrefKey.userDataKey);

      emit(AuthInitial());
      print('Force logout completed');
    } catch (e) {
      print('Error during force logout: $e');
      emit(AuthInitial());
    }
  }

  // Helper method to get default position when location fails
  Position _getDefaultPosition() {
    return Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  Future<void> _saveAuthData(
      String token,
      String refreshToken,
      Map<String, dynamic> user,
      ) async {
    await SharedPref.putString(SharedPrefKey.authTokenKey, token);
    await SharedPref.putString(SharedPrefKey.userDataKey, json.encode(user));
    await SharedPref.putString(SharedPrefKey.refreshTokenKey, refreshToken);
  }

  Future<void> _clearAuthData() async {
    AppUtils().logout();
  }
}
