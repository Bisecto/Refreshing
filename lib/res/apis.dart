class AppApis {
  static String appBaseUrl = "https://api.tellatrust.com";

  ///Authentication Endpoints
  static String signUpApi = "$appBaseUrl/auth/c/register";
  static String verifyEmail = "$appBaseUrl/auth/c/verify-email";
  static String verifyPhone = "$appBaseUrl/auth/c/verify-phone";
  static String verifyDeviceChange = "$appBaseUrl/auth/c/change-device";
  static String createAccessPin = "$appBaseUrl/auth/c/access-pin";
  static String sendPhoneToken = "$appBaseUrl/auth/c/send-token";
  static String resetPassword = "$appBaseUrl/auth/c/reset-password";
  static String changePassword = "$appBaseUrl/auth/c/change-password";
  static String changeAccessPin = "$appBaseUrl/auth/c/change-access-pin";
  static String login = "$appBaseUrl/auth/c/login-mobile";
  static String refreshTokenApi = "$appBaseUrl/auth/c/refresh-token";
  static String loginAccessPin = "$appBaseUrl/auth/c/login-access-pin";

  static String refreshToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0NmE3M2YwNy1lMWEyLTRkODUtYjFmNi0zNTM4ZTg0N2Q3MjkiLCJleHAiOjE3MTAxNTk0OTIsImlhdCI6MTcwNzU2NzQ5Mn0.QLpqzjkn9PSzI3tnyOL0rHxCPZUx9dEOw14W2EQtE_M";
}
