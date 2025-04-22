// custom_text_field.dart
import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function()? onEditingComplete;
  final Function(String)? onSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.onSubmitted,
    this.contentPadding,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onSubmitted,
      textCapitalization: textCapitalization,
      style: TextStyle(color: AppStyles.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppStyles.textSecondary),
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: AppStyles.textSecondary)
                : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppTheme.isDarkMode ? AppStyles.bgCard : Colors.white,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppStyles.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppStyles.statusError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppStyles.statusError),
        ),
      ),
    );
  }
}
