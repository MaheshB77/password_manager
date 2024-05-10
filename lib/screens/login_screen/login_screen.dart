import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/screens/home_screen/home_screen.dart';
import 'package:password_manager/services/supabase_auth_service.dart';

class LoginScreen extends ConsumerWidget {
  final SupabaseAuthService auth = SupabaseAuthService();
  LoginScreen({super.key});

  void _loginWithGoogle(BuildContext context) async {
    try {
      await auth.signInWithGoogle();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (error) {
      print('Error while logging in $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Loading Logging Screen!!');

    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _loginWithGoogle(context);
                },
                icon: const Icon(Icons.login),
                label: const Text('Login with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
