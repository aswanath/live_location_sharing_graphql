import 'package:graphql_flutter/graphql_flutter.dart';

abstract class IRemoteRepository {
  Future<QueryResult> query({
    required String queryString,
    bool useAuth = true,
    Map<String, dynamic> variables = const {},
  });

  Future<QueryResult> mutation({
    required String mutationString,
    Map<String, dynamic> variables = const {},
  });

  void clearUserToken();

  void setUserToken(String authToken);
}
