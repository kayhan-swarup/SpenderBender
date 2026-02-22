import '../database/database_helper.dart';
import '../models/account.dart';

class AccountRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Account>> getAccountsByUserId(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'accounts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id ASC',
    );

    return results.map((map) => Account.fromMap(map)).toList();
  }

  Future<Account?> getAccountById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return Account.fromMap(results.first);
  }

  Future<int> createAccount(Account account) async {
    final db = await _dbHelper.database;
    return await db.insert('accounts', account.toMap());
  }

  Future<int> updateAccount(Account account) async {
    final db = await _dbHelper.database;
    return await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> updateAccountBalance(int accountId, double newBalance) async {
    final db = await _dbHelper.database;
    return await db.update(
      'accounts',
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<int> deleteAccount(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalBalance(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(balance) as total FROM accounts WHERE user_id = ?',
      [userId],
    );

    if (result.isEmpty || result.first['total'] == null) {
      return 0.0;
    }

    return (result.first['total'] as num).toDouble();
  }

  Future<bool> hasAccounts(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'accounts',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    return result.isNotEmpty;
  }
}
