import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/category/category_provider.dart';
import 'package:password_manager/providers/password_filter_provider.dart';
import 'package:password_manager/providers/password/password_provider.dart';
import 'package:password_manager/screens/passwords_screen/widgets/no_passwords.dart';
import 'package:password_manager/screens/password_form/password_form_screen.dart';
import 'package:password_manager/shared/widgets/pm_exit_confirmation.dart';
import 'package:password_manager/shared/widgets/side_drawer.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_list.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class PasswordsScreen extends ConsumerStatefulWidget {
  const PasswordsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends ConsumerState<PasswordsScreen> {
  late Future<List<Password>> _passwordFuture;
  bool _deleting = false;
  bool _favorites = false;

  @override
  void initState() {
    super.initState();
    _passwordFuture = ref.read(passwordProvider.notifier).getPasswords();
    ref.read(categoryProvider.notifier).getCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PasswordFormScreen(
          password: Password(
            title: '',
            username: '',
            password: '',
            categoryId: '',
          ),
        ),
      ),
    );
    _passwordFuture = ref.read(passwordProvider.notifier).getPasswords();
  }

  Future<void> _deleteSelected(
    void Function(void Function()) dSetState,
  ) async {
    final selectedPwds = ref.watch(passwordFilterProvider);
    List<String> ids = selectedPwds
        .where((pwd) => pwd.selected)
        .map((pwd) => pwd.id!)
        .toList();

    dSetState(() => _deleting = true);
    await ref.read(passwordProvider.notifier).deleteMultiple(ids);
    _passwordFuture = ref.read(passwordProvider.notifier).getPasswords();
    dSetState(() => _deleting = false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _clearSelected() {
    ref.read(passwordFilterProvider.notifier).clearSelected();
  }

  bool get anySelected {
    final filteredPwds = ref.watch(passwordFilterProvider);
    return filteredPwds.any((pwd) => pwd.selected);
  }

  void _deleteConfirmation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Deleting'),
            content: const Text('Do you want to delete selected passwords ?'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: _deleting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _deleting
                    ? null
                    : () async => await _deleteSelected(setState),
                child: _deleting ? const Spinner() : const Text('Yes'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get actionRow {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.star);
        }
        return const Icon(Icons.star_border);
      },
    );

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          anySelected
              ? IconButton(
                  onPressed: _deleteConfirmation,
                  icon: const Icon(Icons.delete),
                )
              : Switch(
                  value: _favorites,
                  thumbIcon: thumbIcon,
                  onChanged: (value) {
                    ref
                        .read(passwordFilterProvider.notifier)
                        .toggleFavorites(value);
                    setState(() => _favorites = value);
                  },
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Loading Home Screen!');

    return PMExitConfirmation(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Passwords'),
          actions: [actionRow],
          leading: anySelected
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSelected,
                )
              : null,
        ),
        drawer: const SideDrawer(),
        body: FutureBuilder(
          future: _passwordFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            } else if (snapshot.data != null && snapshot.data!.isEmpty) {
              return const NoPasswords();
            } else {
              return const PasswordList();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
