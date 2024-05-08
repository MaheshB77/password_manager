import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get db async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    var docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'password_manager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE passwords (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          categoryId TEXT NOT NULL,
          email TEXT,
          note TEXT,
          iconId TEXT,
          createdAt TEXT,
          updatedAt TEXT
        );

        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
        );
    ''');
  }
}
