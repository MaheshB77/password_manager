import 'package:flutter/material.dart';
import 'package:password_manager/screens/home_screen/home_screen.dart';
import 'package:password_manager/screens/login_screen/widgets/signup_form.dart';
import 'package:password_manager/services/user_service.dart';
import 'package:password_manager/widgets/spinner.dart';

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
              return const Spinner();
            } else if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            } else {
              if (snapshot.data!) {
                return const HomeScreen();
              }
              return const SignUpForm();
            }
          },
        ),
      ),
    );
  }
}
