import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final Dio _dio = apiClient;

  Future<void> lockSeats(String eventId, List<String> seatIds) async {
    await _dio.post('/seat-holds', data: {
      'eventId': eventId,
      'seatIds': seatIds,
    });
  }

  Future<BookingModel> createBooking(String eventId, List<String> seatIds) async {
    final response = await _dio.post('/bookings', data: {
      'eventId': eventId,
      'seatIds': seatIds,
    });
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<BookingModel>> getUserBookings() async {
    try {
      final response = await _dio.get('/bookings/user/me');
      final dynamic data = response.data;

      List rawList = [];
      if (data is List) {
        rawList = data;
      } else if (data is Map && data['data'] is List) {
        rawList = data['data'] as List;
      }

      return rawList
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // If 401 (not logged in) or 404 — return empty list gracefully
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }
}
