import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_provider.dart';
import 'package:password_manager/screens/password_screen.dart';

class PasswordList extends ConsumerStatefulWidget {
  final List<Password> passwords;
  const PasswordList({super.key, required this.passwords});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordListState();
}

class _PasswordListState extends ConsumerState<PasswordList> {

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
  }

  void _delete(String id) async {
    await ref.read(passwordProvider.notifier).delete(id);
  }

  @override
  Widget build(BuildContext context) {
    final pwds = widget.passwords;
    return ListView.builder(
      itemCount: pwds.length,
      itemBuilder: (ctx, index) => SizedBox(
        height: 70,
        child: Dismissible(
          key: ValueKey(pwds[index].id),
          onDismissed: (direction) {
            _delete(pwds[index].id!);
          },
          child: ListTile(
            leading: CircleAvatar(
              child: Text(pwds[index].title[0]),
            ),
            title: Text(
              pwds[index].title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              pwds[index].username.isNotEmpty ? pwds[index].username : 'NA',
            ),
            onTap: () {
              _showPassword(context, pwds[index], ref);
            },
          ),
        ),
      ),
    );
  }
}
