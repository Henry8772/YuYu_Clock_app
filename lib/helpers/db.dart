import 'package:simplicity_clock/model/event.dart';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalendarDatabase {
  static final CalendarDatabase instance = CalendarDatabase._init();

  static Database? _database;
  CalendarDatabase._init();

  Future<Database> get database async {
    print("get database");
    if (_database != null) {
      // var fido = Event(
      //   id: 0,
      //   duration: 3,
      //   createdDate: DateTime.now(),
      //   createdTime: DateTime.now(),
      // );

      // await insertEvent(fido);
      return _database!;
    }

    _database = await _initDB('$databaseName.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    print("init database");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    print('create database');
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const durationType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $databaseName (
  ${EventFields.id} $idType,
  ${EventFields.duration} $durationType,
  ${EventFields.createdDate} $textType,
  ${EventFields.createdTime} $textType
)

''');
  }

  Future<Event> insertEvent(Event event) async {
    // String path = await getDatabasesPath();

    // print(path);
    print(event);
    // print(getAll());

    final db = await instance.database;

    // final json = event.toJson();
    // final columns = '${EventFields.duration}, ${EventFields.createTime}';
    // final values =
    //     '${json[EventFields.duration]}, ${json[EventFields.createTime]}';

    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(databaseName, event.toJson());

    return event.copy(id: id);
  }

  // Future<List> getAll() async {
  //   var dbClient = await instance.database;
  //   var result = await dbClient.rawQuery("SELECT * FROM $tableEvents");
  //   //  var result = await dbClient
  //   //       .rawQuery("SELECT * FROM $tableEvents where $columnDate >= '2021-01-01' and
  //   //   $columnDate <= '2022-10-10' ");

  //   return Event.fromJson(result.first);
  // }

  Future<Event> readEvent(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      databaseName,
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

  Future<List<Event>> readEventByDate(DateTime day) async {
    final db = await instance.database;

    String date = DateFormat('yyyy-MM-dd').format(day);
    print("Reading event by date: $date");
    final maps = await db.query(
      databaseName,
      columns: EventFields.values,
      where: '${EventFields.createdDate} = ?',
      whereArgs: [date],
    );

    List<Event> events = [];
    if (maps.isNotEmpty) {
      for (Map<String, Object?> item in maps) {
        print("Print item in maps");
        print(item);
        events.add(Event.fromJson(item));
      }
    }
    return events;
  }

  Future<List<Event>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${EventFields.createdTime} ASC';

    final result = await db.query(databaseName, orderBy: orderBy);

    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<int> update(Event event) async {
    final db = await instance.database;
    return db.update(
      databaseName,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      databaseName,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
