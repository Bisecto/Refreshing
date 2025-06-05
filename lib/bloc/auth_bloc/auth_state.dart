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

class AuthAuthenticated extends AuthState {
  final String token;
  final User user;
  final Position position;
  final Placemark placemark;

  AuthAuthenticated( {required this.token, required this.user, required this.position, required this.placemark,});
}
