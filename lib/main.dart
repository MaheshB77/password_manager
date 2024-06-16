import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/config/env_config.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/screens/login_screen/login_screen.dart';
import 'package:password_manager/shared/theme/dark_theme.dart';
import 'package:password_manager/shared/theme/light_theme.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await envInit();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  late AsyncValue<User> _userFuture;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _userFuture.when(
      data: (user) async {
        if (user.fingerprint == 1) {
          if (state == AppLifecycleState.detached ||
              state == AppLifecycleState.paused) {
            _locked = true;
          }
          if (state == AppLifecycleState.resumed && _locked) {
            final bool didAuthenticate = await _auth.authenticate(
              localizedReason: 'Please authenticate to see the passwords',
            );
            _locked = !didAuthenticate;
          }
        }
      },
      error: (error, stackTrace) {
        SnackBarUtil.showError(context, 'Something went wrong!');
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    _userFuture = ref.watch(userRepoProvider);
    return MaterialApp(
      title: 'Password Manager',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      themeMode: _userFuture.when(
        data: (user) => ThemeMode.values.byName(user.theme),
        error: (error, stackTrace) => ThemeMode.system,
        loading: () => ThemeMode.system,
      ),
    );
  }
}
