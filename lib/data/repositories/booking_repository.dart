import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/booking_model.dart';
import '../models/seat_model.dart';

class BookingRepository {
  final Dio _dio = apiClient;

  Future<void> lockSeats(String eventId, List<SelectedSeat> seats) async {
    for (final seat in seats) {
      if (seat.id.startsWith('mock-')) continue;
      await _dio.post('/seat-holds', data: {
        'eventId': eventId,
        'seatId': seat.id,
      });
    }
  }

  Future<BookingModel> createBooking(String eventId, List<SelectedSeat> seats) async {
    if (seats.any((s) => s.id.startsWith('mock-'))) {
      throw Exception('Connect to the server to complete booking. Demo seats cannot be booked.');
    }
    final response = await _dio.post('/bookings', data: {
      'eventId': eventId,
      'tickets': seats
          .map((s) => {
                'seatId': s.id,
                'ticketTierId': s.ticketTierId,
              })
          .toList(),
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
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }
}
