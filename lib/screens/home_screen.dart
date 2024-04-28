import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_provider.dart';
import 'package:password_manager/providers/password_select_provider.dart';
import 'package:password_manager/screens/password_screen.dart';
import 'package:password_manager/widgets/home_screen_drawer.dart';
import 'package:password_manager/widgets/password_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _passwordFuture;
  bool _selecting = false;

  @override
  void initState() {
    super.initState();
    _passwordFuture = ref.read(passwordProvider.notifier).getPasswords();
  }

  void _onAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PasswordScreen(
          password: Password(title: '', username: '', password: ''),
        ),
      ),
    );
    _setSelecting(false);
    await ref.read(passwordProvider.notifier).getPasswords();
  }

  void _setSelecting(bool selecting) {
    setState(() {
      _selecting = selecting;
    });
  }

  void _deleteSelected() async {
    final selectedPwds = ref.watch(passwordSelectProvider);
    List<String> ids = selectedPwds
        .where((pwd) => pwd.selected)
        .map((pwd) => pwd.id!)
        .toList();
    await ref.read(passwordProvider.notifier).deleteMultiple(ids);
  }

  @override
  Widget build(BuildContext context) {
    print('Loading Home Screen!');
    final pwds = ref.watch(passwordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: _selecting
            ? [
                PopupMenuButton(
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      onTap: _deleteSelected,
                      child: const ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ]
            : [],
      ),
      drawer: HomeScreenDrawer(),
      body: FutureBuilder(
        future: _passwordFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          } else {
            return PasswordList(passwords: pwds, onSelecting: _setSelecting);
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
