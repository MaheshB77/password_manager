import 'package:flutter/material.dart';
import 'package:password_manager/screens/login_screen/widgets/signin_form.dart';
import 'package:password_manager/screens/login_screen/widgets/signup_form.dart';
import 'package:password_manager/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<bool> _isUserCreated;
  @override
  void initState() {
    super.initState();
    _isUserCreated = UserService().isCreated();
  }

  @override
  Widget build(BuildContext context) {
    print('Loading Logging Screen!!');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
