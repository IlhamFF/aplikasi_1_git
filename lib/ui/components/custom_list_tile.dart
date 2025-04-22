import 'package:flutter/material.dart';
import '/ui/styles/app_styles.dart';

class CustomListTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    this.leadingIcon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: AppStyles.primaryColor.withOpacity(0.1),
      child: ListTile(
        leading:
            leadingIcon != null
                ? Icon(leadingIcon, color: AppStyles.primaryColor)
                : null,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(subtitle!, style: const TextStyle(fontFamily: 'Poppins'))
                : null,
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
