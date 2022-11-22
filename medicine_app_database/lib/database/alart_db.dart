import 'package:medicine_app_database/model/medicine_alart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AlartData {
  final String _tableName = "Alart";
  final int _medicineId = MedicineAlart().medicineId;
  final int _notifyId = MedicineAlart().notifyId;
  final bool _toggle = MedicineAlart().toggle;
  final String _notityTime = MedicineAlart().notifyTime;

  static Database _database;

  AlartData._privateConstructor();
  static final AlartData instance = AlartData._privateConstructor();

  //データベースの参照
  Future<Database> get database async {
    if (_database != null) return _database;
    
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
        $_toggle BOOLEAN,
        $_notityTime TEXT
      )
    ''';
    return await db.execute(sql);
  }

  //データベースの読み込み
  Future<List<MedicineAlart>> loadAllMedicine() async {
    final db = await instance.database;
  }

  Map<String, dynamic> toMap(MedicineAlart alart) {
    return {
      //_toggle: alart.toggle,
      _notityTime: alart.notifyTime
    };
  }

  MedicineAlart fromMap(Map<String, dynamic> json) {
    
  }
  
}