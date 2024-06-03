import 'package:flutter/material.dart';
import 'package:password_manager/models/card_category.dart';

class CardCategoryChips extends StatelessWidget {
  final List<CardCategory> categories;
  final void Function(
    CardCategory category,
    bool selected,
  ) updateSelectedCategories;

  const CardCategoryChips({
    super.key,
    required this.categories,
    required this.updateSelectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      alignment: WrapAlignment.center,
      children: categories.map((cat) {
        return FilterChip(
          label: Text(cat.name),
          selected: categories.contains(cat),
          onSelected: (bool selected) =>
              updateSelectedCategories(cat, selected),
        );
      }).toList(),
    );
  }
}
