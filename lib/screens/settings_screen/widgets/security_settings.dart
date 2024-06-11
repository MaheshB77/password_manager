import 'package:flutter/material.dart';
import 'package:password_manager/screens/settings_screen/widgets/hint_change.dart';
import 'package:password_manager/screens/settings_screen/widgets/password_change.dart';

class SecuritySettings extends StatelessWidget {
  final bool fingerprintLock;
  final void Function(bool) updateFingerprintChoice;

  const SecuritySettings({
    super.key,
    required this.fingerprintLock,
    required this.updateFingerprintChoice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: const Text('Security'),
        shape: const Border(),
        initiallyExpanded: true,
        children: [
          SwitchListTile(
            title: const Text('Fingerprint lock'),
            value: fingerprintLock,
            onChanged: updateFingerprintChoice,
            secondary: const Icon(Icons.fingerprint),
          ),
          const PasswordChange(),
          const HintChange(),
        ],
      ),
    );
  }
}
