import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/screens/home_screen/widgets/password_avatar.dart';

class PasswordTile extends ConsumerWidget {
  final Password password;
  final Category category;
  final int index;
  final void Function(String id, int index) onTap;
  final void Function(String id) onLongPress;
  const PasswordTile({
    super.key,
    required this.password,
    required this.category,
    required this.onTap,
    required this.index,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: PasswordAvatar(password: password),
        title: Text(
          password.title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Category : ${category.name}',
          style: Theme.of(context).textTheme.labelSmall,
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