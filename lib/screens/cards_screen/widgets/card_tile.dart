import 'package:flutter/material.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';

class CardTile extends StatelessWidget {
  final CardItem cardItem;
  final CardCategory cardCategory;
  final int index;
  final void Function(String id, int index) onTap;
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image.asset(
          'assets/ext_icons/card',
          width: 45,
        ),
        title: Text(
          'Deutsche Bank',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('2347672842342734'),
      ),
    );
  }
}
