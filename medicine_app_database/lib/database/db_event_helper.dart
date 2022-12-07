import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:medicine_app_database/model/medicine_event.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EventData {
  final String _amountDrink_TableName= 'MedicineAmountDrink';
  final String _alart_TableName = 'MedicineAlart';
  final String _medicineId = 'medicineId';
  final String _drinkDate = 'drinkDate';
  final String _morningTime = 'morningTime';
  final String _lanchTime = 'lanchTime';
  final String _nightTime = 'nightTime';
  final String _amountDrink = 'amountDrink';
  final String _notifyId = 'notifyId';
  final String _toggle = 'toggle';
  final String _notifyTime = 'notifyTime';
  final String _isOn = 'isOn';
  
  static Database _database;
  EventData._privateConstructor();
  static final EventData instance = EventData._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    var dataDirectory = await getDatabasesPath();
    String path = join(dataDirectory, 'event.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }
  
  Future<void> _createTable(Database db, int version) async {
    String sqlAmountDrink = '''
      CREATE TABLE $_amountDrink_TableName(
        $_medicineId INTEGER PRIMARY KEY,
        $_drinkDate TEXT,
        $_morningTime TEXT,
        $_lanchTime TEXT,
        $_nightTime TEXT,
        $_amountDrink TEXT
      )
    ''';

    String sqlAlart = '''
      CREATE TABLE $_alart_TableName(
        $_medicineId INTEGER PRIMARY KEY,
        $_notifyId INTEGER PRIMARY KEY,
        $_toggle INTEGER PRIMARY KEY,
        $_notifyTime TEXT,
        $_isOn INTEGER PRIMARY KEY
      )
    ''';

    return await db.execute(sqlAmountDrink + sqlAlart);
  }

  Future<List<MedicineEvent>> queryAll() async {
    Database db = await instance.database;
    var eventJoin = await db.query(
      'SELECT * FROM $_amountDrink_TableName INNER JOIN $_alart_TableName ON $_amountDrink_TableName.$_medicineId = $_alart_TableName.$_notifyId'
    );

    return eventJoin.map((map) => MedicineEvent.fromMap(map)).toList();
  }
}
