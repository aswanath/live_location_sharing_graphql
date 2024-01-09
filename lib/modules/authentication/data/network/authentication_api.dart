import 'package:fleety/core/model/network_response_model.dart';
import 'package:fleety/core/repository/iremote_repository.dart';
import 'package:fleety/modules/authentication/data/models/login_response_model.dart';
import 'package:fleety/modules/authentication/data/models/registration_model.dart';
import 'package:injectable/injectable.dart';

const String _kEmail = "email";
const String _kPassword = "password";
const String _kLogin = "login";
const String _kRegister = "register";
const String _kMessage = "message";
const String _kToken = "token";

@injectable
class AuthenticationAPI {
  final IRemoteRepository _remoteRepository;

  AuthenticationAPI(
    this._remoteRepository,
  );

  final String _loginMutationString = r"""
  mutation($email: String!, $password: String!) {
  login(input: { params: { email: $email, password: $password } }) {
    refreshToken
  }
}
  """;

  final String _logoutMutationString = r"""
  mutation($token: String!) {
  logout(input: { params: { token: $token } }) {
    driver {
      createdAt
      email
      id
      name
      phoneNumber
      status
      updatedAt
    }
  }
}
  """;

  final String _registerMutationString = r"""
  mutation($email: String!, $password: String!, $name: String!, $phoneNumber: String!) {
  register(
    input: {
      params: {
        name: $name
        email: $email
        phoneNumber: $phoneNumber
        password: $password
      }
    }
  ) {
    clientMutationId
    message
  }
}
  """;

//   final String _generateAccessTokenMutationString = r"""
// mutation($token: String!) {
//   generateAccessToken(input: { params: { token: $token} }) {
//     accessToken
//     tokenExpiry
//   }
// }
//   """;

  Future<NetworkResponseModel<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    var response = await _remoteRepository.mutation(
      mutationString: _loginMutationString,
      variables: {
        _kEmail: email,
        _kPassword: password,
      },
    );
    return NetworkResponseModel<LoginResponseModel>.process(
      response,
      (resultMap) {
        if (resultMap?[_kLogin] != null) {
          return LoginResponseModel.fromJson(resultMap![_kLogin]);
        }
        return null;
      },
    );
  }

  Future<void> logout({
    required String token,
  }) async {
    await _remoteRepository.mutation(
      mutationString: _logoutMutationString,
      variables: {
        _kToken: token,
      },
    );
    _remoteRepository.clearUserToken();
  }

  Future<NetworkResponseModel<String>> register({
    required RegistrationModel registrationModel,
  }) async {
    var response = await _remoteRepository.mutation(
      mutationString: _registerMutationString,
      variables: registrationModel.toJson(),
    );
    return NetworkResponseModel<String>.process(
      response,
      (resultMap) {
        if (resultMap?[_kRegister] != null) {
          return resultMap![_kRegister][_kMessage];
        }
        return null;
      },
    );
  }
//
// Future<NetworkResponseModel<String>> generateAccessToken({
//   required String refreshToken,
// }) async {
//   var tokenResponse = await _remoteRepository.mutation(
//     mutationString: _generateAccessTokenMutationString,
//     variables: {
//       _kToken: refreshToken,
//     },
//   );
//   var tokenResult = NetworkResponseModel<String>.process(
//     tokenResponse,
//     (resultMap) {
//       if (resultMap?[_kGenerateAccessToken] != null) {
//         return resultMap![_kGenerateAccessToken][_kAccessToken];
//       }
//       return null;
//     },
//   );
//   return tokenResult;
// }
}
