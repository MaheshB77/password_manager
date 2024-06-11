import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';
import 'package:password_manager/shared/widgets/pm_text_field.dart';

class HintChange extends ConsumerStatefulWidget {
  const HintChange({super.key});

  @override
  ConsumerState<HintChange> createState() => _HintChangeState();
}

class _HintChangeState extends ConsumerState<HintChange> {
  final _formKey = GlobalKey<FormState>();
  String _newHint = '';

  String? _newHintValidator(String? value) {
    if (value == null || value.isEmpty || value.length < 2) {
      return 'Hint should have at-least 2 characters';
    }
    return null;
  }

  void _updatePassword(User user) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      user.passwordHint = _newHint;
      await ref.read(userRepoProvider.notifier).updateUser(user);
      if (!mounted) return;
      Navigator.pop(context);
      SnackBarUtil.showInfo(context, 'Updated the hint successfully!');
    }
  }

  Future<void> _changeHintPopup(User user, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change hint'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    PMTextField(
                      initialValue: user.passwordHint,
                      labelText: 'Update the hint',
                      onSaved: (value) => _newHint = value!,
                      validator: _newHintValidator,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _updatePassword(user),
              child: const Text('Update'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userFuture = ref.watch(userRepoProvider);
    return userFuture.when(
      data: (user) {
        return ListTile(
          leading: const Icon(Icons.lightbulb_outline),
          title: const Text('Change hint'),
          onTap: () {
            _changeHintPopup(user, context);
          },
        );
      },
      error: (error, stackTrace) => Container(),
      loading: () => Container(),
    );
  }
}
