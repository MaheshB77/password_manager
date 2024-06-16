import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/shared/utils/theme_util.dart';

class CardTile extends ConsumerWidget {
  final CardItem cardItem;
  final CardCategory cardCategory;
  final int index;
  final void Function() onTap;
  final void Function() onLongPress;

  const CardTile({
    super.key,
    required this.cardItem,
    required this.cardCategory,
    required this.index,
    required this.onTap,
    required this.onLongPress,
  });

  Future<void> _toggleFavorite(WidgetRef ref) async {
    cardItem.isFavorite = cardItem.isFavorite == 1 ? 0 : 1;
    await ref.read(cardListProvider.notifier).updateCard(cardItem);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String bankIcon =
        ThemeUtil.isDark(context) ? cardCategory.darkIcon : cardCategory.icon;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16.0, right: 0.0),
        leading: Image.asset(bankIcon),
        title: Text(
          cardItem.title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          cardItem.cardNumber,
          style: Theme.of(context).textTheme.bodySmall!,
        ),
        trailing: IconButton(
          icon: cardItem.isFavorite == 0
              ? const Icon(Icons.star_border)
              : const Icon(Icons.star),
          onPressed: () async {
            await _toggleFavorite(ref);
          },
        ),
        onTap: onTap,
        onLongPress: () => onLongPress(),
        selected: cardItem.selected,
        selectedTileColor: Theme.of(context).colorScheme.outlineVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
