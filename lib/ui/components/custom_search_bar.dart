import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool showClearButton;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final double height;
  final double borderRadius;

  const CustomSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.showClearButton = true,
    this.backgroundColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.height = 48,
    this.borderRadius = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppStyles.bgCard;
    final effectiveTextColor = textColor ?? AppStyles.textPrimary;
    final effectiveHintColor = hintColor ?? AppStyles.textSecondary;
    final effectiveIconColor = iconColor ?? AppStyles.textSecondary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        style: TextStyle(color: effectiveTextColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: effectiveHintColor),
          prefixIcon: Icon(Icons.search, color: effectiveIconColor),
          suffixIcon:
              showClearButton && (controller?.text.isNotEmpty ?? false)
                  ? IconButton(
                    icon: Icon(Icons.clear, color: effectiveIconColor),
                    onPressed: () {
                      controller?.clear();
                      if (onClear != null) {
                        onClear!();
                      } else if (onChanged != null) {
                        onChanged!('');
                      }
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
