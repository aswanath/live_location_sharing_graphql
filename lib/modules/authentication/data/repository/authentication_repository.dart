import 'package:fleety/core/model/network_response_model.dart';
import 'package:fleety/modules/authentication/data/models/login_response_model.dart';
import 'package:fleety/modules/authentication/data/models/registration_model.dart';
import 'package:fleety/modules/authentication/data/network/authentication_api.dart';
import 'package:fleety/modules/authentication/data/repository/iauthentication_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IAuthenticationRepository)
class AuthenticationRepository extends IAuthenticationRepository {
  final AuthenticationAPI _authenticationAPI;

  AuthenticationRepository(this._authenticationAPI);

  @override
  Future<NetworkResponseModel<LoginResponseModel>> login({required String email, required String password}) {
    return _authenticationAPI.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<NetworkResponseModel<String>> register({required RegistrationModel registrationModel}) {
    return _authenticationAPI.register(
      registrationModel: registrationModel,
    );
  }

  @override
  Future<void> logout({required String token}) {
    return _authenticationAPI.logout(token: token);
  }
}
