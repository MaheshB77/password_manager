import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final TextEditingController? controller;
  final void Function(String? value) onSaved;
  final String? Function(String? value)? validator;

  const PasswordField({
    super.key,
    required this.hintText,
    required this.onSaved,
    this.validator,
    this.controller,
    this.errorText,
  });

  @override
  State<StatefulWidget> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  void _toggleVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          hintText: widget.hintText,
          errorText: widget.errorText,
          border: const OutlineInputBorder(),
          // hintStyle: TextStyle(
          //   color:
          //       Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
          // ),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              semanticLabel:
                  _passwordVisible ? 'Hide password' : 'Show password',
            ),
            onPressed: _toggleVisibility,
          ),
        ),
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
