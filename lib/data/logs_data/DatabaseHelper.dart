import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
        version: _databaseVersion, onCreate: _onCreate);
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
    return await db
        .update(table, log.toMap(), where: 'id = ?', whereArgs: [log.logID]);
  }

  Future<int> deleteLog(int id) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getMonthlyCount(int month, int year) async {
    Database db = await database;
    String monthStr = month.toString().padLeft(2, '0');
    String yearStr = year.toString();

    var result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM $table WHERE strftime('%m', creationDate) == '$monthStr' AND strftime('%Y', creationDate) == '$yearStr'",
    );

    int count = 0;
    if (result.isNotEmpty) {
      count = Sqflite.firstIntValue(result) ?? 0;
    }
    return count;
  }

  Future<int> getLogCount() async {
    Database db = await database;

    var result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM $table",
    );

    int count = 0;
    if (result.isNotEmpty) {
      count = Sqflite.firstIntValue(result) ?? 0;
    }
    return count;
  }

  Future<List<LogEntry>> queryTodayLog() async {
    Database db = await database;

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    List<Map> maps = await db.query(
        table,
        where: "date(creationDate) = ?",
        whereArgs: [currentDate],
        orderBy: "creationDate DESC"
    );

    return List.generate(maps.length, (i) {
      return LogEntry.fromMap(maps[i] as Map<String, dynamic>);
    });
  }

  Future<List<DateTime>> fetchUniqueLogDates() async {
    Database db = await database;

    List<Map> result = await db.rawQuery(
        "SELECT DISTINCT date(creationDate) as uniqueDate FROM $table ORDER BY date(creationDate) DESC"
    );

    return result.map((item) {
      String dateString = item['uniqueDate'].toString();
      return DateTime.parse(dateString);
    }).toList();
  }

  Future<String> exportDataToJson() async {
    Database db = await database;
    List<Map> maps = await db.query(table, orderBy: "creationDate DESC");
    List<Map<String, dynamic>> logEntries = maps.map((map) => LogEntry.fromMap(map as Map<String, dynamic>).toMap()).toList();
    String json = jsonEncode(logEntries);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/log_entries_backup.json');
    await file.writeAsString(json);
    return file.path;
  }

}
