import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/constants/icons.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/models/pm_icon.dart';
import 'package:password_manager/providers/category/category_provider.dart';
import 'package:password_manager/providers/password/password_provider.dart';
import 'package:password_manager/screens/password_form/widgets/icon_selector.dart';
import 'package:password_manager/screens/password_form/widgets/password_actions.dart';
import 'package:password_manager/shared/widgets/pm_dropdown_menu.dart';
import 'package:password_manager/shared/widgets/pm_password_field.dart';
import 'package:password_manager/shared/widgets/pm_text_field.dart';
import 'package:password_manager/shared/utils/category_util.dart';
import 'package:password_manager/shared/utils/icon_util.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class PasswordFormScreen extends ConsumerStatefulWidget {
  final Password password;
  const PasswordFormScreen({super.key, required this.password});

  @override
  ConsumerState<PasswordFormScreen> createState() => _PasswordFormScreenState();
}

class _PasswordFormScreenState extends ConsumerState<PasswordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _username = '';
  String _email = '';
  String _password = '';
  bool _sending = false;
  bool _new = false;
  late Category _category;
  late List<Category> _categories;
  PMIcon? _icon;

  @override
  void initState() {
    super.initState();
    _categories = ref.read(categoryProvider);
    _title = widget.password.title;
    _username = widget.password.username;
    _email = widget.password.email ?? '';
    _password = widget.password.password;
    _category = widget.password.categoryId.isEmpty
        ? CategoryUtil.getByName(_categories, 'Other') // Default
        : CategoryUtil.getById(_categories, widget.password.categoryId);

    if (widget.password.iconId != null && widget.password.iconId!.isNotEmpty) {
      _icon = IconUtil.getById(pmIcons, widget.password.iconId!);
    }

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
        categoryId: _category.id,
        iconId: _icon?.id,
      );
      try {
        if (_new) {
          await ref.read(passwordProvider.notifier).save(pwd);
        } else {
          pwd.id = widget.password.id;
          await ref.read(passwordProvider.notifier).update(pwd);
        }
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        String errorMsg = 'Something went wrong!';
        SnackBarUtil.showError(context, errorMsg);
      }
      _toggleSending();
    }
  }

  void _toggleSending() {
    setState(() => _sending = !_sending);
  }

  void _showIconSelector() {
    showDialog(
      context: context,
      builder: (ctx) => IconSelector(
        onSelectedIcon: _onSelectedIcon,
      ),
    );
  }

  void _onSelectedIcon(PMIcon selectedIcon) {
    setState(() => _icon = selectedIcon);
  }

  Widget get selectedIcon {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(
        Radius.circular(50),
      ),
      child: SizedBox(
        width: 75,
        height: 75,
        child: IconButton(
          onPressed: _showIconSelector,
          icon: _icon == null
              ? const Icon(Icons.add_circle_outline_rounded, size: 40)
              : Image.asset(_icon!.url, width: 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Rendering password screen');
    return Scaffold(
      appBar: AppBar(
        title: Text(_new ? 'New password' : 'Update password'),
        actions: _new ? [] : [PasswordAction(password: widget.password)],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                selectedIcon,
                _icon == null
                    ? Container(
                        padding: const EdgeInsets.only(top: 8),
                        child: const Text('Add icon'),
                      )
                    : Container(),
                const SizedBox(height: 18),
                PMDropdownMenu(
                  fieldKey: AppKeys.categoryDropdownKey,
                  label: 'Category',
                  entries: _categories,
                  initialSelection: _category,
                  onEntrySelection: (ctgry) => _category = ctgry!,
                ),
                const SizedBox(height: 18),
                PMTextField(
                  fieldKey: AppKeys.titleKey,
                  initialValue: _title,
                  labelText: 'Title',
                  validator: (value) => _fieldValidator(value, 1, 50, 'Title'),
                  onSaved: (value) => {_title = value!},
                ),
                const SizedBox(height: 14),
                PMTextField(
                  fieldKey: AppKeys.usernameKey,
                  initialValue: _username,
                  labelText: 'Username',
                  validator: (value) =>
                      _fieldValidator(value, 2, 50, 'Username'),
                  onSaved: (value) => {_username = value!},
                ),
                const SizedBox(height: 14),
                PMTextField(
                  fieldKey: AppKeys.emailKey,
                  initialValue: _email,
                  labelText: 'Email (optional)',
                  validator: (value) => _emailValidator(value),
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 14),
                PMPasswordField(
                  fieldKey: AppKeys.passwordKey,
                  initialValue: _password,
                  validator: (value) =>
                      _fieldValidator(value, 5, 50, 'Password'),
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    key: AppKeys.addButton,
                    onPressed: _sending ? null : _onAdd,
                    child: _sending
                        ? const Spinner()
                        : Text(_new ? 'Add' : 'Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
