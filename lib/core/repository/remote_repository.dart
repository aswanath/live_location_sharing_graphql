import 'package:fleety/core/network/graphql_client.dart';
import 'package:fleety/core/repository/ilocal_repository.dart';
import 'package:fleety/core/repository/iremote_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const String _kToken = "token";
const String _kGenerateAccessToken = "generateAccessToken";
const String _kAccessToken = "accessToken";
const String _kCode = "code";
const String _kUnauthenticatedCode = "UNAUTHENTICATED";

@Injectable(as: IRemoteRepository)
class RemoteRepository extends IRemoteRepository {
  final BaseGraphQLClient _baseGraphQLClient;
  final ILocalRepository _localRepository;

  RemoteRepository(
    this._baseGraphQLClient,
    this._localRepository,
  );

  final String _generateAccessTokenMutationString = r"""
mutation($token: String!) {
  generateAccessToken(input: { params: { token: $token} }) {
    accessToken
    tokenExpiry
  }
}
  """;

  @override
  Future<QueryResult<Object?>> mutation({
    required String mutationString,
    Map<String, dynamic> variables = const {},
  }) async {
    try {
      var client = _baseGraphQLClient.getAuthGraphQLClient ?? _baseGraphQLClient.getGraphQLClient;
      MutationOptions mutationOptions = MutationOptions(
        document: gql(mutationString),
        variables: variables,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      );
      var result = await client.mutate(
        mutationOptions,
      );
      bool isUnauthorized = _isUnauthenticated(result);
      if (isUnauthorized) {
        bool setAccessToken = await _setAccessToken();
        if (setAccessToken) {
          client = _baseGraphQLClient.getAuthGraphQLClient ?? _baseGraphQLClient.getGraphQLClient;
          result = await client.mutate(
            mutationOptions,
          );
        }
      }
      return result;
    } catch (e) {
      return QueryResult.unexecuted;
    }
  }

  @override
  Future<QueryResult<Object?>> query({
    required String queryString,
    bool useAuth = true,
    Map<String, dynamic> variables = const {},
  }) async {
    try {
      var client = (useAuth ? (_baseGraphQLClient.getAuthGraphQLClient ?? _baseGraphQLClient.getGraphQLClient) : _baseGraphQLClient.getGraphQLClient);
      MutationOptions mutationOptions = MutationOptions(
        document: gql(queryString),
        variables: variables,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      );
      var result = await client.mutate(
        mutationOptions,
      );
      bool isUnauthorized = _isUnauthenticated(result);
      if (isUnauthorized) {
        bool setAccessToken = await _setAccessToken();
        if (setAccessToken) {
          client = (useAuth ? (_baseGraphQLClient.getAuthGraphQLClient ?? _baseGraphQLClient.getGraphQLClient) : _baseGraphQLClient.getGraphQLClient);
          result = await client.mutate(
            mutationOptions,
          );
        }
      }
      return result;
    } catch (e) {
      return QueryResult.unexecuted;
    }
  }

  @override
  void setUserToken(String authToken) {
    _baseGraphQLClient.setAuth(authToken);
  }

  @override
  void clearUserToken() {
    _baseGraphQLClient.setAuth(null);
  }

  Future<bool> _setAccessToken() async {
    String? refreshToken = _localRepository.getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      final client = _baseGraphQLClient.getGraphQLClient;
      MutationOptions mutationOptions = MutationOptions(
        document: gql(_generateAccessTokenMutationString),
        variables: {
          _kToken: refreshToken,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      );
      final result = await client.mutate(
        mutationOptions,
      );
      if (result.data != null) {
        if (result.data![_kGenerateAccessToken] != null) {
          String? accessToken = result.data![_kGenerateAccessToken][_kAccessToken];
          await _localRepository.setAccessToken(accessToken ?? "");
          _baseGraphQLClient.setAuth(accessToken);
          return accessToken != null;
        }
      }
    }
    return false;
  }

  bool _isUnauthenticated(QueryResult result) {
    if (result.hasException && result.exception != null) {
      final exceptionList = result.exception!.graphqlErrors;
      if (exceptionList.isNotEmpty) {
        String errorCode = exceptionList[0].extensions?[_kCode];
        if (errorCode == _kUnauthenticatedCode) {
          return true;
        }
      }
    }
    return false;
  }
}
