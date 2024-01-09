import 'dart:convert';

class ProfileDetailsModel {
  final String? email;
  final String? id;
  final String? phoneNumber;
  final bool? status;
  final String? name;

  ProfileDetailsModel({
    this.email,
    this.id,
    this.phoneNumber,
    this.status,
    this.name,
  });

  factory ProfileDetailsModel.fromRawJson(String str) => ProfileDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) => ProfileDetailsModel(
        email: json["email"],
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        status: json["status"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "phoneNumber": phoneNumber,
        "status": status,
        "name": name,
      };
}
