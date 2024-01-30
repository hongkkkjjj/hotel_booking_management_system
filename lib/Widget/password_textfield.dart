import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator? validator;
  final AutovalidateMode? autoValidateMode;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.autoValidateMode,
  });

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      obscureText: obscureText,
    );
  }
}
