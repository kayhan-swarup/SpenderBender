import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/transaction_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final userId = AppConstants.defaultUserId;
    ref.read(accountsProvider.notifier).fetchAccounts(userId);
    ref.read(totalBalanceProvider.notifier).fetchTotalBalance(userId);
    ref
        .read(recentTransactionsProvider.notifier)
        .fetchRecentTransactions(userId);
    ref.read(categoriesProvider.notifier).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);
    final recentTransactionsAsync = ref.watch(recentTransactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              accountsAsync.when(
                data: (accounts) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: accounts.length + 1,
                              itemBuilder: (context, index) {
                                if (index == accounts.length) {
                                  return GestureDetector(
                                    onTap: () => context.push('/add-account'),
                                    child: Container(
                                      width: 160,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppTheme.borderColor,
                                        ),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: AppTheme.primary,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Add account',
                                            style: TextStyle(
                                              color: AppTheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final account = accounts[index];
                                return Container(
                                  width: 160,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            account.type == 'cash'
                                                ? Icons.account_balance_wallet
                                                : Icons.account_balance,
                                            color: AppTheme.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              account.type.toUpperCase(),
                                              style: const TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            account.accountName,
                                            style: const TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            CurrencyFormatter.format(
                                              account.balance,
                                            ),
                                            style: const TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Last Records',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      recentTransactionsAsync.when(
                        data: (transactions) {
                          if (transactions.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text('No transactions yet'),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              ...transactions.take(5).map((txn) {
                                final categories = categoriesAsync.value ?? [];
                                final category = categories.firstWhere(
                                  (c) => c.id == txn.categoryId,
                                  orElse: () => categories.first,
                                );

                                return Column(
                                  children: [
                                    ListTile(
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
                                      title: Text(category.name),
                                      subtitle: Text(
                                        DateFormatter.formatDate(txn.date),
                                        style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      trailing: Text(
                                        CurrencyFormatter.formatWithType(
                                          txn.amount,
                                          txn.type,
                                        ),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: txn.type == 'expense'
                                              ? AppTheme.expense
                                              : AppTheme.income,
                                        ),
                                      ),
                                    ),
                                    if (txn != transactions.last)
                                      const Divider(),
                                  ],
                                );
                              }),
                              if (transactions.length > 5)
                                TextButton(
                                  onPressed: () =>
                                      context.push('/all-transactions'),
                                  child: const Text('Show more'),
                                ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text('Error: $e'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
