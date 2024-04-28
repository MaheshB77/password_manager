import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_filter_provider.dart';
import 'package:password_manager/providers/password_provider.dart';
import 'package:password_manager/providers/password_select_provider.dart';
import 'package:password_manager/screens/password_screen.dart';

class PasswordList extends ConsumerStatefulWidget {
  final List<Password> passwords;
  final void Function(bool selecting) onSelecting;
  const PasswordList({
    super.key,
    required this.passwords,
    required this.onSelecting,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordListState();
}

class _PasswordListState extends ConsumerState<PasswordList> {
  final FocusNode _focusNode = FocusNode();
  bool _searching = false;
  bool _selecting = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _searching = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
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
  }

  void _filter(String search) {
    ref.read(passwordFilterProvider.notifier).filterPassword(search);
  }

  Future<void> _getPasswords() async {
    await ref.read(passwordProvider.notifier).getPasswords();
  }

  void _onTap(String id, int index) {
    if (_selecting) {
      ref.read(passwordSelectProvider.notifier).setSelected(id);
      final anySelected = ref.watch(passwordSelectProvider).any((pwd) => pwd.selected);
      if (!anySelected) {
        _setSelecting(false);
      }
    } else {
      _showPassword(context, widget.passwords[index], ref);
    }
  }

  void _onLongPress(String id) {
    ref.read(passwordSelectProvider.notifier).setSelected(id);
    _setSelecting(true);
  }

  void _setSelecting(bool selecting) {
    setState(() {
      _selecting = selecting;
    });
    widget.onSelecting(selecting);
  }

  @override
  Widget build(BuildContext context) {
    print('Loading build of pwds list!!!');
    final filteredPwds = ref.watch(passwordFilterProvider);
    final selectedPwds = ref.watch(passwordSelectProvider);
    final pwds = _searching ? filteredPwds : selectedPwds;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TextField(
            focusNode: _focusNode,
            // enabled: !_selecting,
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
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(pwds[index].title[0].toUpperCase()),
                  ),
                  title: Text(
                    pwds[index].title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    pwds[index].username.isNotEmpty
                        ? pwds[index].username
                        : 'NA',
                  ),
                  onTap: () {
                    _onTap(pwds[index].id!, index);
                  },
                  onLongPress: () => {_onLongPress(pwds[index].id!)},
                  selected: pwds[index].selected,
                  selectedTileColor:
                      Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
