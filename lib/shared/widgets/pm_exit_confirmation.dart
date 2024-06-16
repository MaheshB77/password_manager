import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PMExitConfirmation extends StatelessWidget {
  final Widget child;
  const PMExitConfirmation({super.key, required this.child});

  Future<bool?> showExitConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final bool? shouldPop = await showExitConfirmation(context);
        if (shouldPop != null && shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
