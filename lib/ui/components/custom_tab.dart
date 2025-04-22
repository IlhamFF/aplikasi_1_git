import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double height;
  final double borderRadius;

  const CustomTab({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.height = 40,
    this.borderRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppStyles.primaryColor;
    final effectiveUnselectedColor = unselectedColor ?? Colors.transparent;
    final effectiveSelectedTextColor = selectedTextColor ?? Colors.white;
    final effectiveUnselectedTextColor =
        unselectedTextColor ?? AppStyles.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? effectiveSelectedColor : effectiveUnselectedColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color:
                      isSelected
                          ? effectiveSelectedTextColor
                          : effectiveUnselectedTextColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color:
                      isSelected
                          ? effectiveSelectedTextColor
                          : effectiveUnselectedTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<IconData>? icons;
  final Color? backgroundColor;
  final Color? selectedTabColor;
  final Color? unselectedTabColor;
  final double height;
  final double spacing;
  final EdgeInsetsGeometry padding;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.icons,
    this.backgroundColor,
    this.selectedTabColor,
    this.unselectedTabColor,
    this.height = 48,
    this.spacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppStyles.bgCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < tabs.length - 1 ? spacing : 0,
            ),
            child: CustomTab(
              text: tabs[index],
              icon:
                  icons != null && index < icons!.length ? icons![index] : null,
              isSelected: selectedIndex == index,
              onTap: () => onTabSelected(index),
              selectedColor: selectedTabColor,
              unselectedColor: unselectedTabColor,
            ),
          );
        }),
      ),
    );
  }
}
