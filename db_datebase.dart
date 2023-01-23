import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // privateなコンストラクタ
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB();
      return _database!;
    }
  }

  Future<Database> initDB() async {
    //データベースを作成
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "medicineDB.db");
    final Future<Database> database = openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
            // テーブルの作成
            "CREATE TABLE medicine (id INTEGER PRIMARY KEY AUTOINCREMENT,titleText TEXT ,image TEXT, ocrText TEXT, time TEXT)");
        await db.execute(
            "CREATE TABLE event (id INTEGER PRIMARY KEY AUTOINCREMENT , titleText, date TEXT,mornningDrinkTime TEXT, morningDoasge  TEXT , noonDrinkTime TEXT , noonDoasge TEXT , nightDrinkTime TEXT , nightDoasge TEXT , morningDrinkTimeId INTEGER , noonDrinkId INTEGER , nightDoasgeId  INTEGER , notificationTime TEXT, isOn INTEGER )");
      },
      version: 1,
    );
    return database;
  }
}
