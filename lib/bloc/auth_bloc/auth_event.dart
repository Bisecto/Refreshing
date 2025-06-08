part of 'auth_bloc.dart';


abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class VerifyOTPRequested extends AuthEvent {
  final String email;
  final String otp;

  VerifyOTPRequested({
    required this.email,
    required this.otp,
  });
}

class ResendOTPRequested extends AuthEvent {
  final String email;

  ResendOTPRequested({required this.email});
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({
    required this.email,
    required this.password,
  });
}
class SignOutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class RefreshTokenEvent extends AuthEvent {}

class ForceLogout extends AuthEvent {}
