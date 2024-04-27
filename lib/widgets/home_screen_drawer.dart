import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/services/auth_service.dart';

class HomeScreenDrawer extends ConsumerWidget {
  final AuthService auth = AuthService();
  HomeScreenDrawer({super.key});

  void _logout(BuildContext context) async {
    await auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (ctx) => LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemTextStyle = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(color: colorScheme.onBackground, fontSize: 24);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.primaryContainer.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Password Manager',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: colorScheme.primary),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.password,
              size: 26,
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
              size: 26,
              color: colorScheme.onBackground,
            ),
            title: Text(
              'Settings',
              style: itemTextStyle,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 26,
              color: colorScheme.onBackground,
            ),
            title: Text(
              'Logout',
              style: itemTextStyle,
            ),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
