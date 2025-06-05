class ErrorModel {
  ErrorModel({
    required this.statusCode,
    required this.timestamp,
    required this.path,
    required this.method,
    required this.message,
    required this.error,
  });

  final int? statusCode;
  final DateTime? timestamp;
  final String? path;
  final String? method;
  final String? message;
  final String? error;

  factory ErrorModel.fromJson(Map<String, dynamic> json){
    return ErrorModel(
      statusCode: json["statusCode"],
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      path: json["path"],
      method: json["method"],
      message: json["message"],
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "timestamp": timestamp?.toIso8601String(),
    "path": path,
    "method": method,
    "message": message,
    "error": error,
  };

}
