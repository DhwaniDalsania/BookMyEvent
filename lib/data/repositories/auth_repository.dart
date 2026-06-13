import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Dio _dio = apiClient;


  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['accessToken'] ?? response.data['token'] ?? response.data['jwt'];
      await SecureStorage.saveToken(token);
      final refresh = response.data['refreshToken'];
      if (refresh != null) await SecureStorage.saveRefreshToken(refresh);

      return response.data;
    } catch (e) {
      debugPrint('🚨 Login request failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    required String role,
    String? organizerName,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        if (phone != null && phone.isNotEmpty) 'phoneNumber': phone,
        'role': role,
        if (organizerName != null && organizerName.isNotEmpty) 'organizerName': organizerName,
      };
      final response = await _dio.post('/auth/register', data: payload);
      
      final token = response.data['accessToken'] ?? response.data['token'] ?? response.data['jwt'];
      await SecureStorage.saveToken(token);
      final refresh = response.data['refreshToken'];
      if (refresh != null) await SecureStorage.saveRefreshToken(refresh);

      return response.data;
    } catch (e) {
      debugPrint('🚨 Register request failed: $e');
      rethrow;
    }
  }

  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('/auth/me');
      // The backend may wrap the user data inside a "user" field.
      // If it does, extract it; otherwise use the response directly.
      final dynamic data = response.data;
      final Map<String, dynamic> userJson =
          (data is Map<String, dynamic> && data.containsKey('user'))
              ? data['user'] as Map<String, dynamic>
              : data as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } catch (e) {
      debugPrint('🚨 GetMe request failed: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {}
    await SecureStorage.clearAll();
  }

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    final response = await _dio.patch('/auth/me', data: {
      'firstName': ?firstName,
      'lastName': ?lastName,
      'phoneNumber': ?phoneNumber,
      'profileImageUrl': ?profileImageUrl,
    });
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
