import 'dart:convert';

class LoginResponseModel {
  final Driver? driver;
  final String? refreshToken;
  String? accessToken;

  LoginResponseModel({
    this.driver,
    this.refreshToken,
    this.accessToken,
  });

  factory LoginResponseModel.fromRawJson(String str) => LoginResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "driver": driver?.toJson(),
        "refreshToken": refreshToken,
      };
}

class Driver {
  final DateTime? createdAt;
  final String? email;
  final String? id;
  final dynamic name;
  final String? phoneNumber;
  final bool? status;
  final DateTime? updatedAt;

  Driver({
    this.createdAt,
    this.email,
    this.id,
    this.name,
    this.phoneNumber,
    this.status,
    this.updatedAt,
  });

  factory Driver.fromRawJson(String str) => Driver.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        email: json["email"],
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        status: json["status"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "email": email,
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "status": status,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
