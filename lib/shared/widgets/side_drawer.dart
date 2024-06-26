import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/screens/cards_screen/cards_screen.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/screens/import_export_screen/import_export_screen.dart';
import 'package:password_manager/screens/settings_screen/settings_screen.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  void _openPasswordsScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const PasswordsScreen()),
      (route) => false,
    );
  }

  void _openCardsScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CardsScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _openImportExport(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const ImportExportScreen(),
      ),
    );
  }

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
              onTap: () => _openPasswordsScreen(context),
            ),
            ListTile(
              leading: const ImageIcon(
                AssetImage('assets/ext_icons/card.png'),
              ),
              title: Text(
                'Cards',
                style: itemTextStyle,
              ),
              onTap: () => _openCardsScreen(context),
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
              onTap: () async {
                await _openImportExport(context);
              },
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
