import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/config/env_config.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/screens/login_screen/login_screen.dart';
import 'package:password_manager/shared/theme/dark_theme.dart';
import 'package:password_manager/shared/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await envInit();
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
    final userFuture = ref.watch(userRepoProvider);
    return MaterialApp(
      title: 'Password Manager',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      themeMode: userFuture.when(
        data: (user) => ThemeMode.values.byName(user.theme),
        error: (error, stackTrace) => ThemeMode.system,
        loading: () => ThemeMode.system,
      ),
    );
  }
}
