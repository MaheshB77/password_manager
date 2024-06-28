
import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/shared/utils/date_util.dart';
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
    cardItem.id = cardItem.id ?? uuid.v4();
    cardItem.createdAt = DateTime.now();
    cardItem.updatedAt = DateTime.now();

    await db.insert('card', cardItem.toMap());

    // Updating the state
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateCard(CardItem cardItem) async {
    Database db = await DatabaseService.instance.db;
    cardItem.updatedAt = DateTime.now();

    await db.update(
      'card',
      {
        'title': cardItem.title,
        'card_category_id': cardItem.cardCategoryId,
        'card_number': cardItem.cardNumber,
        'card_holder_name': cardItem.cardHolderName,
        'is_favorite': cardItem.isFavorite,
        'pin': cardItem.pin,
        'cvv': cardItem.cvv,
        'issue_date': getDateString(cardItem.issueDate),
        'expiry_date': getDateString(cardItem.expiryDate),
        'updated_at': getDateString(cardItem.updatedAt),
      },
      where: 'id = ?',
      whereArgs: [cardItem.id],
    );

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

  Future<void> import(List<CardItem> cardsToImport) async {
    state.when(
      data: (cards) async {
        final newCards = cardsToImport
            .where(
              (card) => !cards.contains(card),
            )
            .toList();
        for (var card in newCards) {
          await save(card);
        }
      },
      error: (error, stackTrace) {
        print('Error while importing : $error');
      },
      loading: () {},
    );
  }
}