import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PMPasswordField extends ConsumerStatefulWidget {
  final String? initialValue;
  final String? labelText;
  final Key? fieldKey;
  final int? maxLength;
  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;

  const PMPasswordField({
    super.key,
    required this.initialValue,
    required this.validator,
    required this.onSaved,
    this.labelText = 'Password',
    this.maxLength = 50,
    this.fieldKey,
  });

  @override
  ConsumerState<PMPasswordField> createState() => _PMPasswordFieldState();
}

class _PMPasswordFieldState extends ConsumerState<PMPasswordField> {
  bool _passwordVisible = false;

  void _toggleVisibility() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      maxLength: widget.maxLength,
      initialValue: widget.initialValue,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(12),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _passwordVisible ? 'Hide password' : 'Show password',
          ),
          onPressed: _toggleVisibility,
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
