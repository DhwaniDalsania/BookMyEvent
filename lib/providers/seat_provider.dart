import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/seat_model.dart';
import 'event_provider.dart';

final seatMapProvider = FutureProvider.family<SeatMapModel, ({String eventId, double price})>((ref, params) async {
  return ref.read(eventRepositoryProvider).getSeatMap(params.eventId, fallbackPrice: params.price);
});