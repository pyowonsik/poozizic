import 'package:flutter/material.dart';

/// Poozizic 공통 텍스트 입력 필드
class PzTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool filled;
  final InputDecoration? decoration;

  const PzTextFormField({
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.filled = false,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      decoration: decoration ??
          InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            filled: filled,
            fillColor: filled ? Colors.grey[100] : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            contentPadding: filled
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
    );
  }
}
