import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

String baseUrl = "https://mobileapi.planetmedia.dev/graphql";
const String _bearer = "Bearer";
const String _apiKey = "X-API-KEY";
const String _apiKeyValue = "pm_test_YIJLLK878799tD1h9XZvs4fGPJUgtt";

final HttpLink _httpLink = HttpLink(
  baseUrl,
  defaultHeaders: {
    _apiKey: _apiKeyValue,
  },
);

@injectable
class BaseGraphQLClient {
  static String? _authToken;

  BaseGraphQLClient();

  void setAuth(String? authToken) {
    _authToken = authToken;
  }

  GraphQLClient? get getAuthGraphQLClient {
    if (_authToken == null) {
      return null;
    }

    return GraphQLClient(
      link: AuthLink(
        getToken: () async => '$_bearer $_authToken',
      ).concat(_httpLink),
      cache: GraphQLCache(),
    );
  }

  GraphQLClient get getGraphQLClient {
    return GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(),
    );
  }
}
