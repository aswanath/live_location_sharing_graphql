import 'dart:convert';

class VehicleDetailsModel {
  final String? color;
  final String? id;
  final String? licencePlate;
  final String? model;
  final String? name;
  final int? year;

  VehicleDetailsModel({
    this.color,
    this.id,
    this.licencePlate,
    this.model,
    this.name,
    this.year,
  });

  factory VehicleDetailsModel.fromRawJson(String str) => VehicleDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) => VehicleDetailsModel(
        color: json["color"],
        id: json["id"],
        licencePlate: json["licencePlate"],
        model: json["model"],
        name: json["name"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "licencePlate": licencePlate,
        "model": model,
        "name": name,
        if (year != null) "year": year!.toString(),
      };
}
