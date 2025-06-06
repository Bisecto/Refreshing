class LocationModel {
  final String city;
  final String state;
  final String country;
  final String displayName;

  LocationModel({
    required this.city,
    required this.state,
    required this.country,
    required this.displayName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      displayName: json['displayName'] ?? '',
    );
  }
}