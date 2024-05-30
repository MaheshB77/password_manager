import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'card_provider.g.dart';

const uuid = Uuid();

@riverpod
class CardList extends _$CardList {
  @override
  Future<List<CardItem>> build() async {
    print('Getting cards from DB');
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('card');
    return rows.isNotEmpty ? rows.map((e) => CardItem.fromMap(e)).toList() : [];
  }

  Future<void> save(CardItem cardItem) async {
    Database db = await DatabaseService.instance.db;
    cardItem.id = uuid.v4();
    cardItem.createdAt = DateTime.now();
    cardItem.updatedAt = DateTime.now();

    await db.insert('card', cardItem.toMap());

    // Updating the state
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(List<String> ids) async {
    Database db = await DatabaseService.instance.db;
    var placeholders = ids.map((e) => '?').join(',');
    var condition = 'id IN ($placeholders)';
    await db.delete(
      'card',
      where: condition,
      whereArgs: ids,
    );

    // Updating the state
    ref.invalidateSelf();
    await future;
  }
}
