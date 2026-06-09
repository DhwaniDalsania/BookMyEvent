import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class PaymentRepository {
  final Dio _dio = apiClient;

  Future<String> createRazorpayOrder(String bookingId) async {
    final response = await _dio.post('/payments/create-order', data: {
      'bookingId': bookingId,
    });
    return response.data['razorpayOrderId'];
  }

  Future<bool> verifyPayment(String bookingId, String razorpayPaymentId, String razorpayOrderId, String razorpaySignature) async {
    try {
      await _dio.post('/payments/verify', data: {
        'bookingId': bookingId,
        'razorpayPaymentId': razorpayPaymentId,
        'razorpayOrderId': razorpayOrderId,
        'razorpaySignature': razorpaySignature,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
