import 'package:fleety/core/repository/ilocal_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _refreshTokenKey = "refreshToken";
const String _accessTokenKey = "accessToken";

@Injectable(as: ILocalRepository)
class LocalRepository extends ILocalRepository {
  final SharedPreferences _sharedPreferences;

  LocalRepository(this._sharedPreferences);

  @override
  String? getRefreshToken() {
    return _sharedPreferences.getString(_refreshTokenKey);
  }

  @override
  Future<bool> setRefreshToken(String token) {
    return _sharedPreferences.setString(_refreshTokenKey, token);
  }

  @override
  String? getAccessToken() {
    return _sharedPreferences.getString(_accessTokenKey);
  }

  @override
  Future<bool> setAccessToken(String token) {
    return _sharedPreferences.setString(_accessTokenKey, token);
  }

  @override
  Future<void> clearData() async {
    await _sharedPreferences.clear();
  }
}
