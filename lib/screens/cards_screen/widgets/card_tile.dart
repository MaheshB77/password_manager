import 'package:flutter/material.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/shared/utils/theme_util.dart';

class CardTile extends StatelessWidget {
  final CardItem cardItem;
  final CardCategory cardCategory;
  final int index;
  final void Function() onTap;
  final void Function(String id) onLongPress;

  const CardTile({
    super.key,
    required this.cardItem,
    required this.cardCategory,
    required this.index,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    String bankIcon =
        ThemeUtil.isDark(context) ? cardCategory.darkIcon : cardCategory.icon;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
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
        onTap: onTap,
      ),
    );
  }
}
