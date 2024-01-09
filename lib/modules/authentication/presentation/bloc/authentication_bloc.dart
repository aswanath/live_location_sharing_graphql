import 'dart:async';

import 'package:fleety/core/network/graphql_client.dart';
import 'package:fleety/core/repository/ilocal_repository.dart';
import 'package:fleety/modules/authentication/data/models/registration_model.dart';
import 'package:fleety/modules/authentication/data/repository/iauthentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final IAuthenticationRepository _authenticationRepository;
  final ILocalRepository _localRepository;

  AuthenticationBloc(
    this._authenticationRepository,
    this._localRepository,
  ) : super(AuthenticationInitial()) {
    on<LoginTapped>(_onLoginTapped);
    on<LogoutTapped>(_onLogoutTapped);
    on<RegisterTapped>(_onRegisterTapped);
  }

  FutureOr<void> _onRegisterTapped(RegisterTapped event, emit) async {
    emit(AuthenticationLoading());
    final result = await _authenticationRepository.register(registrationModel: event.registrationModel);
    if (result.data != null) {
      emit(RegistrationSuccessfull());
    } else {
      emit(
        AuthenticationError(message: result.message),
      );
    }
  }

  FutureOr<void> _onLogoutTapped(LogoutTapped event, emit) async {
    String? refreshToken = _localRepository.getRefreshToken();
    if (refreshToken != null) {
      await _authenticationRepository.logout(token: refreshToken);
    }
    await _localRepository.clearData();

    emit(LogoutSuccessful());
  }

  FutureOr<void> _onLoginTapped(LoginTapped event, emit) async {
    emit(AuthenticationLoading());
    final response = await _authenticationRepository.login(
      email: event.email,
      password: event.password,
    );
    if (response.data != null) {
      await _localRepository.setRefreshToken(response.data!.refreshToken ?? "");
      await _localRepository.setAccessToken(response.data!.accessToken ?? "");
      emit(LoginSuccessful());
    } else {
      emit(
        AuthenticationError(message: response.message),
      );
    }
  }
}
