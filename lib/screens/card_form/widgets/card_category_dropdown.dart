import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
import 'package:password_manager/shared/utils/card_category_util.dart';
import 'package:password_manager/shared/widgets/pm_dropdown_menu.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class CardCategoryDropdown extends ConsumerStatefulWidget {
  final void Function(CardCategory? cat) onEntrySelection;
  final CardItem? cardItem;

  const CardCategoryDropdown({
    super.key,
    required this.onEntrySelection,
    this.cardItem,
  });

  @override
  ConsumerState<CardCategoryDropdown> createState() =>
      _CardCategoryDropdownState();
}

class _CardCategoryDropdownState extends ConsumerState<CardCategoryDropdown> {
  late CardCategory _selectedCategory;
  bool _newCard = true;

  @override
  void initState() {
    super.initState();
    final categories =
        ref.read(cardCategoryListProvider).value; // TODO: Can be improved
    _selectedCategory = CardCategoryUtil.getByName(
      categories,
      'Credit',
    ); // Default category

    _newCard = widget.cardItem == null;

    if (!_newCard) {
      _selectedCategory = CardCategoryUtil.getById(
        categories!,
        widget.cardItem!.cardCategoryId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(cardCategoryListProvider);

    return categories.when(
      data: (cardCategories) {
        return PMDropdownMenu<CardCategory>(
          entries: cardCategories,
          initialSelection: _selectedCategory,
          label: 'Card Category',
          onEntrySelection: widget.onEntrySelection,
        );
      },
      error: (error, stackTrace) => const SizedBox(
        height: double.infinity,
        child: Center(
          child: Text('Something went wrong'),
        ),
      ),
      loading: () => const Spinner(),
    );
  }
}
