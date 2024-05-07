import 'package:flutter/material.dart';
import 'package:password_manager/models/category.dart';

class PasswordFilter extends StatefulWidget {
  final List<Category> selectedCategories;
  final List<Category> categories;
  final void Function(
    Category category,
    bool selected,
  ) updateSelectedCategories;

  const PasswordFilter({
    super.key,
    required this.selectedCategories,
    required this.categories,
    required this.updateSelectedCategories,
  });

  @override
  State<PasswordFilter> createState() => _PasswordFilterState();
}

class _PasswordFilterState extends State<PasswordFilter> {
  List<Category> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.selectedCategories;
  }

  void _onCategorySelection(Category cat, bool selected) {
    setState(() {
      if (selected && !_selectedCategories.contains(cat)) {
        _selectedCategories.add(cat);
      } else if (!selected) {
        _selectedCategories.remove(cat);
      }
    });
    widget.updateSelectedCategories(cat, selected);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (bCtx, setState) => SizedBox(
        height: 250,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose category',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  alignment: WrapAlignment.center,
                  children: widget.categories.map((cat) {
                    return FilterChip(
                      label: Text(cat.name),
                      selected: _selectedCategories.contains(cat),
                      onSelected: (bool selected) {
                        _onCategorySelection(cat, selected);
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 5.0),
              ElevatedButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
