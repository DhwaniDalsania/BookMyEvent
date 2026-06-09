import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/organizer_repository.dart';
import '../data/models/event_model.dart';

final organizerRepositoryProvider = Provider((ref) => OrganizerRepository());

final organizerStatsProvider = FutureProvider<OrganizerStats>((ref) async {
  return ref.read(organizerRepositoryProvider).getMyStats();
});

final organizerEventsProvider = FutureProvider<List<EventModel>>((ref) async {
  return ref.read(organizerRepositoryProvider).getMyEvents();
});
