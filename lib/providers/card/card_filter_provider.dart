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

  void search(String searchStr, List<CardItem> cards) {
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

  void setSelected(String id, List<CardItem> cards) {
    for (var card in cards) {
      if (card.id == id) {
        card.selected = !card.selected;
      }
    }
    state = [...cards];
  }
}
