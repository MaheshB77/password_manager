import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PMTextField extends ConsumerWidget {
  final String? initialValue;
  final Key? fieldKey;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final void Function(String? value) onSaved;

  const PMTextField({
    super.key,
    required this.initialValue,
    required this.labelText,
    required this.onSaved,
    this.validator,
    this.keyboardType,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      key: fieldKey,
      maxLength: 50,
      initialValue: initialValue,
      keyboardType: keyboardType,
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
