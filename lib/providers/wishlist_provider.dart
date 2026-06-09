import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/wishlist_repository.dart';
import '../data/models/event_model.dart';

final wishlistRepositoryProvider = Provider((ref) => WishlistRepository());

final wishlistProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.watch(wishlistRepositoryProvider);
  return repo.getWishlist();
});
