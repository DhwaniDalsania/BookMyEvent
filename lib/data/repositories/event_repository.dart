import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../constants/mock_data.dart';
import '../models/event_model.dart';
import '../models/category_model.dart';
import '../models/seat_model.dart';

class EventRepository {
  final Dio _dio = apiClient;

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Parses the events from a raw API [data] value.
  /// The backend may return a bare List, or a Map with a 'data' key.
  List<EventModel> _parseEvents(dynamic data) {
    List rawList = [];
    if (data is List) {
      rawList = data;
    } else if (data is Map && data['data'] is List) {
      rawList = data['data'] as List;
    }
    return rawList
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Converts the rich [MockData.events] map list into [EventModel] objects.
  List<EventModel> _mockEvents({String? categorySlug, int? limit}) {
    var all = MockData.events.map((m) {
      // Build a shape compatible with EventModel.fromJson
      return EventModel(
        id: m['id'] as String,
        title: m['title'] as String,
        description: m['description'] as String,
        startTime: DateTime.now().add(const Duration(days: 30)),
        endTime: DateTime.now().add(const Duration(days: 30, hours: 3)),
        heroImageUrl: m['image'] as String?,
        status: 'published',
        categoryId: m['id'] as String,
        categoryName: m['category'] as String,
        locationName: m['location'] as String? ?? 'TBD',
        startingPrice: (m['price'] as num?)?.toDouble() ?? 0,
        isTrending: m['isTrending'] as bool? ?? false,
      );
    }).toList();

    if (categorySlug != null && categorySlug.isNotEmpty) {
      all = all
          .where((e) =>
              e.categoryName.toLowerCase().contains(categorySlug.toLowerCase()))
          .toList();
    }

    if (limit != null) all = all.take(limit).toList();
    return all;
  }

  List<CategoryModel> _mockCategories() {
    final icons = [
      'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1585699324551-f6c309eedeca?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1507676184212-d0330a15233c?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1533174000220-db9d1bd3db34?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?q=80&w=400&auto=format&fit=crop',
    ];
    return List.generate(MockData.categories.length, (i) {
      final c = MockData.categories[i];
      return CategoryModel(
        id: c['id'] as String,
        name: c['name'] as String,
        slug: (c['name'] as String).toLowerCase(),
        iconUrl: icons[i % icons.length],
      );
    });
  }

  // ── Public API ────────────────────────────────────────────────────────────

  Future<List<EventModel>> getEvents({String? categorySlug, String? city}) async {
    try {
      final query = <String, dynamic>{};
      if (categorySlug != null) query['category'] = categorySlug;
      if (city != null) query['city'] = city;

      final response = await _dio.get('/events', queryParameters: query);
      final events = _parseEvents(response.data);

      if (events.isNotEmpty) return events;
      debugPrint('ℹ️ API returned empty events, using mock data');
    } catch (e) {
      debugPrint('⚠️ getEvents API error, using mock data: $e');
    }
    return _mockEvents(categorySlug: categorySlug);
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final dynamic data = response.data;
      List rawList = data is List ? data : (data is Map && data['data'] is List ? data['data'] : []);
      final categories = rawList
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (categories.isNotEmpty) return categories;
      debugPrint('ℹ️ API returned empty categories, using mock data');
    } catch (e) {
      debugPrint('⚠️ getCategories API error, using mock data: $e');
    }
    return _mockCategories();
  }

  Future<List<EventModel>> getFeaturedEvents() async {
    try {
      final response = await _dio.get('/events', queryParameters: {
        'featured': 'true',
        'take': '5',
      });
      final events = _parseEvents(response.data);

      if (events.isNotEmpty) return events.take(5).toList();
      debugPrint('ℹ️ API returned empty featured events, using mock data');
    } catch (e) {
      debugPrint('⚠️ getFeaturedEvents API error, using mock data: $e');
    }
    return _mockEvents(limit: 5);
  }

  Future<List<EventModel>> searchEvents(String query) async {
    try {
      final response = await _dio.get('/events/search', queryParameters: {'q': query});
      final events = _parseEvents(response.data);
      if (events.isNotEmpty) return events;
    } catch (e) {
      debugPrint('⚠️ searchEvents API error: $e');
    }
    return _mockEvents().where((e) =>
        e.title.toLowerCase().contains(query.toLowerCase()) ||
        e.categoryName.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<SeatMapModel> getSeatMap(String eventId, {double fallbackPrice = 999}) async {
    try {
      final response = await _dio.get('/events/$eventId/seat-map');
      return SeatMapModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('⚠️ getSeatMap error, using mock: $e');
      return SeatMapModel.mock(eventId, fallbackPrice);
    }
  }

  Future<EventModel?> getEventById(String id) async {
    try {
      final response = await _dio.get('/events/$id');
      return EventModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('⚠️ getEventById error: $e');
      return null;
    }
  }
}
