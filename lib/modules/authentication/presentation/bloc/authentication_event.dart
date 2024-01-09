part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class LogoutTapped extends AuthenticationEvent {}

class LoginTapped extends AuthenticationEvent {
  final String email;
  final String password;

  LoginTapped({
    required this.password,
    required this.email,
  });
}

class RegisterTapped extends AuthenticationEvent {
  final RegistrationModel registrationModel;

  RegisterTapped({required this.registrationModel});
}
