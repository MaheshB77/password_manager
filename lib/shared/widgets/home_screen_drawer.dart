import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/screens/home_screen/home_screen.dart';
import 'package:password_manager/screens/import_export_screen/import_export_screen.dart';
import 'package:password_manager/screens/settings_screen/settings_screen.dart';

class HomeScreenDrawer extends ConsumerWidget {
  const HomeScreenDrawer({super.key});

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const SettingsScreen(),
      ),
    );
  }

  void _openImportExport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const ImportExportScreen(),
      ),
    );
  }

  void _openHomeScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const HomeScreen()),
      (route) => false,
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
        child: ListView(
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
              onTap: () => _openHomeScreen(context),
            ),
            ListTile(
              leading: Icon(
                Icons.import_export_outlined,
                size: 22,
                color: colorScheme.onBackground,
              ),
              title: Text(
                'Import / Export',
                style: itemTextStyle,
              ),
              onTap: () => _openImportExport(context),
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
              onTap: () => _openSettings(context),
            ),
          ],
        ),
      ),
    );
  }
}
