import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/account.dart';
import '../data/repositories/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository();
});

class AccountsNotifier extends Notifier<AsyncValue<List<Account>>> {
  @override
  AsyncValue<List<Account>> build() {
    return const AsyncValue.loading();
  }

  Future<void> fetchAccounts(int userId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(accountRepositoryProvider);
      final accounts = await repository.getAccountsByUserId(userId);
      state = AsyncValue.data(accounts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createAccount(Account account) async {
    try {
      final repository = ref.read(accountRepositoryProvider);
      await repository.createAccount(account);
      await fetchAccounts(account.userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateAccount(Account account) async {
    try {
      final repository = ref.read(accountRepositoryProvider);
      await repository.updateAccount(account);
      await fetchAccounts(account.userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateAccountBalance(int accountId, double newBalance, int userId) async {
    try {
      final repository = ref.read(accountRepositoryProvider);
      await repository.updateAccountBalance(accountId, newBalance);
      await fetchAccounts(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAccount(int id, int userId) async {
    try {
      final repository = ref.read(accountRepositoryProvider);
      await repository.deleteAccount(id);
      await fetchAccounts(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> hasAccounts(int userId) async {
    try {
      final repository = ref.read(accountRepositoryProvider);
      return await repository.hasAccounts(userId);
    } catch (e) {
      return false;
    }
  }
}

final accountsProvider = NotifierProvider<AccountsNotifier, AsyncValue<List<Account>>>(() {
  return AccountsNotifier();
});

class TotalBalanceNotifier extends Notifier<AsyncValue<double>> {
  @override
  AsyncValue<double> build() {
    return const AsyncValue.loading();
  }

  Future<void> fetchTotalBalance(int userId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(accountRepositoryProvider);
      final total = await repository.getTotalBalance(userId);
      state = AsyncValue.data(total);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final totalBalanceProvider = NotifierProvider<TotalBalanceNotifier, AsyncValue<double>>(() {
  return TotalBalanceNotifier();
});
