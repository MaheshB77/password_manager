import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/screens/settings_screen/settings_screen.dart';

class HomeScreenDrawer extends ConsumerWidget {
  HomeScreenDrawer({super.key});

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemTextStyle = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(color: colorScheme.onBackground, fontSize: 18);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.password,
                size: 22,
                color: colorScheme.onBackground,
              ),
              title: Text(
                'Passwords',
                style: itemTextStyle,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 22,
                color: colorScheme.onBackground,
              ),
              title: Text(
                'Settings',
                style: itemTextStyle,
              ),
              onTap: () => {_openSettings(context)},
            ),
          ],
        ),
      ),
    );
  }
}
