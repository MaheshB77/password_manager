import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
import 'package:password_manager/providers/card/card_filter_provider.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/screens/card_form/card_form_screen.dart';
import 'package:password_manager/screens/cards_screen/widgets/card_search.dart';
import 'package:password_manager/screens/cards_screen/widgets/card_tile.dart';
import 'package:password_manager/shared/utils/card_category_util.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _search(String value, List<CardItem> cards) {
    ref.read(cardFilterListProvider.notifier).search(value, cards);
  }

  void _onAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CardFormScreen(),
      ),
    );
  }

  List<CardItem> getCards(List<CardItem> cards) {
    final filteredCards = ref.read(cardFilterListProvider);
    return (filteredCards.isEmpty && _searchController.text.isEmpty) ? cards : filteredCards;
  }

  @override
  Widget build(BuildContext context) {
    final cardsList = ref.watch(cardListProvider);
    final cardCategories = ref.watch(cardCategoryListProvider);
    ref.watch(cardFilterListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
      ),
      body: cardsList.when(
        data: (cards) => Column(
          children: [
            CardSearch(
              cards: cards,
              searchController: _searchController,
              search: _search,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: getCards(cards).length,
                itemBuilder: (ctx, index) => CardTile(
                  cardItem: getCards(cards)[index],
                  cardCategory: CardCategoryUtil.getById(
                    cardCategories.value!,
                    getCards(cards)[index].cardCategoryId,
                  ),
                  index: index,
                  onTap: (id, idx) {},
                  onLongPress: (id) {},
                ),
              ),
            )
          ],
        ),
        error: (error, stackTrace) => const SizedBox(
          height: double.infinity,
          child: Center(
            child: Text('Something went wrong'),
          ),
        ),
        loading: () => const Spinner(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}