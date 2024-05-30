import 'package:password_manager/models/card_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_filter_provider.g.dart';

@riverpod
class CardFilterList extends _$CardFilterList {
  @override
  List<CardItem> build() {
    return [];
  }

  void search(String searchStr, List<CardItem> list) {
    if (searchStr.isNotEmpty) {
      state = list
          .where(
            (card) =>
                card.title.toLowerCase().contains(searchStr.toLowerCase()),
          )
          .toList();
    } else {
      state = list;
    }
  }
}
