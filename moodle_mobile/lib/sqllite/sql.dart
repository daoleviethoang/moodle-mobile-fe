import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE users(baseUrl TEXT NOT NULL, username TEXT NOT NULL, token TEXT, photo TEXT, PRIMARY KEY(baseUrl,username))');
  }

  static Future<void> removeTables(sql.Database database) async {
    await database.execute('DROP TABLE IF EXISTS users');
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
      'photo': user.photo,
    };
    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<UserLogin>> getUserItems() async {
    final db = await SQLHelper.db();
    var list = await db.query('users');

    print(list.toString());

    return list.map((e) => UserLogin.fromJson(e)).toList();
  }

  static Future<void> deleteUserItem(String baseUrl, String username) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("users",
          where: "baseUrl = ? and username = ?",
          whereArgs: [baseUrl, username]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
