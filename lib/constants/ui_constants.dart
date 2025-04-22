import 'package:flutter/material.dart';

/// Konstanta untuk UI aplikasi
/// Berisi nilai-nilai yang digunakan di seluruh aplikasi untuk konsistensi UI
class UIConstants {
  // Spacing
  static const double spacingXXS = 2.0;
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 100.0;

  // Icon sizes
  static const double iconSizeXS = 12.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  static const double iconSizeXXL = 64.0;

  // Font sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeHeadingS = 24.0;
  static const double fontSizeHeadingM = 28.0;
  static const double fontSizeHeadingL = 32.0;

  // Card dimensions
  static const double cardElevation = 4.0;
  static const double cardBorderRadius = 16.0;
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);

  // Button dimensions
  static const double buttonHeight = 48.0;
  static const double buttonBorderRadius = 8.0;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Input field dimensions
  static const double inputFieldHeight = 56.0;
  static const double inputFieldBorderRadius = 8.0;
  static const EdgeInsets inputFieldPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 16.0,
  );

  // Avatar sizes
  static const double avatarSizeXS = 24.0;
  static const double avatarSizeS = 32.0;
  static const double avatarSizeM = 40.0;
  static const double avatarSizeL = 56.0;
  static const double avatarSizeXL = 80.0;
  static const double avatarSizeXXL = 120.0;

  // Sidebar dimensions
  static const double sidebarWidth = 250.0;
  static const double sidebarCollapsedWidth = 70.0;

  // App bar dimensions
  static const double appBarHeight = 60.0;

  // Animation durations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Shadows
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 5,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get heavyShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  // Responsive breakpoints
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;
  static const double breakpointLargeDesktop = 1800;

  // Helper method to get responsive value based on screen width
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width >= breakpointLargeDesktop && largeDesktop != null) {
      return largeDesktop;
    }

    if (width >= breakpointDesktop && desktop != null) {
      return desktop;
    }

    if (width >= breakpointTablet && tablet != null) {
      return tablet;
    }

    return mobile;
  }

  // Helper method to check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointTablet;
  }

  // Helper method to check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointTablet && width < breakpointDesktop;
  }

  // Helper method to check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }
}
