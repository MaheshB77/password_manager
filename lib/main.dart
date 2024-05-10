import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/config/env_config.dart';
import 'package:password_manager/config/supabase_config.dart';
import 'package:password_manager/providers/theme_provider.dart';
import 'package:password_manager/screens/home_screen/home_screen.dart';
import 'package:password_manager/screens/settings_screen/settings_screen.dart';
import 'package:password_manager/theme/dark_theme.dart';
import 'package:password_manager/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await envInit();
  await supabaseInit();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    ThemeMode themeMode = ThemeMode.system;
    if (appTheme == AppTheme.dark) {
      themeMode = ThemeMode.dark;
    } else if (appTheme == AppTheme.light) {
      themeMode = ThemeMode.light;
    }

    return MaterialApp(
      title: 'Password Manager',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
    );
  }
}
