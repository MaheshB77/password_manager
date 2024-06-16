import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password/password_provider.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_avatar.dart';

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

  Future<void> _toggleFavorite(WidgetRef ref) async {
    password.isFavorite = password.isFavorite == 1 ? 0 : 1;
    await ref.read(passwordProvider.notifier).update(password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        trailing: IconButton(
          icon: password.isFavorite == 0
              ? const Icon(Icons.star_border)
              : const Icon(Icons.star),
          onPressed: () async {
            await _toggleFavorite(ref);
          },
        ),
        titleAlignment: ListTileTitleAlignment.center,
        onTap: () => onTap(password.id!, index),
        onLongPress: () => onLongPress(password.id!),
        selected: password.selected,
        selectedTileColor: Theme.of(context).colorScheme.outlineVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
