import 'package:password_manager/db/initial_data.dart';
import 'package:password_manager/db/queries.dart';
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
    await db.execute(createPasswordTable);
    await db.execute(createCategoriesTable);

    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    for (var cat in defaultCategories) {
      await db.insert('categories', cat);
    }
  }
}
