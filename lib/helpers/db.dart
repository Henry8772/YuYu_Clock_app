// import 'dart:collection';
import 'package:simplicity_clock/model/event.dart';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:sqflite/sqlite_api.dart';
// import 'package:json_annotation/json_annotation.dart';

class CalendarDatabase {
  static final CalendarDatabase instance = CalendarDatabase._init();

  static Database? _database;
  CalendarDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('events.db');
    return _database!;
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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const durationType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableEvents (
  ${EventFields.id} $idType,
  ${EventFields.duration} $durationType,
  ${EventFields.createdDate} $textType,
  ${EventFields.createdTime} $textType,
)

''');
  }

  Future<Event> create(Event event) async {
    final db = await instance.database;

    // final json = event.toJson();
    // final columns = '${EventFields.duration}, ${EventFields.createTime}';
    // final values =
    //     '${json[EventFields.duration]}, ${json[EventFields.createTime]}';

    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableEvents, event.toJson());

    return event.copy(id: id);
  }

  Future<Event> readEvent(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableEvents,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Event> readEventByDate(DateTime day) async {
    final db = await instance.database;

    String date = DateFormat('yyyy-MM-dd').format(day);

    final maps = await db.query(
      tableEvents,
      columns: EventFields.values,
      where: '${EventFields.createdDate} = ?',
      whereArgs: [date],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      throw Exception('Day $day not found');
    }
  }

  Future<List<Event>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${EventFields.createdTime} ASC';

    final result = await db.query(tableEvents, orderBy: orderBy);

    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<int> update(Event event) async {
    final db = await instance.database;
    return db.update(
      tableEvents,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableEvents,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
