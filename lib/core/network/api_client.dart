import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Log all requests/responses for debugging
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Auto-inject JWT token if available
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Handle 401 Unauthorized globally
          if (e.response?.statusCode == 401) {
            await SecureStorage.deleteToken();
            // In a full app, we would dispatch an event to log the user out of the UI
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get client => dio;
}

final apiClient = ApiClient().client;
