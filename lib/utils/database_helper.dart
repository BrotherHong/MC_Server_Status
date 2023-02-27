import 'package:mc_server_status/models/mc_server_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // make it Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static const String _TABLE_NAME = "server_info";

  Future<Database> get database async {
    // if it's null then
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "server_info.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_TABLE_NAME(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        displayName TEXT,
        address TEXT 
      )
    ''');
  }

  Future<List<MCServerInfo>> getServerInfo() async {
    Database db = await database;
    var infoTable = await db.query(_TABLE_NAME);

    List<MCServerInfo> infoList = infoTable.isNotEmpty
        ? infoTable.map((info) => MCServerInfo.fromMap(info)).toList()
        : [];

    infoList.forEach((e) => print(e.id));

    return infoList;
  }

  Future<int> addServerInfo(MCServerInfo info) async {
    Database db = await database;
    return await db.insert(_TABLE_NAME, info.toMap());
  }

  Future<int> removeServerInfo(int id) async {
    Database db = await database;
    return await db.delete(
      _TABLE_NAME,
      where: "id = ?",
      whereArgs: [id], // 0-indexed to 1-indexed
    );
  }

  Future<int> updateServerInfo(int id, MCServerInfo newInfo) async {
    Database db = await database;
    return await db.update(
      _TABLE_NAME,
      newInfo.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
