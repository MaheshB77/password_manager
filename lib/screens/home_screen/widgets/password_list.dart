import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/category/category_provider.dart';
import 'package:password_manager/providers/password_filter_provider.dart';
import 'package:password_manager/providers/password/password_provider.dart';
import 'package:password_manager/screens/home_screen/widgets/category_chips.dart';
import 'package:password_manager/screens/home_screen/widgets/password_filter.dart';
import 'package:password_manager/screens/password_form/password_screen.dart';
import 'package:password_manager/shared/utils/category_util.dart';
import 'package:password_manager/screens/home_screen/widgets/password_tile.dart';

class PasswordList extends ConsumerStatefulWidget {
  const PasswordList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordListState();
}

class _PasswordListState extends ConsumerState<PasswordList> {
  final _searchController = TextEditingController();
  final List<Category> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _showPassword(
    BuildContext context,
    Password password,
    WidgetRef ref,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PasswordScreen(password: password),
      ),
    );
    await ref.read(passwordProvider.notifier).getPasswords();
    ref.read(passwordFilterProvider.notifier).search(_searchController.text);
    ref
        .read(passwordFilterProvider.notifier)
        .withCategories(_selectedCategories);
  }

  void _search(String search) {
    ref.read(passwordFilterProvider.notifier).search(search);
  }

  Future<void> _getPasswords() async {
    await ref.read(passwordProvider.notifier).getPasswords();
  }

  void _onTap(String id, int index) {
    final filteredPwds = ref.watch(passwordFilterProvider);
    if (anySelected) {
      ref.read(passwordFilterProvider.notifier).setSelected(id);
    } else {
      _showPassword(context, filteredPwds[index], ref);
    }
  }

  void _onLongPress(String id) {
    ref.read(passwordFilterProvider.notifier).setSelected(id);
  }

  bool get anySelected {
    final filteredPwds = ref.watch(passwordFilterProvider);
    return filteredPwds.any((pwd) => pwd.selected);
  }

  void _updateSelectedCategories(Category category, bool selected) {
    setState(() {
      if (selected && !_selectedCategories.contains(category)) {
        _selectedCategories.add(category);
      } else if (!selected) {
        _selectedCategories.remove(category);
      }
    });
    ref
        .read(passwordFilterProvider.notifier)
        .withCategories(_selectedCategories);
  }

  void _showFilters() {
    final categories = ref.watch(categoryProvider);
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return PasswordFilter(
          selectedCategories: _selectedCategories,
          categories: categories,
          updateSelectedCategories: _updateSelectedCategories,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Loading build of pwds list!!!');
    final pwds = ref.watch(passwordFilterProvider);
    final categories = ref.watch(categoryProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _showFilters,
                  icon: const Icon(Icons.filter_alt_outlined),
                ),
                border: const OutlineInputBorder(gapPadding: 5),
                contentPadding: const EdgeInsets.all(8),
              ),
              onChanged: (value) => _search(value),
            ),
          ),
        ),
        CategoryChips(
          categories: _selectedCategories,
          updateSelectedCategories: _updateSelectedCategories,
        ),
        _selectedCategories.isNotEmpty
            ? const Divider(indent: 10, endIndent: 10)
            : Container(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _getPasswords,
            child: ListView.builder(
              itemCount: pwds.length,
              itemBuilder: (ctx, index) => PasswordTile(
                password: pwds[index],
                category: CategoryUtil.getById(
                  categories,
                  pwds[index].categoryId,
                ),
                onTap: _onTap,
                index: index,
                onLongPress: _onLongPress,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
