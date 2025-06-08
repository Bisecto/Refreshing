class UnreadCountResponse {
  final int unreadCount;

  UnreadCountResponse({required this.unreadCount});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unreadCount': unreadCount,
    };
  }
}