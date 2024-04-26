import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_provider.dart';
import 'package:password_manager/screens/password_screen.dart';

class PasswordList extends ConsumerWidget {
  final List<Password> passwords;
  const PasswordList({super.key, required this.passwords});

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

  void _delete(String id, WidgetRef ref) async {
    await ref.read(passwordProvider.notifier).delete(id);
    await ref.read(passwordProvider.notifier).getPasswords();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: passwords.length,
      itemBuilder: (ctx, index) => SizedBox(
        height: 70,
        child: Dismissible(
          key: ValueKey(passwords[index].id),
          onDismissed: (direction) {
            _delete(passwords[index].id!, ref);
          },
          child: ListTile(
            leading: CircleAvatar(
              child: Text(passwords[index].title[0]),
            ),
            title: Text(
              passwords[index].title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              passwords[index].username.isNotEmpty
                  ? passwords[index].username
                  : 'NA',
            ),
            onTap: () {
              _showPassword(context, passwords[index], ref);
            },
          ),
        ),
      ),
    );
  }
}
