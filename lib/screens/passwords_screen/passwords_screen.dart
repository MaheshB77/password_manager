import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/category/category_provider.dart';
import 'package:password_manager/providers/password_filter_provider.dart';
import 'package:password_manager/providers/password/password_provider.dart';
import 'package:password_manager/screens/passwords_screen/widgets/no_passwords.dart';
import 'package:password_manager/screens/password_form/password_form_screen.dart';
import 'package:password_manager/shared/widgets/side_drawer.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_list.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Password>> _passwordFuture;
  bool _deleting = false;

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

  Widget get popupMenuButton {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(
          onTap: _deleteConfirmation,
          child: const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            dense: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Loading Home Screen!');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords'),
        actions: anySelected ? [popupMenuButton] : [],
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
    );
  }
}
