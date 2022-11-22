import 'package:medicine_app_database/model/medicine.dart';
import 'package:medicine_app_database/model/medicine_drink_time.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class AmountDrinkData {
  final String _tableName = "AmountDrink";
  final int _medicineId = MedicineDrinkTime().medicineId;
  final String _date = MedicineDrinkTime().date;
  final String _morningTime = MedicineDrinkTime().morningTime;
  final String _lanchTime = MedicineDrinkTime().lanchTime;
  final String _nightTime = MedicineDrinkTime().nightTime;
  final String _amountDrink = MedicineDrinkTime().amountDrink;

  static Database _database;
  static final AmountDrinkData instance = AmountDrinkData._privateConstructor();
  AmountDrinkData._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'amountdrink.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable
    );
  }

  Future<void> _createTable(Database db, int version) async {
    String sql = ''' 
      CREATE TABLE $_tableName(
        $_medicineId INTEGER PRIMARY KEY,
        $_date TEXT,
        $_morningTime TEXT,
        $_lanchTime TEXT,
        $_nightTime TEXT,
        $_amountDrink TEXT
      )
      ''';

      return await db.execute(sql);
  }

  Future<List<MedicineDrinkTime>> loadAllMedicine() async {
    final db = await instance.database;
    var maps = await db.query(_tableName);
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }

  Future insert(MedicineDrinkTime medicine) async {
    final db = await instance.database;
    return await db.insert(_tableName, toMap(medicine));
  }

  Future update(MedicineDrinkTime medicine) async {
    final db = await instance.database;
    return await db.update(
      _tableName,
      toMap(medicine),
      where: '$_medicineId = ?',
      whereArgs: [medicine.medicineId],
    );
  }

  Future delete(MedicineDrinkTime medicine) async {
    final db = await instance.database;
    return await db.delete(
      _tableName,
      where: '$_medicineId = ?',
      whereArgs: [medicine.medicineId],
    );
  }

  Map<String, dynamic> toMap(MedicineDrinkTime medicine) {
    return {
      _date: medicine.date,
      _morningTime: medicine.morningTime,
      _lanchTime: medicine.lanchTime,
      _nightTime: medicine.nightTime,
      _amountDrink: medicine.amountDrink,
    };
  }

  MedicineDrinkTime fromMap(Map<String, dynamic> json) {
    return MedicineDrinkTime(
      medicineId: json[_medicineId],
      date: json[_date],
      morningTime: json[_morningTime],
      lanchTime: json[_lanchTime],
      nightTime: json[_nightTime],
      amountDrink: json[_amountDrink]
    );
  }
}