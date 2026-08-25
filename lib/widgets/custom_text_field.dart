import 'package:flutter/material.dart';

/// A consistently styled TextFormField wrapper that respects the app's
/// InputDecorationTheme while exposing the most common configuration options.
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final int? maxLength;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      autofocus: autofocus,
      maxLength: maxLength,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        // Hide the built-in character counter so callers control their own UI.
        counterText: '',
      ),
    );
  }
}
