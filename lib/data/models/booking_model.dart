import 'event_model.dart';

class BookingModel {
  final String id;
  final String bookingRef;
  final String eventId;
  final String status;
  final double finalAmount;
  final int ticketCount;
  final String? razorpayOrderId;
  final EventModel? event;

  BookingModel({
    required this.id,
    required this.bookingRef,
    required this.eventId,
    required this.status,
    required this.finalAmount,
    required this.ticketCount,
    this.razorpayOrderId,
    this.event,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      bookingRef: json['bookingRef'] ?? '',
      eventId: json['eventId'] ?? '',
      status: json['status'] ?? 'PENDING',
      finalAmount: double.tryParse(json['finalAmount'].toString()) ?? 0.0,
      ticketCount: json['ticketCount'] ??
          (json['tickets'] is List ? (json['tickets'] as List).length : 0),
      razorpayOrderId: json['payment']?['razorpayOrderId'],
      event: json['event'] != null ? EventModel.fromJson(json['event']) : null,
    );
  }
}
