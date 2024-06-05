import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  ThemeMode _theme = ThemeMode.system;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ExpansionTile(
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
          )
        ],
      ),
    );
  }
}
