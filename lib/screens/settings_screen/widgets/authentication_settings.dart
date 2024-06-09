import 'package:flutter/material.dart';

class AuthenticationSettings extends StatelessWidget {
  final bool fingerprintLock;
  final void Function(bool) updateFingerprintChoice;
  const AuthenticationSettings({
    super.key,
    required this.fingerprintLock,
    required this.updateFingerprintChoice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: const Text('Authentication'),
        shape: const Border(),
        children: [
          SwitchListTile(
            title: const Text('Fingerprint lock'),
            value: fingerprintLock,
            onChanged: updateFingerprintChoice,
            secondary: const Icon(Icons.fingerprint),
          ),
        ],
      ),
    );
  }
}
