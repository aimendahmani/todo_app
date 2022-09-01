import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DbHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('db is not null');
    } else {
      try {
        var databasesPath = await getDatabasesPath() + 'task.db';
        _db = await openDatabase(databasesPath, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
            'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title STRING, note TEXT, isCompleted INTEGER, date STRING, startTime STRING,'
            'endTime STRING,'
            'remind INTEGER, repeat STRING,'
            'color INTEGER)',
          );
        });
      } catch (e) {
        debugPrint("error on creation database");
      }
    }
  }

  static Future<int> insert(Task task) async {
    print('!insert');
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<int> delete(Task task) async {
    print('!delete');
    return await _db!
        .delete(_tableName, where: 'title=?', whereArgs: [task.title]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('!query');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('!update');
    return await _db!.rawUpdate('''
UPDATE tasks 
SET isCompleted = ?
WHERE id = ?
''', [1, id]);
  }
}
