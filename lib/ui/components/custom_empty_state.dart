import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import 'custom_button.dart';

class CustomEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double iconSize;
  final Color? iconColor;
  final Widget? customAction;
  final bool showIllustration;
  final String? illustrationAsset;

  const CustomEmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 64,
    this.iconColor,
    this.customAction,
    this.showIllustration = false,
    this.illustrationAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIllustration && illustrationAsset != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Image.asset(illustrationAsset!, height: 150),
              )
            else
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? AppStyles.textSecondary.withOpacity(0.5),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyles.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: AppStyles.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (customAction != null)
              customAction!
            else if (buttonText != null && onButtonPressed != null)
              CustomButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                icon: Icons.refresh,
                gradient: AppStyles.primaryGradient,
              ),
          ],
        ),
      ),
    );
  }

  // Helper method for creating a "no data" empty state
  static Widget noData({
    String title = 'Tidak Ada Data',
    String message = 'Belum ada data yang tersedia saat ini.',
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData icon = Icons.inbox,
    bool showIllustration = true,
    String? illustrationAsset,
  }) {
    return CustomEmptyState(
      icon: icon,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      showIllustration: showIllustration,
      illustrationAsset: illustrationAsset ?? 'assets/images/no_data.png',
    );
  }

  // Helper method for creating a "search not found" empty state
  static Widget searchNotFound({
    String title = 'Pencarian Tidak Ditemukan',
    String message = 'Tidak ada hasil yang cocok dengan pencarian Anda.',
    String? buttonText = 'Reset Pencarian',
    VoidCallback? onButtonPressed,
    bool showIllustration = true,
    String? illustrationAsset,
  }) {
    return CustomEmptyState(
      icon: Icons.search_off,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      showIllustration: showIllustration,
      illustrationAsset:
          illustrationAsset ?? 'assets/images/search_not_found.png',
    );
  }

  // Helper method for creating an "error" empty state
  static Widget error({
    String title = 'Terjadi Kesalahan',
    String message = 'Gagal memuat data. Silakan coba lagi nanti.',
    String? buttonText = 'Coba Lagi',
    VoidCallback? onButtonPressed,
    bool showIllustration = true,
    String? illustrationAsset,
  }) {
    return CustomEmptyState(
      icon: Icons.error_outline,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      iconColor: AppStyles.statusError,
      showIllustration: showIllustration,
      illustrationAsset: illustrationAsset ?? 'assets/images/error.png',
    );
  }

  // Helper method for creating a "coming soon" empty state
  static Widget comingSoon({
    String title = 'Segera Hadir',
    String message =
        'Fitur ini sedang dalam pengembangan dan akan segera tersedia.',
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool showIllustration = true,
    String? illustrationAsset,
  }) {
    return CustomEmptyState(
      icon: Icons.rocket_launch,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      iconColor: AppStyles.accentColor,
      showIllustration: showIllustration,
      illustrationAsset: illustrationAsset ?? 'assets/images/coming_soon.png',
    );
  }
}
