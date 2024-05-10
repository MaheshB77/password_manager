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
      onCreate: _onCreate,
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
    ''');
    await db.execute('''
        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        );
    ''');

    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final categories = [
      {'id': '11b5a726-3dd3-45cf-b07e-8be7865b49ef', 'name': 'Personal'},
      {'id': '2472fde2-0b3e-4ccd-b4c4-4a2d51f8bfff', 'name': 'Work'},
      {'id': '4ab72612-2321-4685-9d11-525b22a8e557', 'name': 'Finance'},
      {'id': 'efb3640a-093f-43b7-b814-3a238c25e8b6', 'name': 'Shopping'},
      {'id': 'f27321e0-1e20-4efc-971a-41175bb66b4e', 'name': 'Travel'},
      {'id': '7c2b8f4a-8dad-4a86-a6df-6504c4f20dfd', 'name': 'Social'},
      {'id': 'fc278f16-d247-45e2-abb1-4f8d733e1249', 'name': 'Other'},
    ];
    for (var cat in categories) {
      await db.insert('categories', cat);
    }
  }
}
