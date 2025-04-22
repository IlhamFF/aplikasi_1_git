import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.color,
    this.gradient,
    this.borderRadius,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color ?? AppStyles.bgCard,
        gradient: gradient,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppStyles.cardRadius),
        boxShadow: boxShadow ?? AppStyles.cardShadow,
      ),
      child: ClipRRect(
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppStyles.cardRadius),
        child: Padding(padding: padding ?? AppStyles.cardPadding, child: child),
      ),
    );
  }
}
