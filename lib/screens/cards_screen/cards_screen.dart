import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
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

  void _search(String value) {}

  void _onAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CardFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardListProvider);
    final cardCategories = ref.watch(cardCategoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
      ),
      body: Column(
        children: [
          CardSearch(searchController: _searchController, search: _search),
          (cards.isLoading || cardCategories.isLoading)
              ? const Spinner()
              : Expanded(
                  child: ListView.builder(
                    itemCount: cards.value!.length,
                    itemBuilder: (ctx, index) => CardTile(
                      cardItem: cards.value![index],
                      cardCategory: CardCategoryUtil.getById(
                        cardCategories.value!,
                        cards.value![index].cardCategoryId,
                      ),
                      index: index,
                      onTap: (id, idx) {},
                      onLongPress: (id) {},
                    ),
                  ),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
