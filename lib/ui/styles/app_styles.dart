// app_styles.dart
import 'package:flutter/material.dart';

class AppStyles {
  // Warna utama
  static const Color primaryColor = Color(0xFF6C5CE7); // Ungu kebiruan
  static const Color accentColor = Color(0xFFFD79A8); // Pink
  static const Color warningColor = Color(0xFFFEAA2B); // Oranye
  static const Color successColor = Color(0xFF00D2D3); // Cyan

  // Warna background
  static const Color bgDark = Color(0xFF1E1E2E); // Hitam keunguan
  static const Color bgCard = Color(0xFF2D2D44); // Abu-abu gelap keunguan
  static const Color bgLight = Color(0xFFF5F5F7); // Abu-abu sangat terang

  // Warna teks
  static const Color textPrimary = Color(0xFFF5F5F7); // Putih sedikit abu-abu
  static const Color textSecondary = Color(0xFFADAFC6); // Abu-abu terang

  // Warna status
  static const Color statusSuccess = Color(0xFF00D2D3); // Cyan
  static const Color statusWarning = Color(0xFFFEAA2B); // Oranye
  static const Color statusError = Color(0xFFFF6B81); // Merah muda
  static const Color statusInfo = Color(0xFF6C5CE7); // Ungu kebiruan

  // Warna peran
  static const Color roleAdmin = Color(0xFFFF6B81); // Merah muda
  static const Color roleGuru = Color(0xFF6C5CE7); // Ungu kebiruan
  static const Color roleTU = Color(0xFFFEAA2B); // Oranye
  static const Color roleKepsek = Color(0xFF00D2D3); // Cyan
  static const Color roleSiswa = Color(0xFF54A0FF); // Biru

  // Gradien
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryColor, Color(0xFF5758BB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradient => LinearGradient(
    colors: [accentColor, Color(0xFFFF9FF3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => LinearGradient(
    colors: [bgDark, Color(0xFF2C2C3E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Styling
  static const double cardRadius = 16.0;
  static const double cardElevation = 4.0;
  static const EdgeInsets cardPadding = EdgeInsets.all(20);

  // Text styles
  static TextStyle get headingLarge =>
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary);

  static TextStyle get headingMedium =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary);

  static TextStyle get bodyText => TextStyle(fontSize: 14, color: textPrimary);

  static TextStyle get captionText =>
      TextStyle(fontSize: 12, color: textSecondary);

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}
