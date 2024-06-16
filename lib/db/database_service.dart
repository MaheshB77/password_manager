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
    return _openDatabase(path);
  }

  Future<Database> _openDatabase(String path) async {
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    print('Creating the database with version $version!');
    await db.execute(createUserTable);

    await db.execute(createPasswordTable);
    await db.execute(createCategoriesTable);
    await _insertDefaultCategories(db);

    await db.execute(createCardCategoryTable);
    await db.execute(createCardTable);
    await _insertDefaultCardCategories(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading the database!');

    if (oldVersion < 2) {
      print('Updating the user table with password_hint column');
      await db.execute(updateUserTable1);
    }

    if (oldVersion < 3) {
      print('Updating the passwords table with is_favorite column');
      await db.execute(updatePasswordTable1);
    }

    if (oldVersion < 4) {
      print('Updating the card table with is_favorite column');
      await db.execute(updateCardTable1);
    }
  }

  Future<void> _insertDefaultCategories(Database db) async {
    for (var cat in defaultCategories) {
      await db.insert('categories', cat);
    }
  }

  Future<void> _insertDefaultCardCategories(Database db) async {
    for (var cardCat in defaultCardCategories) {
      await db.insert('card_category', cardCat);
    }
  }

  Future<File> getDatabaseBackup() async {
    final dbPath = await getDatabasesPath();
    final fullPath = path.join(dbPath, 'password_manager.db');
    return File(fullPath);
  }

  importDatabase(File backupFile) async {
    print('Importing the database');
    final dbPath = await getDatabasesPath();
    final sourcePath = backupFile.path;
    final targetPath = path.join(dbPath, 'password_manager.db');

    final targetFile = File(targetPath);
    if (await targetFile.exists()) {
      final currentDb = await instance.db;
      print('Closing the current database');
      await currentDb.close();

      print('Deleting the current database file');
      await targetFile.delete();
    }

    print('Copying backup database to main database');
    await File(sourcePath).copy(targetPath);

    print('Opening the imported database');
    database = await _initDatabase();
  }
}
