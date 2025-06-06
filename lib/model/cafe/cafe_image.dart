class CafeImage {
  final String id;
  final String url;
  final String altText;
  final bool isPrimary;
  final DateTime createdAt;
  final String cafeId;

  CafeImage({
    required this.id,
    required this.url,
    required this.altText,
    required this.isPrimary,
    required this.createdAt,
    required this.cafeId,
  });

  factory CafeImage.fromJson(Map<String, dynamic> json) {
    return CafeImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      altText: json['altText'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      cafeId: json['cafeId'] ?? '',
    );
  }

  factory CafeImage.empty() {
    return CafeImage(
      id: '',
      url: '',
      altText: '',
      isPrimary: false,
      createdAt: DateTime.now(),
      cafeId: '',
    );
  }
}
