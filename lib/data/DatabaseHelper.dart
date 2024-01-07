import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'LogEntry.dart';

class DatabaseHelper {
  static const _databaseName = "TinyLogsDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'logs';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY,
            creationDate TEXT NOT NULL,
            content TEXT NOT NULL,
            lastUpdated TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertLog(LogEntry log) async {
    Database db = await database;
    int id = await db.insert(table, log.toMap());
    return id;
  }

  Future<List<LogEntry>> queryAllLogs() async {
    Database db = await database;
    List<Map> maps = await db.query(table, orderBy: "creationDate desc");
    return List.generate(maps.length, (i) {
      return LogEntry.fromMap(maps[i] as Map<String, dynamic>);
    });
  }

  Future<int> updateLog(LogEntry log) async {
    Database db = await database;
    return await db.update(table, log.toMap(),
        where: 'id = ?', whereArgs: [log.logID]);
  }

  Future<int> deleteLog(int id) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

}
