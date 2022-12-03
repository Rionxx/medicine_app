import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:medicine_app_database/model/medicine.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MedicineData {
  final String _id = 'id';
  final String _tableName = "Medicine";
  final String _title = 'title';
  final String _image = 'image';
  final String _ocrtext = 'ocrtext';
  final String _time = 'time';

  static Database _database;

  MedicineData._privateConstructor();
  static final MedicineData instance = MedicineData._privateConstructor();

  //データベースの参照
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  //データベースの初期化
  Future<Database> _initDB() async {
    var dataDirectory = await getDatabasesPath();
    String path = join(dataDirectory, 'medicine.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  //データベースのテーブル設計
  Future<void> _createTable(Database db, int version) async {
    String sql = '''
      CREATE TABLE $_tableName(
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_title TEXT,
        $_image TEXT,
        $_ocrtext TEXT,
        $_time TEXT
      )
    ''';
    return await db.execute(sql);
  }

  //データベースの読み込み
  Future<List<Medicine>> loadAllMedicine() async {
    final db = await instance.database;
    var medicinesData = await db.query(_tableName);

    return  medicinesData.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<Medicine> medicineData(int id) async {
    final db = await instance.database;
    var medicine = [];
    medicine = await db.query(
      'medicine',
      where: '$_id = ?',
      whereArgs: [id],
    );
    return Medicine.fromMap(medicine.first);
  }

  //データの検索
  
  Future<List<Medicine>> search(String keyword) async {
    final db = await instance.database;
    var maps = await db.query(
      _tableName,
      orderBy: '$_time DESC',
      where: '$_title LIKE ?',
      whereArgs: ['%$keyword%']
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => Medicine.fromMap(map)).toList();
  }

  
  //データベースの挿入
  Future<int> insert(Medicine medicine) async {
    final db = await instance.database;
    return await db.insert(_tableName, medicine.toMap());
  }

  //データの更新
  Future update(Medicine medicine) async {
    final db = await instance.database;
    return await db.update(
      _tableName, 
      medicine.toMap(),
      where: '$_id = ?',
      whereArgs: [medicine.id],
    );
  }

  //データの削除
  Future delete(Medicine medicine) async {
    final db = await instance.database;
    return await db.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [medicine.id],
    );
  }
}