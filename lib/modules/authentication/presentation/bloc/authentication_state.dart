part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class RegistrationSuccessfull extends AuthenticationState {}

class LoginSuccessful extends AuthenticationState {}

class LogoutSuccessful extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError({
    required this.message,
  });
}
