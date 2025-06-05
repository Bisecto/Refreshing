import 'package:refreshing_co/model/user_model.dart';

class UserData {
  UserData({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final User? user;
  final String? accessToken;
  final String? refreshToken;

  factory UserData.fromJson(Map<String, dynamic> json){
    return UserData(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };

}

