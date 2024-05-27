import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'card_provider.g.dart';

@riverpod
Future<List<CardCategory>> cardCategories(CardCategoriesRef ref) async {
  Database db = await DatabaseService.instance.db;
  var rows = await db.query('card_category');
  return rows.isNotEmpty
      ? rows.map((e) => CardCategory.fromMap(e)).toList()
      : [];
}
