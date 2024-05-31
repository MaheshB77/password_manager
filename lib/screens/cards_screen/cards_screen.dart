import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
import 'package:password_manager/providers/card/card_filter_provider.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/screens/card_form/card_form_screen.dart';
import 'package:password_manager/screens/card_view/card_view_screen.dart';
import 'package:password_manager/screens/cards_screen/widgets/card_search.dart';
import 'package:password_manager/screens/cards_screen/widgets/card_tile.dart';
import 'package:password_manager/shared/utils/card_category_util.dart';
import 'package:password_manager/shared/widgets/side_drawer.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  final _searchController = TextEditingController();
  bool _deleting = false;

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

  void _onTap(CardItem cardItem, List<CardItem> cards) async {
    if (anySelected) {
      ref
          .read(cardFilterListProvider.notifier)
          .setSelected(cardItem.id!, cards);
    } else {
      _viewCardScreen(cardItem);
    }
  }

  void _viewCardScreen(CardItem cardItem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CardViewScreen(cardItem: cardItem),
      ),
    );
  }

  void _onLongPress(String id, List<CardItem> cards) {
    ref.read(cardFilterListProvider.notifier).setSelected(id, cards);
  }

  void _deleteConfirmation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Deleting'),
            content: const Text('Do you want to delete selected cards ?'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: _deleting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _deleting
                    ? null
                    : () async => await _deleteSelected(setState),
                child: _deleting ? const Spinner() : const Text('Yes'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteSelected(void Function(void Function()) dSetState) async {
    final filteredCards = ref.read(cardFilterListProvider);
    dSetState(() => _deleting = true);

    List<String> selectedIds = filteredCards
        .where(
          (card) => card.selected,
        )
        .map((e) => e.id!)
        .toList();

    await ref.read(cardListProvider.notifier).delete(selectedIds);
    dSetState(() => _deleting = false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  bool get anySelected {
    final filteredCards = ref.watch(cardFilterListProvider);
    return filteredCards.any((card) => card.selected);
  }

  List<CardItem> getCards(List<CardItem> cards) {
    final filteredCards = ref.read(cardFilterListProvider);
    return (filteredCards.isEmpty && _searchController.text.isEmpty)
        ? cards
        : filteredCards;
  }

  @override
  Widget build(BuildContext context) {
    final cardsList = ref.watch(cardListProvider);
    final cardCategories = ref.watch(cardCategoryListProvider);
    ref.watch(cardFilterListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        actions: anySelected
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteConfirmation,
                ),
              ]
            : [],
      ),
      drawer: const SideDrawer(),
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
                    cardCategories.value == null ? [] : cardCategories.value!,
                    getCards(cards)[index].cardCategoryId,
                  ),
                  index: index,
                  onTap: () {
                    _onTap(getCards(cards)[index], getCards(cards));
                  },
                  onLongPress: () {
                    _onLongPress(getCards(cards)[index].id!, getCards(cards));
                  },
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
