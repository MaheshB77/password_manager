import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/providers/user/user_provider.dart';
import 'package:password_manager/screens/login_screen/widgets/signin_form.dart';
import 'package:password_manager/screens/login_screen/widgets/signup_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late Future<bool> _isUserCreated;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Loading Logging Screen!!');
    _isUserCreated = ref.watch(userRepoProvider.notifier).isCreated();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        child: FutureBuilder(
          future: _isUserCreated,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error : ${snapshot.error}'));
            } else {
              if (snapshot.data!) {
                return const SignInForm();
              }
              return const SignUpForm();
            }
          },
        ),
      ),
    );
  }
}