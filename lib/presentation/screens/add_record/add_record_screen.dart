import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../data/models/transaction.dart' as models;
import '../../../providers/account_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/navigation_provider.dart';
import '../../../core/utils/date_formatter.dart';

class AddRecordScreen extends ConsumerStatefulWidget {
  const AddRecordScreen({super.key});

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedType = 'expense';
  int? _selectedAccountId;
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  int _formResetKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountsProvider.notifier).fetchAccounts(AppConstants.defaultUserId);
      ref.read(categoriesProvider.notifier).fetchCategories();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAccountId == null || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select account and category')),
      );
      return;
    }

    final amount = double.parse(_amountController.text);

    setState(() {
      _isLoading = true;
    });

    try {
      final accountsState = ref.read(accountsProvider);
      final accounts = accountsState.value;

      if (accounts == null) throw Exception('Accounts not loaded');

      final account = accounts.firstWhere(
        (a) => a.id == _selectedAccountId,
        orElse: () => throw Exception('Account not found'),
      );

      final newBalance = _selectedType == 'expense'
          ? account.balance - amount
          : account.balance + amount;

      final transaction = models.Transaction(
        accountId: _selectedAccountId!,
        categoryId: _selectedCategoryId!,
        type: _selectedType,
        amount: amount,
        date: _selectedDate,
      );

      await ref.read(transactionsProvider.notifier).createTransactionWithBalance(
            transaction: transaction,
            accountId: _selectedAccountId!,
            newBalance: newBalance,
          );

      await ref.read(accountsProvider.notifier).fetchAccounts(AppConstants.defaultUserId);
      await ref.read(recentTransactionsProvider.notifier).fetchRecentTransactions(AppConstants.defaultUserId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction created successfully')),
        );
        _formKey.currentState!.reset();
        _amountController.clear();
        setState(() {
          _selectedAccountId = null;
          _selectedCategoryId = null;
          _selectedDate = DateTime.now();
          _formResetKey++; // Force dropdown rebuild
        });

        // Navigate back to dashboard tab
        ref.read(navigationProvider.notifier).goToDashboard();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Add Record'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Expense')),
                    selected: _selectedType == 'expense',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedType = 'expense';
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Income')),
                    selected: _selectedType == 'income',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedType = 'income';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 48),
              decoration: const InputDecoration(
                hintText: '0',
                prefix: Text('BDT ', style: TextStyle(fontSize: 24)),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Amount is required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'GENERAL',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Icon(Icons.account_balance, color: Colors.white),
              ),
              title: accountsAsync.when(
                data: (accounts) => DropdownButtonFormField<int>(
                  key: ValueKey('account_dropdown_$_formResetKey'),
                  initialValue: _selectedAccountId,
                  hint: const Text('Select Account'),
                  items: accounts.map((account) {
                    return DropdownMenuItem(
                      value: account.id,
                      child: Text(account.accountName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountId = value;
                    });
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
                loading: () => const Text('Loading...'),
                error: (e, s) => const Text('Error'),
              ),
              tileColor: AppTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Icon(Icons.category, color: Colors.white),
              ),
              title: categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<int>(
                  key: ValueKey('category_dropdown_$_formResetKey'),
                  initialValue: _selectedCategoryId,
                  hint: const Text('Select Category'),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
                loading: () => const Text('Loading...'),
                error: (e, s) => const Text('Error'),
              ),
              tileColor: AppTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Icon(Icons.calendar_today, color: Colors.white),
              ),
              title: Text(DateFormatter.formatDateTime(_selectedDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              tileColor: AppTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
