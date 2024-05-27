import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/db/database_service.dart';
import 'package:sqflite/sqflite.dart';

class CardService {
  Future<List<CardCategory>> getCardCategories() async {
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('card_category');
    return rows.isNotEmpty ? rows.map((e) => CardCategory.fromMap(e)).toList() : [];
  }
}