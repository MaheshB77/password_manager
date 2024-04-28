import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List<Password> pwds = [];
  final FocusNode _focusNode = FocusNode();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    pwds = widget.passwords;
    _focusNode.addListener(() {
      setState(() {
        _searching = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

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

  void _filter(String search) {
    setState(() {
      pwds = widget.passwords
          .where(
              (pwd) => pwd.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  Future<void> _getPasswords() async {
    await ref.read(passwordProvider.notifier).getPasswords();
  }

  @override
  Widget build(BuildContext context) {
    if (!_searching) {
      pwds = widget.passwords;
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TextField(
            focusNode: _focusNode,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            onChanged: (value) {
              _filter(value);
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _getPasswords,
            child: ListView.builder(
              itemCount: pwds.length,
              itemBuilder: (ctx, index) => SizedBox(
                height: 70,
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
                    pwds[index].username.isNotEmpty
                        ? pwds[index].username
                        : 'NA',
                  ),
                  onTap: () {
                    _showPassword(context, pwds[index], ref);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
