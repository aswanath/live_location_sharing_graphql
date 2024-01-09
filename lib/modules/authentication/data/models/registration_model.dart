class RegistrationModel {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  RegistrationModel({
    required this.password,
    required this.phoneNumber,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
    };
  }
}
