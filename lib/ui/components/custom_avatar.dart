import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../styles/app_styles.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final BoxBorder? border;

  const CustomAvatar({
    Key? key,
    this.imageUrl,
    required this.initials,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppStyles.primaryColor;
    final txtColor = textColor ?? Colors.white;
    final fontSize = radius * 0.7;

    return GestureDetector(
      onTap: onTap,
      child:
          imageUrl != null && imageUrl!.isNotEmpty
              ? CircleAvatar(
                radius: radius,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(imageUrl!),
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback to initials if image fails to load
                  print('Error loading avatar image: $exception');
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: border,
                  ),
                ),
              )
              : CircleAvatar(
                radius: radius,
                backgroundColor: bgColor,
                child: Text(
                  initials.toUpperCase(),
                  style: TextStyle(
                    color: txtColor,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ),
    );
  }
}
