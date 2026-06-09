import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  late final AuthRepository _repository;

  @override
  Future<UserModel?> build() async {
    _repository = ref.watch(authRepositoryProvider);
    try {
      return await _repository.getMe();
    } catch (e) {
      // Not authenticated or token missing
      return null;
    }
  }


  Future<void> checkAuth() async {
    try {
      final user = await _repository.getMe();
      state = AsyncData(user);
    } catch (e) {
      state = const AsyncData(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _repository.login(email, password);
      final user = await _repository.getMe();
      state = AsyncData(user);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> register(String first, String last, String email, String pass, String phone) async {
    state = const AsyncLoading();
    try {
      await _repository.register(first, last, email, pass, phone);
      final user = await _repository.getMe();
      state = AsyncData(user);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncData(null);
  }
}
