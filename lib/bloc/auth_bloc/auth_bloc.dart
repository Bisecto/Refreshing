import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:refreshing_co/model/user_data.dart';
import 'package:refreshing_co/model/user_model.dart';
import 'package:refreshing_co/res/apis.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/utills/shared_preferences.dart';

import '../../model/error_model.dart';
import '../../repository/auth_service.dart';
import '../../res/sharedpref_key.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    // on<VerifyOTPRequested>(_onVerifyOTPRequested);
    // on<ResendOTPRequested>(_onResendOTPRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

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
            message:
                json.decode(result.body)['message'] ?? 'OTP sent to your email',
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

  // Future<void> _onVerifyOTPRequested(
  //   VerifyOTPRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //
  //   try {
  //     final result = await _authService.verifyOTP({
  //       'email': event.email,
  //       'otp': event.otp,
  //     });
  //
  //     if (result['success'] == true) {
  //       // Save authentication data
  //       await _saveAuthData(result['token'], result['user']);
  //
  //       emit(
  //         AuthOTPVerificationSuccess(
  //           message: result['message'] ?? 'Account verified successfully',
  //         ),
  //       );
  //
  //       // Navigate to authenticated state
  //       emit(AuthAuthenticated(token: result['token'], user: result['user']));
  //     } else {
  //       emit(AuthError(message: result['message'] ?? 'Invalid OTP'));
  //     }
  //   } catch (e) {
  //     emit(AuthError(message: 'Network error. Please try again.'));
  //   }
  // }

  // Future<void> _onResendOTPRequested(
  //   ResendOTPRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //
  //   try {
  //     final result = await _authService.resendOTP({'email': event.email});
  //
  //     if (result['success'] == true) {
  //       emit(
  //         AuthSignUpSuccess(
  //           email: event.email,
  //           message: result['message'] ?? 'OTP resent successfully',
  //         ),
  //       );
  //     } else {
  //       emit(AuthError(message: result['message'] ?? 'Failed to resend OTP'));
  //     }
  //   } catch (e) {
  //     emit(AuthError(message: 'Network error. Please try again.'));
  //   }
  // }

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
        await _saveAuthData(userData.accessToken!, userData.toJson());
        emit(
          AuthSignInSuccess(token: userData.accessToken!, user: userData.user!),
        );
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(json.decode(result.body));
        emit(AuthError(message: errorModel.message ?? 'Invalid credentials'));
      }
      // if (result['success'] == true) {
      //   await _saveAuthData(result['token'], result['user']);
      //
      //   emit(AuthSignInSuccess(token: result['token'], user: result['user']));
      // } else {
      //   emit(AuthError(message: result['message'] ?? 'Invalid credentials'));
      // }
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
    try {
      final token = await SharedPref.getString(SharedPrefKey.authTokenKey);
      final userString = await SharedPref.getString(SharedPrefKey.userDataKey);
      print(userString);
      if (token.isNotEmpty && userString.isNotEmpty) {
        User user = User.fromJson(json.decode(userString)['user']);
        emit(AuthAuthenticated(token: token, user: user));
        print(user.email);
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> _saveAuthData(String token, Map<String, dynamic> user) async {
    await SharedPref.putString(SharedPrefKey.authTokenKey, token);
    await SharedPref.putString(SharedPrefKey.userDataKey, json.encode(user));
  }

  Future<void> _clearAuthData() async {
    AppUtils().logout();
  }
}
