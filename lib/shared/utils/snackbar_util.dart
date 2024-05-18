import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showError(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMsg),
        duration: const Duration(seconds: 5),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () => ScaffoldMessenger.of(context).clearSnackBars(),
        ),
      ),
    );
  }
}
