import 'dart:io';

import 'package:dio/dio.dart';

class NetworkError implements Exception {
  NetworkError(DioError error) {
    onDioError(error);
  }

  String? errorMessage;
  int? statusCode;

  onDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.other:
        if (error.error is SocketException)
          errorMessage = "Connnection Error";
        else
          errorMessage = "Unexpected Error";
        break;
      case DioErrorType.cancel:
        errorMessage = "Request cancelled";
        break;
      case DioErrorType.connectTimeout:
        errorMessage = 'Error: Request timeout';
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = 'Error: Response Timeout';
        break;
      case DioErrorType.response:
        reponseponseErrorTypeHandler(error);
        break;
      default:
        errorMessage = 'Error: Unexpected Error';
    }
  }

  void reponseponseErrorTypeHandler(DioError err) {
    switch (err.response?.statusCode) {
      case 500:
        errorMessage = 'Error: Server Error';
        break;
      case 403:
        errorMessage = 'Error: Unauthorized credentials';
        break;

      case 401:
        errorMessage = err.response!.data["message"];
        break;
      default:
        errorMessage = 'Unexpected: Server Error';
    }
    statusCode = err.response?.statusCode;
  }

  String get error {
    return errorMessage!;
  }
}
