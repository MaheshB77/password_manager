import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/config/env_config.dart';
import 'package:password_manager/config/supabase_config.dart';
import 'package:password_manager/screens/home_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/services/auth_service.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    Widget mainScreen = auth.isSignedIn() ? const HomeScreen() : LoginScreen();

    return MaterialApp(
      title: 'Password Manager',
      theme: lightTheme,
      home: mainScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
