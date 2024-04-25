import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/providers/auth_provider.dart';
import 'package:password_manager/screens/login_screen.dart';

class HomeScreenDrawer extends ConsumerWidget {
  const HomeScreenDrawer({super.key});

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
              ref.read(authProvider.notifier).signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
