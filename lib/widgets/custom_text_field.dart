import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.hintText,
    this.onChanged,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.initialValue,
  });

  final Function(String)? onChanged;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    // Create a local controller if none is supplied and an initialValue is provided
    final TextEditingController? effectiveController = controller ?? (initialValue != null ? TextEditingController(text: initialValue) : null);

    return TextField(
      controller: effectiveController,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0), // Adjust padding as needed
          child: Icon(icon, color: Colors.white),
        )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}