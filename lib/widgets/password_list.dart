import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/screens/password_screen.dart';

class PasswordList extends ConsumerStatefulWidget {
  final List<Password> passwords;
  const PasswordList({super.key, required this.passwords});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordListState();
}

class _PasswordListState extends ConsumerState<PasswordList> {
  List<Password> pwds = [];

  @override
  void initState() {
    super.initState();
    pwds = widget.passwords;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TextField(
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
                  pwds[index].username.isNotEmpty ? pwds[index].username : 'NA',
                ),
                onTap: () {
                  _showPassword(context, pwds[index], ref);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
