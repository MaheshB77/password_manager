import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_provider.dart';
import 'package:password_manager/screens/password_screen.dart';
import 'package:password_manager/widgets/home_screen_drawer.dart';
import 'package:password_manager/widgets/password_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getPasswords(ref);
  }

  void _getPasswords(WidgetRef ref) async {
    ref.read(passwordProvider.notifier).getPasswords();
  }

  void _onAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PasswordScreen(
          password: Password(title: '', username: '', password: ''),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No passwords stored yet!'),
    );

    final pwds = ref.watch(passwordProvider);

    if (pwds.isNotEmpty) {
      content = PasswordList(passwords: pwds);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords'),
      ),
      drawer: const HomeScreenDrawer(),
      body: content,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onAdd,
      ),
    );
  }
}
