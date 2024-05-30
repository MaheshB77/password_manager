import 'package:flutter/material.dart';

class NoPasswords extends StatelessWidget {
  const NoPasswords({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/no_passwords.png',
            height: 400,
            width: 300,
          ),
          Text(
            'No passwords added yet!',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
