class AppApis {
  static String appBaseUrl = "https://api.refreshandco.com";

  ///Authentication Endpoints
  static String signUpApi = "$appBaseUrl/api/v1/auth/register";

  static String verifyResetPasswordCode = "$appBaseUrl/api/v1/auth/verify-reset-code";
  static String resetPassword = "$appBaseUrl/api/v1/auth/reset-password";
  static String changePassword = "$appBaseUrl/api/v1/auth/change-password";
  static String forgotPassword = "$appBaseUrl/api/v1/auth/forgot-password";
  static String login = "$appBaseUrl/api/v1/auth/login";
  static String logOut = "$appBaseUrl/api/v1/auth/logout-all";
  static String verifyOTP = "$appBaseUrl/api/v1/auth/verify-otp";
  static String resendOTP = "$appBaseUrl/api/v1/auth/resend-otp";
  static String refreshTokenApi = "$appBaseUrl/api/v1/auth/refresh";

  static String refreshToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0NmE3M2YwNy1lMWEyLTRkODUtYjFmNi0zNTM4ZTg0N2Q3MjkiLCJleHAiOjE3MTAxNTk0OTIsImlhdCI6MTcwNzU2NzQ5Mn0.QLpqzjkn9PSzI3tnyOL0rHxCPZUx9dEOw14W2EQtE_M";
}
