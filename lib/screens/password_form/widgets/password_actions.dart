import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password/password_provider.dart';
import 'package:password_manager/screens/home_screen/home_screen.dart';

class PasswordAction extends ConsumerStatefulWidget {
  final Password password;
  const PasswordAction({super.key, required this.password});

  @override
  ConsumerState<PasswordAction> createState() => _PasswordActionState();
}

class _PasswordActionState extends ConsumerState<PasswordAction> {
  void _onDelete(String id) async {
    await ref.read(passwordProvider.notifier).delete(id);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const HomeScreen()),
      (route) => false,
    );
  }

  void _deleteConfirmation(String id) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Deleting'),
          content: const Text('Do you want to delete this password ?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _onDelete(id),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(
          height: 16,
          child: const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
          onTap: () => {
            _deleteConfirmation(widget.password.id!),
          },
        ),
      ],
    );
  }
}
