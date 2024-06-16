import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_filter_provider.g.dart';

@riverpod
class CardFilterList extends _$CardFilterList {
  @override
  List<CardItem> build() {
    return ref.watch(cardListProvider).value ?? [];
  }

  void search(String searchStr) {
    var cards = ref.watch(cardListProvider).value ?? [];
    if (searchStr.isNotEmpty) {
      state = cards
          .where(
            (card) =>
                card.title.toLowerCase().contains(searchStr.toLowerCase()),
          )
          .toList();
    } else {
      state = cards;
    }
  }

  void withCategories(List<CardCategory> categories) {
    final cardsFuture = ref.read(cardListProvider);
    cardsFuture.when(
      data: (cards) {
        if (categories.isEmpty) {
          state = cards;
          return;
        }

        state = cards
            .where(
              (card) => categories.any(
                (c) => c.id == card.cardCategoryId,
              ),
            )
            .toList();
      },
      error: (error, stackErr) {},
      loading: () {},
    );
  }

  void setSelected(String id, List<CardItem> cards) {
    for (var card in cards) {
      if (card.id == id) {
        card.selected = !card.selected;
      }
    }
    state = [...cards];
  }

  void toggleFavorites(bool enableFavorites) {
    var cards = ref.watch(cardListProvider).value ?? [];
    if (enableFavorites) {
      state = cards.where((pwd) => pwd.isFavorite == 1).toList();
    } else {
      state = cards;
    }
  }
}
