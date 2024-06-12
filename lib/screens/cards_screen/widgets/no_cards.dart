import 'package:flutter/material.dart';
import 'package:password_manager/shared/utils/theme_util.dart';

class NoCards extends StatelessWidget {
  const NoCards({super.key});

  @override
  Widget build(BuildContext context) {
    final img =
        'assets/images/no_cards_${ThemeUtil.isDark(context) ? 'dark' : 'light'}.png';
    return Center(
      child: Column(
        children: [
          Image.asset(
            img,
            height: 400,
            width: 300,
          ),
          Text(
            'No cards added yet!',
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
