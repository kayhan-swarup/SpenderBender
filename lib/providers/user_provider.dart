import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user.dart';
import '../data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class CurrentUserNotifier extends Notifier<AsyncValue<User?>> {
  @override
  AsyncValue<User?> build() {
    loadDefaultUser();
    return const AsyncValue.loading();
  }

  Future<void> loadDefaultUser() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(userRepositoryProvider);
      final user = await repository.getDefaultUser();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createUser(User user) async {
    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.createUser(user);
      await loadDefaultUser();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.updateUser(user);
      await loadDefaultUser();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final currentUserProvider = NotifierProvider<CurrentUserNotifier, AsyncValue<User?>>(() {
  return CurrentUserNotifier();
});
