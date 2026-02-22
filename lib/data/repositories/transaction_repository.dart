import '../database/database_helper.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Transaction>> getTransactionsByUserId(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT t.* FROM transactions t
      INNER JOIN accounts a ON t.account_id = a.id
      WHERE a.user_id = ?
      ORDER BY t.date DESC
    ''', [userId]);

    return results.map((map) => Transaction.fromMap(map)).toList();
  }

  Future<List<Transaction>> getRecentTransactions(int userId, {int limit = 5}) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT t.* FROM transactions t
      INNER JOIN accounts a ON t.account_id = a.id
      WHERE a.user_id = ?
      ORDER BY t.date DESC
      LIMIT ?
    ''', [userId, limit]);

    return results.map((map) => Transaction.fromMap(map)).toList();
  }

  Future<Transaction?> getTransactionById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return Transaction.fromMap(results.first);
  }

  Future<int> createTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> createTransactionAndUpdateBalance({
    required Transaction transaction,
    required int accountId,
    required double newBalance,
  }) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.insert('transactions', transaction.toMap());

      await txn.update(
        'accounts',
        {'balance': newBalance},
        where: 'id = ?',
        whereArgs: [accountId],
      );
    });
  }

  Future<void> deleteTransactionAndUpdateBalance({
    required int transactionId,
    required int accountId,
    required double newBalance,
  }) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [transactionId],
      );

      await txn.update(
        'accounts',
        {'balance': newBalance},
        where: 'id = ?',
        whereArgs: [accountId],
      );
    });
  }
}
