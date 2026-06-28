import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText,
    this.maxLines,
  });

  final String hint;
  final TextEditingController? controller;
  final bool? obscureText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
