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
          onPressed: () {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      ),
    );
  }

  static void showInfo(BuildContext context, String info) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(info),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      ),
    );
  }
}
