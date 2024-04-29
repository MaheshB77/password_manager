import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';

class PasswordTile extends ConsumerWidget {
  final Password password;
  final int index;
  final void Function(String id, int index) onTap;
  final void Function(String id) onLongPress;
  const PasswordTile({
    super.key,
    required this.password,
    required this.onTap,
    required this.index,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(password.title[0].toUpperCase()),
        ),
        title: Text(
          password.title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          password.username.isNotEmpty ? password.username : 'NA',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Last updated on'),
            Text(password.updatedAt!.toLocal().toString().substring(0, 19)),
          ],
        ),
        onTap: () => {onTap(password.id!, index)},
        onLongPress: () => {onLongPress(password.id!)},
        selected: password.selected,
        selectedTileColor: Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }
}
