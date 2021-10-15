import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/task_model.dart';

class DatabaseHelper {
  final String dbName = 'grace.db';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textNotNullType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTasks ( 
      ${TaskFields.id} $idType, 
      ${TaskFields.description} $textNotNullType
      )
    ''');
  }
}
