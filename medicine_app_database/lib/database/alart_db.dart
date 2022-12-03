import 'package:medicine_app_database/model/medicine_alart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AlartData {
  final String _tableName = "Alart";
  final int _medicineId = MedicineAlart().medicineId;
  final int _notifyId = MedicineAlart().notifyId;
  final int _toggle = MedicineAlart().toggle;
  final String _notityTime = MedicineAlart().notifyTime;

  static Database _database;

  AlartData._privateConstructor();
  static final AlartData instance = AlartData._privateConstructor();

  //データベースの参照
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
    
  }

  //データベースの初期化
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'alart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable
    );
  }

  //データテーブルの作成
  Future<void> _createTable(Database db, int version) async {
    String sql = '''
      CREATE TABLE $_tableName(
        $_medicineId INTEGER PRIMARY KEY,
        $_notifyId INTEGER PRIMARY KEY,
        $_toggle INTEGER PRIMARY KEY,
        $_notityTime TEXT
      )
    ''';
    return await db.execute(sql);
  }

  //データベースの読み込み
  Future<List<MedicineAlart>> loadAllMedicine() async {
    final db = await instance.database;
    var maps = await db.query(_tableName);

    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }

  Future insert(MedicineAlart medicine) async {
    final db = await instance.database;
    return await db.insert(_tableName, toMap(medicine));
  }

  /*更新と削除についてidが二つあるため、複数のコードが必要なのか*/
  //データの更新
  Future update(MedicineAlart medicine) async {
    final db = await instance.database;
    return await db.update(
      _tableName, 
      toMap(medicine),
      where: '$_medicineId = ?',
      whereArgs: [medicine.medicineId],
    );
  }

  //データの削除
  Future delete(MedicineAlart medicine) async {
    final db = await instance.database;
    return await db.delete(
      _tableName,
      where: '$_medicineId = ?',
      whereArgs: [medicine.medicineId],
    );
  }


  Map<String, dynamic> toMap(MedicineAlart alart) {
    return {
      //_toggle: alart.toggle,
      _notityTime: alart.notifyTime,
    };
  }

  MedicineAlart fromMap(Map<String, dynamic> json) {
    return MedicineAlart(
      medicineId: json[_medicineId],
      notifyId: json[_notifyId],
      toggle: json[_toggle],
      notifyTime: json[_notityTime]
    ); 
  }
  
}