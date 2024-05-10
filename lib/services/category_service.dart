import 'package:password_manager/models/category.dart';
import 'package:password_manager/db/database_service.dart';
import 'package:sqflite/sqflite.dart';

class CategoryService {
    Future<List<Category>> getCategories() async {
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('categories');
    print('Rows : $rows');
    return rows.isNotEmpty ? rows.map((e) => Category.fromMap(e)).toList() : [];
  }
}