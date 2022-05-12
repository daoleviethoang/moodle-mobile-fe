import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,baseUrl TEXT,token TEXT, username TEXT)');
  }

  static Future<void> removeTables(sql.Database database) async {
    await database.execute('DROP TABLE IF EXISTS items');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'moodle.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
      onUpgrade: (sql.Database database, oldVersion, newVersion) async {
        if (oldVersion != newVersion) {
          await removeTables(database);
          await createTables(database);
        }
      },
    );
  }

  static Future<int> createUserItem(UserLogin user) async {
    final db = await SQLHelper.db();

    final data = {
      'baseUrl': user.baseUrl,
      'token': user.token,
      'username': user.username,
    };
    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<UserLogin>> getUserItems() async {
    final db = await SQLHelper.db();
    var list = db.query('users', orderBy: "id") as List;

    return list.map((e) => UserLogin.fromJson(e)).toList();
  }

  static Future<void> deleteUserItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("users", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
