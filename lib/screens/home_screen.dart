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
  late Future<void> _passwordFuture;

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
  }

  @override
  Widget build(BuildContext context) {
    final pwds = ref.watch(passwordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords'),
      ),
      drawer: const HomeScreenDrawer(),
      body: FutureBuilder(
        future: _passwordFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          } else {
            return PasswordList(passwords: pwds);
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
