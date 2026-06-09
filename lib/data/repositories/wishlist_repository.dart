import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/event_model.dart';

class WishlistRepository {
  final Dio _dio = apiClient;

  Future<List<EventModel>> getWishlist() async {
    try {
      final response = await _dio.get('/wishlist/me');
      final data = response.data;
      if (data != null && data is List) {
        return data.map((json) => EventModel.fromJson(json['event'])).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleWishlist(String eventId) async {
    // Basic toggle mechanism
    await _dio.post('/wishlist/$eventId');
  }
}
