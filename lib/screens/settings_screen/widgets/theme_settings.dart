import 'package:flutter/material.dart';

class ThemeSettings extends StatelessWidget {
  final ThemeMode theme;
  final void Function(ThemeMode?) setTheme;

  const ThemeSettings({
    super.key,
    required this.theme,
    required this.setTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: const Text('Theme'),
        shape: const Border(),
        initiallyExpanded: true,
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: theme,
            onChanged: setTheme,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: theme,
            onChanged: setTheme,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: theme,
            onChanged: setTheme,
          ),
        ],
      ),
    );
  }
}
