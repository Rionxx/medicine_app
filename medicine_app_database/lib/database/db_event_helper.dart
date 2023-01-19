import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:medicine_app_database/model/medicine_event.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String _amountDrink_TableName = 'MedicineAmountDrink';
const String _alart_TableName = 'MedicineAlart';
const String _medicineId = 'medicineId';
const String _medicineName = 'medicineName';
const String _drinkDate = 'drinkDate';
const String _moningTimeId = 'moningTimeId';
const String _morningTime = 'morningTime';
const String _morningDoasgeText = 'morningDoasgeText';
const String _noonTimeId = 'noontimeId';
const String _noonTime = 'noonTime';
const String _noonDoasgeText = 'noonDoasgeText';
const String _nightTimeId = 'nightTimeId';
const String _nightTime = 'nightTime';
const String _nightDoasgeText = 'nightDoasgeText';
const String _amountDrink = 'amountDrink';
const String _notifyId = 'notifyId';
const String _toggle = 'toggle';
const String _notifyTime = 'notifyTime';
const String _isOn = 'isOn';

class EventData {
  static Database? _database;
  EventData._privateConstructor();
  static final EventData instance = EventData._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
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
        $_medicineName TEXT
        $_drinkDate TEXT,
        $_moningTimeId INTEGER PRIMARY KEY,
        $_morningTime TEXT,
        $_morningDoasgeText TEXT,
        $_noonTimeId INTEGER PRIMARY KEY,
        $_noonTime TEXT,
        $_noonDoasgeText TEXT,
        $_nightTimeId INTEGER PRIMARY KEY,
        $_nightTime TEXT,
        $_nightDoasgeText TEXT,
        $_amountDrink TEXT
      )
    ''';

    String sqlAlart = '''
      CREATE TABLE $_alart_TableName(
        $_medicineId INTEGER PRIMARY KEY,
        $_notifyId INTEGER PRIMARY KEY,
        $_toggle INTEGER PRIMARY KEY,
        $_notifyTime TEXT,
        $_isOn BOOLEAN
      )
    ''';

    return await db.execute(sqlAmountDrink + sqlAlart);
  }

  Future<List<MedicineEvent>> queryAll() async {
    Database db = await instance.database;
    var eventJoin = await db.query(
        'SELECT * FROM $_amountDrink_TableName INNER JOIN $_alart_TableName ON $_amountDrink_TableName.$_medicineId = $_alart_TableName.$_medicineId');

    return eventJoin.map((map) => MedicineEvent.fromMap(map)).toList();
  }

  Future<int> insert(MedicineEvent event) async {
    final db = await instance.database;
    return await db.insert(
        _amountDrink_TableName + _alart_TableName, event.toMap());
  }

  Future update(MedicineEvent event) async {
    final db = await instance.database;
    return await db.update(
        _amountDrink_TableName + _alart_TableName, event.toMap(),
        where: '$_medicineId = ?', whereArgs: [event.medicineId]);
  }

  Future delete(MedicineEvent event) async {
    final db = await instance.database;
    return await db.delete(
      _amountDrink_TableName + _alart_TableName,
      where: '$_medicineId = ?',
      whereArgs: [event.medicineId],
    );
  }
}
