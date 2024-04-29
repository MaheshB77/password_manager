import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_provider.dart';
import 'package:password_manager/screens/home_screen.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  final Password password;
  const PasswordScreen({super.key, required this.password});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _username = '';
  String _email = '';
  String _password = '';
  bool _sending = false;
  bool _new = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _title = widget.password.title;
    _username = widget.password.username;
    _email = widget.password.email ?? '';
    _password = widget.password.password;
    if (widget.password.id == null) {
      _new = true;
    }
  }

  String? _fieldValidator(String? value, int min, int max, String field) {
    if (value == null ||
        value.isEmpty ||
        value.trim().length <= min ||
        value.trim().length > max) {
      return '$field should be between $min to $max characters';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!EmailValidator.validate(value)) {
      return 'Please enter valid email';
    }
    return null;
  }

  void _onAdd() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _toggleSending();
      final pwd = Password(
        title: _title,
        username: _username,
        password: _password,
        email: _email,
      );
      if (_new) {
        await ref.read(passwordProvider.notifier).save(pwd);
      } else {
        pwd.id = widget.password.id;
        await ref.read(passwordProvider.notifier).update(pwd);
      }
      _toggleSending();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _onDelete(String id) async {
    await ref.read(passwordProvider.notifier).delete(id);
    if (context.mounted) {
      // Navigator.pop(context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        (route) => false,
      );
    }
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _onDelete(id);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState!.reset();
      _title = '';
      _username = '';
      _email = '';
      _password = '';
    });
  }

  void _toggleSending() {
    setState(() {
      _sending = !_sending;
    });
  }

  Widget get spinner {
    return const SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(),
    );
  }

  Widget get popMenuButton {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_new ? 'New password' : 'Update password'),
        actions: _new ? [] : [popMenuButton],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  validator: (value) => _fieldValidator(value, 1, 50, 'Title'),
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  maxLength: 50,
                  initialValue: _username,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  validator: (value) =>
                      _fieldValidator(value, 2, 50, 'Username'),
                  onSaved: (value) {
                    _username = value!;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  maxLength: 50,
                  initialValue: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  validator: (value) => _emailValidator(value),
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  maxLength: 50,
                  initialValue: _password,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(12),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        semanticLabel: _passwordVisible
                            ? 'Hide password'
                            : 'Show password',
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible =
                              !_passwordVisible; // Toggle visibility
                        });
                      },
                    ),
                  ),
                  validator: (value) =>
                      _fieldValidator(value, 5, 50, 'Password'),
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _sending ? null : _clearForm,
                      child: const Text('Clear'),
                    ),
                    const SizedBox(width: 14),
                    ElevatedButton(
                      onPressed: _sending ? null : _onAdd,
                      child: _sending ? spinner : Text(_new ? 'Add' : 'Update'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
