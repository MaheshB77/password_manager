import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PMTextField extends ConsumerWidget {
  final String? initialValue;
  final String labelText;
  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;
  const PMTextField({
    super.key,
    required this.initialValue,
    required this.labelText,
    required this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      maxLength: 50,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(12),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
