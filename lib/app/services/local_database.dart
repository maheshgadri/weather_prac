import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'weather.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE weather (
            id INTEGER PRIMARY KEY,
            city TEXT,
            temperature REAL,
            description TEXT,
            icon TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertWeather(Map<String, dynamic> weather) async {
    final db = await database;
    await db.insert('weather', weather, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchWeather() async {
    final db = await database;
    return await db.query('weather');
  }
}

