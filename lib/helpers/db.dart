import 'dart:collection';
import 'package:simplicity_clock/model/event.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class CalendarDatabase {
  static final CalendarDatabase instance = CalendarDatabase._init();

  static Database? _database;
  CalendarDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('events.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final durationType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableEvents (
  ${EventFields.id} $idType,
  ${EventFields.duration} $durationType,
)

''');
  }

  Future<Event> create(Event event) async {
    final db = await instance.database;

    final id = await db.insert(tableEvents, event.toJson());
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
