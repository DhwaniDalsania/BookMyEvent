import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/event_repository.dart';
import '../data/models/event_model.dart';
import '../data/models/category_model.dart';

final eventRepositoryProvider = Provider((ref) => EventRepository());

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return ref.read(eventRepositoryProvider).getCategories();
});

final eventsProvider = FutureProvider.family<List<EventModel>, String?>((ref, categorySlug) async {
  return ref.read(eventRepositoryProvider).getEvents(categorySlug: categorySlug);
});

final featuredEventsProvider = FutureProvider<List<EventModel>>((ref) async {
  return ref.read(eventRepositoryProvider).getFeaturedEvents();
});
