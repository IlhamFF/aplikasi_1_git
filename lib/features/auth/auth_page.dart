import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../ui/components/custom_card.dart';
import '../../ui/components/custom_button.dart';
import '../../ui/styles/app_styles.dart';
import '../../ui/theme/app_theme.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.backgroundGradient),
        child: Center(
          child: CustomCard(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo aplikasi
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppStyles.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school,
                    size: 48,
                    color: AppStyles.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Selamat Datang di Akademik App",
                  style: AppStyles.headingMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Silakan masuk atau daftar untuk melanjutkan",
                  style: AppStyles.captionText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: "Masuk",
                  icon: Icons.login,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  width: 250,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Daftar",
                  icon: Icons.person_add,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  width: 250,
                  gradient: AppStyles.accentGradient,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "v1.0.0",
                      style: AppStyles.captionText.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
