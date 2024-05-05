import 'package:flutter/material.dart';
import 'package:password_manager/models/category.dart';

class PMDropdownMenu extends StatelessWidget {
  final List<Category> categories;
  final Category initialCategory;
  final void Function(Category? category) onCategorySelection;
  const PMDropdownMenu({
    super.key,
    required this.categories,
    required this.initialCategory,
    required this.onCategorySelection,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DropdownMenu<Category>(
        label: const Text('Category'),
        initialSelection: initialCategory,
        expandedInsets: const EdgeInsets.all(0),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(12),
        ),
        dropdownMenuEntries: categories.map((ct) {
          return DropdownMenuEntry(value: ct, label: ct.name);
        }).toList(),
        onSelected: onCategorySelection,
      ),
    );
  }
}
