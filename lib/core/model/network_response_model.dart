import 'package:graphql_flutter/graphql_flutter.dart';

enum ErrorModel {
  noNetwork,
  serverError,
  unknown,
}

enum Status { successful, failure }

class NetworkResponseModel<T> {
  int httpStatusCode = 0;
  Status status = Status.failure;
  ErrorModel? error;
  T? data;
  String message = "";
  String? errorCode;

  NetworkResponseModel({
    this.httpStatusCode = 0,
    this.status = Status.failure,
    this.error,
    this.data,
    this.message = "",
    this.errorCode,
  });

  NetworkResponseModel.process(QueryResult? result, Function(Map<String, dynamic>? resultMap) f) {
    message = "";
    if (result == null) {
      status = Status.failure;
      error = ErrorModel.unknown;
    } else {
      if (result.hasException) {
        final exception = result.exception!.linkException;
        if (exception == null) {
          final exceptionList = result.exception!.graphqlErrors;
          if (exceptionList.isNotEmpty) {
            message = exceptionList[0].message;
            errorCode = exceptionList[0].extensions?["code"];
          }
          error = ErrorModel.serverError;
        } else {
          if (exception is ServerException) {
            error = ErrorModel.noNetwork;
          } else {
            httpStatusCode = 500;
            error = ErrorModel.serverError;
          }
          message = exception.originalException.toString();
        }

        message = message.isNotEmpty ? message : 'Something went wrong. Try again later.';
        status = Status.failure;
      } else {
        final resultData = result.data;
        httpStatusCode = 200;
        status = Status.successful;
        data = f(resultData);
      }
    }
  }
}
