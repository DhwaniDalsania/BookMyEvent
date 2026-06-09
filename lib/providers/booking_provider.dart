import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/booking_repository.dart';
import '../data/models/booking_model.dart';

final bookingRepositoryProvider = Provider((ref) => BookingRepository());

final userBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getUserBookings();
});
