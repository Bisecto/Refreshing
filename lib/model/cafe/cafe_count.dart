class CafeCount {
  final int reviews;
  final int products;

  CafeCount({
    required this.reviews,
    required this.products,
  });

  factory CafeCount.fromJson(Map<String, dynamic> json) {
    return CafeCount(
      reviews: json['reviews'] ?? 0,
      products: json['products'] ?? 0,
    );
  }
}
