import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/screens/password_screen.dart';

class PasswordList extends ConsumerWidget {
  final List<Password> passwords;
  const PasswordList({super.key, required this.passwords});

  void _showPassword(BuildContext context, Password password) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PasswordScreen(password: password),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: passwords.length,
      itemBuilder: (ctx, index) => Container(
        height: 70,
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
            _showPassword(context, passwords[index]);
          },
        ),
      ),
    );
  }
}
