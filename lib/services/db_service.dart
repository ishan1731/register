import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/user.dart';
import '../models/task.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "app.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      email TEXT,
      password TEXT,
      phone TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      isCompleted INTEGER,
      questionsJson TEXT
    );
    ''');
  }

  // Users
  Future<int> insertUser(User user) async {
    final database = await db;
    return await database.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final database = await db;
    final res = await database.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final database = await db;
    final res = await database.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<User?> getLastRegisteredUser() async {
    final database = await db;
    final res = await database.rawQuery('SELECT * FROM users ORDER BY id DESC LIMIT 1');
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  // Tasks
  Future<int> createTask(Task task) async {
    final database = await db;
    return await database.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasksByUser(int userId) async {
    final database = await db;
    final res = await database.query('tasks', where: 'userId = ?', whereArgs: [userId], orderBy: 'id DESC');
    return res.map((m) => Task.fromMap(m)).toList();
  }

  Future<void> markTaskCompleted(int id) async {
    final database = await db;
    await database.update('tasks', {'isCompleted': 1}, where: 'id = ?', whereArgs: [id]);
  }
}
