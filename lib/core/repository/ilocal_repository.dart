abstract class ILocalRepository {
  Future<bool> setRefreshToken(String token);
  Future<bool> setAccessToken(String token);

  String? getRefreshToken();
  String? getAccessToken();

  Future<void> clearData();
}
