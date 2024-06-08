import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/providers/theme_provider.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  ThemeMode _theme = ThemeMode.system;
  bool _fingerprintLock = false;

  @override
  void initState() {
    super.initState();
    _theme = ref.read(themeProvider);
  }

  void _setTheme(ThemeMode? theme) {
    ref.read(themeProvider.notifier).setTheme(theme!);
    setState(() {
      _theme = theme;
    });
  }

  void _updateFingerprintChoice(User user, bool enable) async {
    user.fingerprint = enable ? 1 : 0;
    await ref.read(userRepoProvider.notifier).updateUser(user);
    setState(() => _fingerprintLock = enable);
  }

  @override
  Widget build(BuildContext context) {
    final userFuture = ref.watch(userRepoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: userFuture.when(
          data: (user) {
            setState(() => _fingerprintLock = user.fingerprint == 1);
            return Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    title: const Text('Theme'),
                    shape: const Border(),
                    children: [
                      RadioListTile<ThemeMode>(
                        title: const Text('Light'),
                        value: ThemeMode.light,
                        groupValue: _theme,
                        onChanged: (value) => {_setTheme(value)},
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Dark'),
                        value: ThemeMode.dark,
                        groupValue: _theme,
                        onChanged: (value) => {_setTheme(value)},
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('System'),
                        value: ThemeMode.system,
                        groupValue: _theme,
                        onChanged: (value) => {_setTheme(value)},
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    title: const Text('Authentication'),
                    shape: const Border(),
                    children: [
                      SwitchListTile(
                        title: const Text('Fingerprint lock'),
                        value: _fingerprintLock,
                        onChanged: (enable) {
                          _updateFingerprintChoice(user, enable);
                        },
                        secondary: const Icon(Icons.fingerprint),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
          error: (error, stackTrace) {
            return const Center(child: Text('Something went wrong'));
          },
          loading: () {
            return const Center(child: Spinner());
          },
        ),
      ),
    );
  }
}
