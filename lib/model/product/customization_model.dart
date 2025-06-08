class CustomizationModel {
  CustomizationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isRequired,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.productId,
    required this.options,
  });

  final String? id;
  final String? name;
  final String? type;
  final bool? isRequired;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productId;
  final List<Option> options;

  factory CustomizationModel.fromJson(Map<String, dynamic> json){
    return CustomizationModel(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      isRequired: json["isRequired"],
      isAvailable: json["isAvailable"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      productId: json["productId"],
      options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "isRequired": isRequired,
    "isAvailable": isAvailable,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "productId": productId,
    "options": options.map((x) => x?.toJson()).toList(),
  };

}

class Option {
  Option({
    required this.id,
    required this.name,
    required this.priceModifier,
    required this.isDefault,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.customizationId,
  });

  final String? id;
  final String? name;
  final String? priceModifier;
  final bool? isDefault;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? customizationId;

  factory Option.fromJson(Map<String, dynamic> json){
    return Option(
      id: json["id"],
      name: json["name"],
      priceModifier: json["priceModifier"],
      isDefault: json["isDefault"],
      isAvailable: json["isAvailable"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      customizationId: json["customizationId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "priceModifier": priceModifier,
    "isDefault": isDefault,
    "isAvailable": isAvailable,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "customizationId": customizationId,
  };

}
