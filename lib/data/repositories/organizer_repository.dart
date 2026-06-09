import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/event_model.dart';

class OrganizerStats {
  final int eventCount;
  final int bookingCount;
  final double totalRevenue;
  final List<EventModel> events;
  final String organizerName;

  OrganizerStats({
    required this.eventCount,
    required this.bookingCount,
    required this.totalRevenue,
    required this.events,
    required this.organizerName,
  });

  factory OrganizerStats.fromJson(Map<String, dynamic> json) {
    final organizer = json['organizer'] as Map<String, dynamic>?;
    final eventsList = (json['events'] as List? ?? [])
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return OrganizerStats(
      eventCount: json['eventCount'] ?? eventsList.length,
      bookingCount: json['bookingCount'] ?? 0,
      totalRevenue: double.tryParse(json['totalRevenue'].toString()) ?? 0,
      events: eventsList,
      organizerName: organizer?['name'] ?? 'Organizer',
    );
  }
}

class OrganizerRepository {
  final Dio _dio = apiClient;

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get('/organizers/me/profile');
    return response.data as Map<String, dynamic>;
  }

  Future<OrganizerStats> getMyStats() async {
    final response = await _dio.get('/organizers/me/stats');
    return OrganizerStats.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<EventModel>> getMyEvents() async {
    final response = await _dio.get('/organizers/me/events');
    final data = response.data;
    final list = data is List ? data : (data['data'] as List? ?? []);
    return list
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<EventModel> createEvent({
    required String title,
    required String description,
    required String categoryId,
    required String venueId,
    required String organizerId,
    required DateTime startTime,
    required DateTime endTime,
    required String heroImageUrl,
    bool isFeatured = false,
    List<Map<String, dynamic>>? ticketTiers,
  }) async {
    final response = await _dio.post('/events', data: {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'venueId': venueId,
      'organizerId': organizerId,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'heroImageUrl': heroImageUrl,
      'status': 'PUBLISHED',
      'isFeatured': isFeatured,
      if (ticketTiers != null) 'ticketTiers': ticketTiers,
    });
    return EventModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getVenues() async {
    final response = await _dio.get('/venues');
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    return [];
  }
}
