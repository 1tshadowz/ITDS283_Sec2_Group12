// db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._(); // ✅ เพิ่ม instance แบบ static
  static Database? _database;

  DatabaseHelper._(); // ✅ Constructor แบบ private

  Future<Database> get database async {
    _database ??= await _initDB("users.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT UNIQUE,
        password TEXT,
        phone TEXT,
        last_month TEXT,
        last_2_month TEXT,
        last_3_month TEXT,
        water_type TEXT,
        cost TEXT,
        record_bill INTEGER,
        think_waste INTEGER
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    return await db.insert('users', userData);
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> isEmailExist(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}
