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

  Future<void> addToWishlist(String eventId) async {
    await _dio.post('/wishlist/$eventId');
  }

  Future<void> removeFromWishlist(String eventId) async {
    await _dio.delete('/wishlist/$eventId');
  }

  Future<bool> isInWishlist(String eventId) async {
    final items = await getWishlist();
    return items.any((e) => e.id == eventId);
  }
}
