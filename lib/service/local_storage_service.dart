import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TableSchema {
  static const String favorite = "favorite";
  static const String favoriteTable = """
    CREATE TABLE $favorite (
      id TEXT PRIMARY KEY,
      name TEXT,
      description TEXT,
      pictureId TEXT,
      city TEXT,
      rating REAL
    )
  """;
}

class LocalStorageService {
  static LocalStorageService? _localStorageService;
  static late Database _database;

  LocalStorageService._internal() {
    _localStorageService = this;
  }

  factory LocalStorageService() =>
      _localStorageService ?? LocalStorageService._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, "restaurant.db"),
      onCreate: (db, version) async {
        await db.execute(TableSchema.favoriteTable);
      },
      version: 1,
    );

    return db;
  }

  Future<List<Map<String, dynamic>>> find(String table) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(table);
    return results;
  }

  Future<List<Map<String, dynamic>>> findByPrimaryKey(
      String table, String primaryKey, String value) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query(table, where: "$primaryKey = ?", whereArgs: [value]);

    return results;
  }

  Future<List<Map<String, dynamic>>> findByColumn(
      String table, String column, String value) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query(table, where: "$column LIKE ?", whereArgs: ['%$value%']);

    return results;
  }

  Future<void> insert(String table, Map<String, dynamic> objectMap) async {
    final db = await database;

    await db.insert(table, objectMap);
  }

  Future<void> deleteWithPrimaryKey(
      String table, String primaryKey, String value) async {
    final db = await database;

    await db.delete(table, where: "$primaryKey = ?", whereArgs: [value]);
  }
}
