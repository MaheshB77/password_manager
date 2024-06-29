import 'package:flutter/material.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/category.dart';

class PMDropdownMenu<T> extends StatelessWidget {
  final Key? fieldKey;
  final List<T> entries;
  final T initialSelection;
  final String label;
  final void Function(T? category) onEntrySelection;

  const PMDropdownMenu({
    super.key,
    required this.entries,
    required this.initialSelection,
    required this.label,
    required this.onEntrySelection,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DropdownMenu<T>(
        label: Text(label),
        key: fieldKey,
        initialSelection: initialSelection,
        expandedInsets: const EdgeInsets.all(0),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(12),
        ),
        dropdownMenuEntries: entries.map((entry) {
          if (entry is Category) {
            return DropdownMenuEntry(
              value: entry,
              label: entry.name,
            );
          }
          if (entry is CardCategory) {
            return DropdownMenuEntry(
              value: entry,
              label: entry.name,
            );
          }
          return DropdownMenuEntry(
            value: entry,
            label: '',
          );
        }).toList(),
        onSelected: onEntrySelection,
      ),
    );
  }
}
