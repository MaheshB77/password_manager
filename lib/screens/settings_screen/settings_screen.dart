import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/screens/settings_screen/widgets/security_settings.dart';
import 'package:password_manager/screens/settings_screen/widgets/theme_settings.dart';
import 'package:password_manager/shared/utils/theme_util.dart';
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
  }

  void _setTheme(User user, ThemeMode? theme) {
    if (theme == null) return;
    user.theme = theme.shortStr();
    ref.read(userRepoProvider.notifier).updateUser(user);
  }

  void _updateFingerprintChoice(User user, bool enable) async {
    user.fingerprint = enable ? 1 : 0;
    await ref.read(userRepoProvider.notifier).updateUser(user);
    setState(() => _fingerprintLock = enable);
  }

  void _setInitials(User user) {
    setState(() {
      _fingerprintLock = user.fingerprint == 1;
      _theme = ThemeMode.values.byName(user.theme);
    });
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
            _setInitials(user);
            return Column(
              children: [
                ThemeSettings(
                  theme: _theme,
                  setTheme: (theme) {
                    _setTheme(user, theme);
                  },
                ),
                SecuritySettings(
                  fingerprintLock: _fingerprintLock,
                  updateFingerprintChoice: (enabled) {
                    _updateFingerprintChoice(user, enabled);
                  },
                ),
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
