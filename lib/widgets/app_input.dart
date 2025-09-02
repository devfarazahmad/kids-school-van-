import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;

  const AppInput({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }
}
