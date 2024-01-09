import 'package:fleety/core/model/network_response_model.dart';
import 'package:fleety/modules/authentication/data/models/login_response_model.dart';
import 'package:fleety/modules/authentication/data/models/registration_model.dart';

abstract class IAuthenticationRepository {
  Future<NetworkResponseModel<LoginResponseModel>> login({
    required String email,
    required String password,
  });

  Future<NetworkResponseModel<String>> register({
    required RegistrationModel registrationModel,
  });

  Future<void> logout({
    required String token,
  });
}
