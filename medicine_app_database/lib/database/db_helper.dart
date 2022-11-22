import 'package:medicine_app_database/model/medicine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MedicineData {
  final int _id = Medicine().id;
  final String _tableName = "Medicine";
  final String _title = Medicine().title;
  final String _image = Medicine().image;
  final String _ocrtext = Medicine().ocrtext;
  final String _time = Medicine().time;

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
    String path = join(await getDatabasesPath(), 'medicine.db');

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
        $_id INTEGER PRIMARY KEY,
        $_title TEXT,
        $_ocrtext TEXT,
        $_time TEXT
      )
    ''';
    return await db.execute(sql);
  }

  //データベースの読み込み
  Future<List<Medicine>> loadAllMedicine() async {
    final db = await instance.database;
    var maps = await db.query(_tableName);

    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }

  //データの検索
  Future<List<Medicine>> search(String word) async {
    final db = await instance.database;
    var maps = await db.query(
      _tableName,
      orderBy: '$_time DESC',
      where: '$_title LIKE ?',
      whereArgs: ['%$word%']
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }

  
  //データベースの挿入
  Future insert(Medicine medicine) async {
    final db = await instance.database;
    return await db.insert(_tableName, toMap(medicine));
  }

  //データの更新
  Future update(Medicine medicine) async {
    final db = await instance.database;
    return await db.update(
      _tableName, 
      toMap(medicine),
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

  Map<String, dynamic> toMap(Medicine medicine) {
    return {
      _title: medicine.title,
      _image: medicine.image,
      _ocrtext: medicine.ocrtext,
      _time: medicine.time,
    };
  }

  //データベースの内容をjson化
  Medicine fromMap(Map<String, dynamic> json) {
    return Medicine(
      id: json[_id],
      title: json[_title],
      image: json[_image],
      ocrtext: json[_ocrtext],
      time: json[_time],
    );
  }
}