import 'dart:io';

import 'package:dio/dio.dart';

class NetworkError implements Exception {
  NetworkError(DioError error) {
    onDioError(error);
  }

  String? errorMessage;

  onDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.other:
        if (error.error is SocketException) errorMessage = "Connnection Error";
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
        if (error.response?.statusCode == 500)
          errorMessage = 'Error: Server Error';
        break;
      default:
        errorMessage = 'Error: Unexpected Error';
    }
  }

  String get error {
    return errorMessage!;
  }
}
