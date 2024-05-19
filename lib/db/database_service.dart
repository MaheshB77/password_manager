import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:password_manager/db/initial_data.dart';
import 'package:password_manager/db/queries.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? database;

  Future<Database> get db async => database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    var dbPath = await getDatabasesPath();
    print('Database initialized at $dbPath');
    String path = join(dbPath, 'password_manager.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    print('Creating the database!');
    await db.execute(createPasswordTable);
    await db.execute(createCategoriesTable);
    await db.execute(createUserTable);
    await _insertDefaultCategories(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading the database!');
  }

  Future<void> _insertDefaultCategories(Database db) async {
    for (var cat in defaultCategories) {
      await db.insert('categories', cat);
    }
  }

  Future<File> getDatabaseBackup() async {
    final dbPath = await getDatabasesPath();
    final fullPath = path.join(dbPath, 'password_manager.db');
    File backupFile = File(fullPath);
    return backupFile;
  }
}
