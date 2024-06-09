import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/shared/widgets/pm_password_field.dart';

class PasswordChange extends ConsumerStatefulWidget {
  const PasswordChange({super.key});

  @override
  ConsumerState<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends ConsumerState<PasswordChange> {
  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';

  String? _validateOldPassword(User user, String value) {
    if (user.masterPassword != value) {
      return 'Please enter correct password!';
    }
    return null;
  }

  String? _newPasswordValidator(String? value) {
    if (value == null || value.isEmpty || value.length < 5) {
      return 'Password should have at-least 5 characters';
    }
    if (value.contains(' ')) {
      return 'Password can not have spaces';
    }
    return null;
  }

  String? _confirmValidator(String? confirmPwd) {
    return confirmPwd != _newPassword ? 'Both passwords should be same' : null;
  }

  void _updatePassword(User user) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      user.masterPassword = _newPassword;
      await ref.read(userRepoProvider.notifier).updateUser(user);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _changePasswordPopup(User user, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change password'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  PMPasswordField(
                    initialValue: '',
                    labelText: 'Old Password',
                    validator: (value) {
                      return _validateOldPassword(user, value!);
                    },
                    onSaved: (value) {},
                  ),
                  const SizedBox(height: 8),
                  PMPasswordField(
                    initialValue: '',
                    labelText: 'New Password',
                    validator: _newPasswordValidator,
                    onSaved: (value) {
                      _newPassword = value!;
                    },
                  ),
                  const SizedBox(height: 8),
                  PMPasswordField(
                    initialValue: '',
                    labelText: 'Confirm New Password',
                    validator: _confirmValidator,
                    onSaved: (value) {},
                  ),
                ],
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
          leading: const Icon(Icons.key),
          title: const Text('Change master password'),
          onTap: () {
            _changePasswordPopup(user, context);
          },
        );
      },
      error: (error, stackTrace) => Container(),
      loading: () => Container(),
    );
  }
}
