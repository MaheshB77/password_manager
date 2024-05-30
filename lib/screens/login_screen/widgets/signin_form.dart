import 'package:flutter/material.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/screens/login_screen/widgets/button.dart';
import 'package:password_manager/screens/login_screen/widgets/password_field.dart';
import 'package:password_manager/services/user_service.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String? errorText;
  final _pwdController = TextEditingController();

  void _login() async {
    final us = UserService();
    final valid = await us.validate(_pwdController.text);
    if (valid) {
      setState(() {
        errorText = null;
      });
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() {
        errorText = 'Please enter the valid password';
      });
    }
  }

  @override
  void dispose() {
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Logo
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
          const SizedBox(height: 30),
          PasswordField(
            controller: _pwdController,
            errorText: errorText,
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
