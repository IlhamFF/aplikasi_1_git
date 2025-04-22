import 'package:flutter/material.dart';
import '../styles/app_styles.dart';

class AppTheme {
  static bool isDarkMode = true;

  static void toggleTheme() {
    isDarkMode = !isDarkMode;
    // Notify listeners if using a state management solution
  }

  static ThemeData getTheme() {
    return isDarkMode ? _darkTheme : _lightTheme;
  }

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppStyles.primaryColor,
    scaffoldBackgroundColor: AppStyles.bgDark,
    cardColor: AppStyles.bgCard,
    appBarTheme: AppBarTheme(
      backgroundColor: AppStyles.bgDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppStyles.textPrimary),
      titleTextStyle: TextStyle(
        color: AppStyles.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppStyles.textPrimary),
      bodyMedium: TextStyle(color: AppStyles.textPrimary),
      titleLarge: TextStyle(color: AppStyles.textPrimary),
    ),
    iconTheme: IconThemeData(color: AppStyles.textPrimary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppStyles.primaryColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppStyles.bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppStyles.primaryColor,
    scaffoldBackgroundColor: AppStyles.bgLight,
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppStyles.primaryColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
