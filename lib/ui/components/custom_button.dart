import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../styles/app_styles.dart';

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonSize size;
  final bool isOutlined;
  final bool isLoading;
  final double? width;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine button size
    double height;
    double fontSize;
    EdgeInsetsGeometry buttonPadding;

    switch (size) {
      case ButtonSize.small:
        height = 36;
        fontSize = 12;
        buttonPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        break;
      case ButtonSize.large:
        height = 56;
        fontSize = 16;
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        );
        break;
      case ButtonSize.medium:
      default:
        height = 48;
        fontSize = 14;
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        );
        break;
    }

    // Use provided padding if available
    final effectivePadding = padding ?? buttonPadding;

    // Use provided border radius if available
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(UIConstants.buttonBorderRadius);

    // Determine colors
    final effectiveBackgroundColor = backgroundColor ?? AppStyles.primaryColor;
    final effectiveTextColor = textColor ?? Colors.white;

    // Build button content
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOutlined ? effectiveBackgroundColor : effectiveTextColor,
                ),
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              icon,
              size: fontSize + 4,
              color: isOutlined ? effectiveBackgroundColor : effectiveTextColor,
            ),
          ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: isOutlined ? effectiveBackgroundColor : effectiveTextColor,
          ),
        ),
      ],
    );

    // Build the button
    Widget button;

    if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: effectivePadding,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          side: BorderSide(color: effectiveBackgroundColor),
        ),
        child: buttonContent,
      );
    } else if (gradient != null) {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: effectivePadding,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: onPressed == null ? null : gradient,
            borderRadius: effectiveBorderRadius,
          ),
          child: Container(
            height: height,
            alignment: Alignment.center,
            child: buttonContent,
          ),
        ),
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: effectivePadding,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
        ),
        child: buttonContent,
      );
    }

    // Apply width constraint if specified
    if (width != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
