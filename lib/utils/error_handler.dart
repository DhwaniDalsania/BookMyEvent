import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. The server is taking too long to respond. Please try again.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please check your internet connection.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. The server is taking too long to respond.';
        case DioExceptionType.badResponse:
          final response = error.response;
          if (response != null) {
            final dynamic data = response.data;
            if (data is Map) {
              if (data['message'] != null) {
                if (data['message'] is List) {
                  return (data['message'] as List).join('\n');
                }
                return data['message'].toString();
              }
            }
          }
          return 'Server error: ${response?.statusCode ?? "Unknown error"}';
        case DioExceptionType.cancel:
          return 'Request cancelled.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check if the server is running and you are connected to the internet.';
        default:
          return error.message ?? 'An unexpected network error occurred.';
      }
    }
    return error.toString().replaceFirst('Exception: ', '');
  }
}
