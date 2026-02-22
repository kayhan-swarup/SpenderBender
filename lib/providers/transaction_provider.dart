import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction.dart';
import '../data/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

class TransactionsNotifier extends Notifier<AsyncValue<List<Transaction>>> {
  @override
  AsyncValue<List<Transaction>> build() {
    return const AsyncValue.loading();
  }

  Future<void> fetchTransactionsByUserId(int userId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(transactionRepositoryProvider);
      final transactions = await repository.getTransactionsByUserId(userId);
      state = AsyncValue.data(transactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createTransaction(Transaction transaction) async {
    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.createTransaction(transaction);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> createTransactionWithBalance({
    required Transaction transaction,
    required int accountId,
    required double newBalance,
  }) async {
    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.createTransactionAndUpdateBalance(
        transaction: transaction,
        accountId: accountId,
        newBalance: newBalance,
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.updateTransaction(transaction);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.deleteTransaction(id);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteTransactionWithBalance({
    required int transactionId,
    required int accountId,
    required double newBalance,
  }) async {
    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.deleteTransactionAndUpdateBalance(
        transactionId: transactionId,
        accountId: accountId,
        newBalance: newBalance,
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<Transaction?> getTransactionById(int id) async {
    try {
      final repository = ref.read(transactionRepositoryProvider);
      return await repository.getTransactionById(id);
    } catch (e) {
      return null;
    }
  }
}

final transactionsProvider = NotifierProvider<TransactionsNotifier, AsyncValue<List<Transaction>>>(() {
  return TransactionsNotifier();
});

class RecentTransactionsNotifier extends Notifier<AsyncValue<List<Transaction>>> {
  @override
  AsyncValue<List<Transaction>> build() {
    return const AsyncValue.loading();
  }

  Future<void> fetchRecentTransactions(int userId, {int limit = 5}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(transactionRepositoryProvider);
      final transactions = await repository.getRecentTransactions(userId, limit: limit);
      state = AsyncValue.data(transactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final recentTransactionsProvider = NotifierProvider<RecentTransactionsNotifier, AsyncValue<List<Transaction>>>(() {
  return RecentTransactionsNotifier();
});
