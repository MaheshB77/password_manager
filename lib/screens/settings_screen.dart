import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  AppTheme? _theme = AppTheme.system;

  void _setTheme(AppTheme? theme) {
    ref.watch(themeProvider.notifier).setTheme(theme!);
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
            children: [
              RadioListTile<AppTheme>(
                title: const Text('Light'),
                value: AppTheme.light,
                groupValue: _theme,
                onChanged: (value) => {_setTheme(value)},
              ),
              RadioListTile<AppTheme>(
                title: const Text('Dark'),
                value: AppTheme.dark,
                groupValue: _theme,
                onChanged: (value) => {_setTheme(value)},
              ),
              RadioListTile<AppTheme>(
                title: const Text('System'),
                value: AppTheme.system,
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

enum AppTheme { dark, light, system }
