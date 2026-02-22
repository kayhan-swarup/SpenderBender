import '../database/database_helper.dart';
import '../models/user.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return User.fromMap(results.first);
  }

  Future<User?> getDefaultUser() async {
    final db = await _dbHelper.database;
    final results = await db.query('users', limit: 1);

    if (results.isEmpty) return null;
    return User.fromMap(results.first);
  }

  Future<int> createUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
