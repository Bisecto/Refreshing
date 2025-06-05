class User {
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.birthDate,
    required this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.provider,
    required this.status,
    required this.emailVerified,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.createdBy,
    required this.workCafeId,
    required this.deletedAt,
    required this.deletedBy,
    required this.fullName,
    required this.createdAgo,
  });

  final String? id;
  final String email;
  final String? username;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic phoneNumber;
  final dynamic birthDate;
  final dynamic profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;
  final String? provider;
  final String? status;
  final bool? emailVerified;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic address;
  final dynamic createdBy;
  final dynamic workCafeId;
  final dynamic deletedAt;
  final dynamic deletedBy;
  final String? fullName;
  final String? createdAgo;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      phoneNumber: json["phoneNumber"],
      birthDate: json["birthDate"],
      profileImage: json["profileImage"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      role: json["role"],
      provider: json["provider"],
      status: json["status"],
      emailVerified: json["emailVerified"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      address: json["address"],
      createdBy: json["createdBy"],
      workCafeId: json["workCafeId"],
      deletedAt: json["deletedAt"],
      deletedBy: json["deletedBy"],
      fullName: json["fullName"],
      createdAgo: json["createdAgo"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "birthDate": birthDate,
    "profileImage": profileImage,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "role": role,
    "provider": provider,
    "status": status,
    "emailVerified": emailVerified,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "createdBy": createdBy,
    "workCafeId": workCafeId,
    "deletedAt": deletedAt,
    "deletedBy": deletedBy,
    "fullName": fullName,
    "createdAgo": createdAgo,
  };

}
