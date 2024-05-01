import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/category_provider.dart';
import 'package:password_manager/providers/password_filter_provider.dart';
import 'package:password_manager/providers/password_provider.dart';
import 'package:password_manager/screens/password_screen.dart';
import 'package:password_manager/widgets/password_tile.dart';

class PasswordList extends ConsumerStatefulWidget {
  const PasswordList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordListState();
}

class _PasswordListState extends ConsumerState<PasswordList> {
  final _searchController = TextEditingController();

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
    ref
        .read(passwordFilterProvider.notifier)
        .filterPassword(_searchController.text);
  }

  void _filter(String search) {
    ref.read(passwordFilterProvider.notifier).filterPassword(search);
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

  @override
  Widget build(BuildContext context) {
    print('Loading build of pwds list!!!');
    final pwds = ref.watch(passwordFilterProvider);
    final categories = ref.watch(categoryProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            onChanged: (value) {
              _filter(value);
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _getPasswords,
            child: ListView.builder(
              itemCount: pwds.length,
              itemBuilder: (ctx, index) => SizedBox(
                height: 70,
                child: PasswordTile(
                  password: pwds[index],
                  category: categories.firstWhere(
                    (c) => c.id == pwds[index].categoryId,
                  ),
                  onTap: _onTap,
                  index: index,
                  onLongPress: _onLongPress,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
