import 'package:flutter/foundation.dart';
import 'package:ainotes/app/common/constants/sql_constant.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE $aiNotes(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     title TEXT,
     description TEXT,
     createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     favorite INTEGER NOT NULL DEFAULT 0,
     favoriteAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
     )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'gptnote.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("... Create a table...");

        await createTable(database);
      },
    );
  }

  static Future<int> createNote(
      String title, String? description, String? createdAt) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': description,
      "createdAt": createdAt,
      'favorite': 0
    };

    final id = await db.insert(
      '$aiNotes',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await SqlHelper.db();

    //  return db.query('$gptNotes', orderBy: 'id');
    return db.query('$aiNotes', orderBy: 'createdAt');
  }

  static Future<List<Map<String, dynamic>>> getNote(int id) async {
    final db = await SqlHelper.db();

    return db.query('$aiNotes', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateNote(
      int id, String title, String? description) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateFormat.yMEd().add_jms().format(DateTime.now()),
    };

    final result =
        await db.update('$aiNotes', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteNote(int id) async {
    final db = await SqlHelper.db();

    try {
      await db.delete("$aiNotes", where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      print("something wrong when deleting an item $err");
    }
  }

  static Future<void> deleteTAbleNote() async {
    final db = await SqlHelper.db();

    try {
      db.delete(aiNotes);
    } catch (err) {
      if (kDebugMode) {
        print("something wrong when deleting an item $err");
      }
    }
  }

  static Future<void> markAsFavorite(int id) async {
    final db = await SqlHelper.db();

    final data = {
      'favorite': 1,
      'favoriteAt': DateTime.now().toString(),
    };

    await db.update(
      '$aiNotes',
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> unmarkAsFavorite(int id) async {
    final db = await SqlHelper.db();

    final data = {
      'favorite': 0,
      'favoriteAt': DateTime.now().toString(),
    };

    await db.update(
      '$aiNotes',
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// Method to get notes from the database where favorite is 1
  static Future<List<Map<String, dynamic>>> getFavoriteNotes() async {
    final db = await SqlHelper.db();
    final List<Map<String, dynamic>> maps = await db.query(
      '$aiNotes',
      where: 'favorite = ?',
      whereArgs: [1],
      orderBy: 'favoriteAt',
    );

    return maps;
  }
}
