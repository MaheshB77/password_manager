import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final void Function(String? value) onSaved;
  final String? Function(String? value) validator;

  const PasswordField({
    super.key,
    required this.hintText,
    required this.onSaved,
    required this.validator,
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
        obscureText: _passwordVisible,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            // color: Colors.grey,
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple.shade400),
          ),
          fillColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
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
