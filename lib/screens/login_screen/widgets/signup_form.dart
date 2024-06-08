import 'package:flutter/material.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/screens/login_screen/widgets/button.dart';
import 'package:password_manager/screens/login_screen/widgets/password_field.dart';
import 'package:password_manager/services/user_service.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';

  void _createUser() async {
    final us = UserService();
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      try {
        print('Creating the user with password : $_password !');
        // TODO: Spinner to be added
        await us.create(
          User(
            masterPassword: _password,
            fingerprint: 0,
            theme: 'system',
          ),
        );
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) => const HomeScreen(),
          ),
          (route) => false,
        );
      } catch (error) {
        print('Error while creating the user :: $error');
      }
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty || value.length < 5) {
      return 'Password should have at-least 5 characters';
    }
    if (value.contains(' ')) {
      return 'Password can not have spaces';
    }
    return null;
  }

  String? _confirmValidator(String? confirmPwd) {
    return confirmPwd != _password ? 'Both passwords should be same' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 30),

              // Info text
              Text(
                'Create your master password',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 30),

              // Master Password field
              PasswordField(
                hintText: 'Password',
                validator: _validator,
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 10),
              PasswordField(
                hintText: 'Confirm Password',
                validator: _confirmValidator,
                onSaved: (value) {},
              ),
              const SizedBox(height: 20),

              // Button
              Button(
                btnText: 'Create',
                onTap: _createUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
