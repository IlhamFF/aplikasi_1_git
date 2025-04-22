import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const StatusBadge({
    Key? key,
    required this.label,
    required this.color,
    this.fontSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
