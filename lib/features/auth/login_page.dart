import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../ui/components/custom_button.dart';
import '../../ui/components/custom_card.dart';
import '../../ui/components/custom_text_field.dart';
import '../../ui/components/animated_card.dart';
import '../../ui/styles/app_styles.dart';
import '../../ui/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../providers/user_session_provider.dart';
import '../../utils/validators.dart';
import '../../constants/status_constants.dart';
import '../../models/user_model.dart'; // Tambahkan ini
import '../../constants/collection_constants.dart'; // Tambahkan ini

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedCard(
              child: CustomCard(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Masuk ke Akun Anda',
                        style: AppStyles.headingMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masukkan email dan password untuk melanjutkan',
                        style: AppStyles.captionText,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppStyles.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        validator: Validators.validatePassword,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Implementasi lupa password
                          },
                          child: Text(
                            'Lupa Password?',
                            style: TextStyle(color: AppStyles.accentColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppStyles.primaryColor,
                            ),
                          )
                          : CustomButton(
                            text: 'Masuk',
                            icon: Icons.login,
                            onPressed: _handleLogin,
                            width: double.infinity,
                          ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Belum punya akun?', style: AppStyles.bodyText),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.register,
                              );
                            },
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                color: AppStyles.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.auth,
                          );
                        },
                        child: Text(
                          'Kembali ke Halaman Utama',
                          style: TextStyle(color: AppStyles.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (user != null && mounted) {
          // Ambil data pengguna dari Firestore
          final userData = await _firestoreService.getUser(user.uid);

          if (userData != null && mounted) {
            // Cek status verifikasi
            if (userData['is_verified'] == true) {
              // Set user session dengan aman
              Provider.of<UserSessionProvider>(context, listen: false).setUser(
                user.uid,
                userData['nama'] ?? 'Pengguna',
                userData['id_level_user'] ?? 'S',
                userData['id_unik'] ?? '',
              );

              // Catat aktivitas login
              await _firestoreService.logActivity(
                user.uid,
                userData['id_level_user'] ?? 'S',
                'login',
                'Pengguna melakukan login',
              );

              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            } else {
              _showMessage(
                'Akun belum diverifikasi. Silakan hubungi administrator.',
                StatusConstants.warning,
              );
            }
          } else {
            _showMessage('Gagal memuat data pengguna', StatusConstants.error);
          }
        } else {
          _showMessage('Email atau password salah', StatusConstants.error);
        }
      } catch (e) {
        _showMessage(
          'Terjadi kesalahan: ${e.toString()}',
          StatusConstants.error,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showMessage(String message, String status) {
    Color backgroundColor;

    switch (status) {
      case StatusConstants.success:
        backgroundColor = AppStyles.statusSuccess;
        break;
      case StatusConstants.warning:
        backgroundColor = AppStyles.statusWarning;
        break;
      case StatusConstants.error:
        backgroundColor = AppStyles.statusError;
        break;
      default:
        backgroundColor = AppStyles.statusInfo;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
