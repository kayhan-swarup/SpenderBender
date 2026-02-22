import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction.dart' as models;
import '../../../data/models/category.dart';
import '../../../data/models/account.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/transaction_provider.dart';

class AllTransactionsScreen extends ConsumerStatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  ConsumerState<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends ConsumerState<AllTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final userId = AppConstants.defaultUserId;
    await ref.read(transactionsProvider.notifier).fetchTransactionsByUserId(userId);
    await ref.read(categoriesProvider.notifier).fetchCategories();
    await ref.read(accountsProvider.notifier).fetchAccounts(userId);
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  Future<void> _deleteTransaction(models.Transaction transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.expense),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final accountsState = ref.read(accountsProvider);
      final accounts = accountsState.value;

      if (accounts == null) throw Exception('Accounts not loaded');

      final account = accounts.firstWhere((a) => a.id == transaction.accountId);

      final newBalance = transaction.type == 'expense'
          ? account.balance + transaction.amount
          : account.balance - transaction.amount;

      await ref.read(transactionsProvider.notifier).deleteTransactionWithBalance(
            transactionId: transaction.id!,
            accountId: account.id!,
            newBalance: newBalance,
          );

      await ref.read(accountsProvider.notifier).fetchAccounts(AppConstants.defaultUserId);
      await ref.read(transactionsProvider.notifier).fetchTransactionsByUserId(AppConstants.defaultUserId);
      await ref.read(recentTransactionsProvider.notifier).fetchRecentTransactions(AppConstants.defaultUserId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('All Transactions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Center(child: Text('No transactions yet'));
            }

            final categories = categoriesAsync.value ?? [];
            final accounts = accountsAsync.value ?? [];

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final txn = transactions[index];
                Category? category;
                try {
                  category = categories.firstWhere((c) => c.id == txn.categoryId);
                } catch (e) {
                  category = null;
                }

                Account? account;
                try {
                  account = accounts.firstWhere((a) => a.id == txn.accountId);
                } catch (e) {
                  account = null;
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.surface,
                    child: Icon(
                      txn.type == 'expense'
                          ? Icons.trending_down
                          : Icons.trending_up,
                      color: txn.type == 'expense'
                          ? AppTheme.expense
                          : AppTheme.income,
                    ),
                  ),
                  title: Text(category?.name ?? 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account?.accountName ?? 'Unknown',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormatter.formatDate(txn.date),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        CurrencyFormatter.formatWithType(txn.amount, txn.type),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: txn.type == 'expense'
                              ? AppTheme.expense
                              : AppTheme.income,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppTheme.expense),
                        onPressed: () => _deleteTransaction(txn),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
