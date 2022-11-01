import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import 'package:list_function/model/photo.dart';

/******************Next Code********************/

class DBHelper {
  static Database _db;
  static const String id = 'id';
  static const String text = 'text';
  static const String photo = 'photostable';
  static const String db_name = 'data.db';

  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  //database init
  static Future<Database> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '$documentsDirectory${Platform.pathSeparator}$db_name';
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //database create
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $photo ('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$text TEXT,)'
    );
  }

  //read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DBHelper.initDB();
    return db.query('items', orderBy: id);
  }

  //read single item
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DBHelper.initDB();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //update item
  static Future<int> updateItem(int id, String text, String photo) async {
    final db = await DBHelper.initDB();

    final data = {
      'text': text,
      'photo': photo,
    };

    final result = await db.update('items', data, where: "id=?", whereArgs: [id]);
    return result;
  }

  // delete item
  static Future<void> deleteItem(int id) async {
    final db = await DBHelper.initDB();
    try {
      db.delete("items", where: "id=?", whereArgs: [id]);
    } catch(err) {
      //debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}