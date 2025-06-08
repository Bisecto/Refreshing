part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccess extends AuthState {
  final String email;
  final String message;

  AuthSignUpSuccess({required this.email, required this.message});
}

class AuthOTPVerificationSuccess extends AuthState {
  final String message;

  AuthOTPVerificationSuccess({required this.message});
}

class AuthSignInSuccess extends AuthState {
  final String token;
  final User user;
  final Position position;
  final Placemark placemark;

  AuthSignInSuccess({required this.token, required this.user,required this.position, required this.placemark,});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthSignedOut extends AuthState {}


class TokenRefreshing extends AuthState {}

class TokenRefreshed extends AuthState {
  final String newToken;
  final User user;

  TokenRefreshed({required this.newToken, required this.user});
}

class AuthAuthenticated extends AuthState {
  final Position position;
  final String token;
  final User user;
  final Placemark placemark;
  final bool tokenWasRefreshed;

  AuthAuthenticated({
    required this.position,
    required this.token,
    required this.user,
    required this.placemark,
    this.tokenWasRefreshed = false,
  });
}