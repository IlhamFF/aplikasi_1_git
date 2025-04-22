import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../styles/app_styles.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onTitleTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.bottom,
    this.onTitleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;
    final bgColor =
        backgroundColor ?? (isDark ? AppStyles.bgDark : AppStyles.bgLight);
    final fgColor =
        foregroundColor ?? (isDark ? AppStyles.textPrimary : Colors.black87);

    return AppBar(
      title: GestureDetector(
        onTap: onTitleTap,
        child: Text(
          title,
          style: TextStyle(color: fgColor, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: bgColor,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      leading: leading,
      actions:
          actions ??
          [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: fgColor,
              ),
              tooltip: isDark ? 'Light Mode' : 'Dark Mode',
              onPressed: () {
                // Toggle theme
                AppTheme.toggleTheme();
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: fgColor),
              tooltip: 'Notifikasi',
              onPressed: () {
                // Navigate to notifications
              },
            ),
            const SizedBox(width: 8),
          ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
