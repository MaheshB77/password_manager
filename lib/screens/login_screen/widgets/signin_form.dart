import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/screens/login_screen/widgets/button.dart';
import 'package:password_manager/screens/login_screen/widgets/password_field.dart';
import 'package:password_manager/services/user_service.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  String? _errorText;
  final _pwdController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();

  void _login() async {
    final us = UserService();
    final valid = await us.validate(_pwdController.text);
    if (valid) {
      setState(() => _errorText = null);
      _goToHomeScreen();
    } else {
      setState(() => _errorText = 'Please enter the valid password');
    }
  }

  void _loginWithFingerprint() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to see the passwords',
      );
      if (didAuthenticate) _goToHomeScreen();
    } catch (error) {
      print('Something went wrong while logging in with fingerprint');
    }
  }

  void _goToHomeScreen() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const HomeScreen()),
      (route) => false,
    );
  }

  Widget _getFingerprintButton(AsyncValue<User> userFuture) {
    return userFuture.when(
      data: (user) {
        if (user.fingerprint == 1) {
          return TextButton.icon(
            onPressed: () async => _loginWithFingerprint(),
            icon: const Icon(Icons.fingerprint),
            label: const Text('Use Fingerprint'),
          );
        }
        return Container();
      },
      error: (error, stackTrace) => Container(),
      loading: () => const Spinner(),
    );
  }

  @override
  void dispose() {
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userFuture = ref.watch(userRepoProvider);

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Icon(
            Icons.lock,
            size: 100,
          ),
          const SizedBox(height: 30),
          Text(
            'Enter your master password',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          _getFingerprintButton(userFuture),
          const SizedBox(height: 10),
          PasswordField(
            controller: _pwdController,
            errorText: _errorText,
            hintText: 'Master Password',
            onSaved: (value) {},
          ),
          const SizedBox(height: 20),
          Button(
            btnText: 'Login',
            onTap: _login,
          ),
        ],
      ),
    );
  }
}
