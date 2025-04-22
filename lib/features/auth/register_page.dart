import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../ui/components/custom_button.dart';
import '../../ui/components/custom_card.dart';
import '../../ui/components/custom_text_field.dart';
import '../../ui/components/animated_card.dart';
import '../../ui/styles/app_styles.dart';
import '../../ui/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/validators.dart';
import '../../constants/role_constants.dart';
import '../../constants/status_constants.dart';
import '../../models/user_model.dart'; // Tambahkan ini
import '../../constants/collection_constants.dart'; // Tambahkan ini

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _namaController = TextEditingController();
  final _idUnikController = TextEditingController();
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = RoleConstants.siswa;

  final List<Map<String, dynamic>> _roleOptions = [
    {
      'value': RoleConstants.siswa,
      'label': 'Siswa',
      'icon': Icons.school,
      'color': AppStyles.roleSiswa,
      'prefix': 'S_',
      'hint': 'NIS (contoh: S_123456)',
    },
    {
      'value': RoleConstants.guru,
      'label': 'Guru',
      'icon': Icons.person,
      'color': AppStyles.roleGuru,
      'prefix': 'G_',
      'hint': 'NIP (contoh: G_123456)',
    },
    {
      'value': RoleConstants.tu,
      'label': 'Tata Usaha',
      'icon': Icons.business_center,
      'color': AppStyles.roleTU,
      'prefix': 'T_',
      'hint': 'ID TU (contoh: T_123456)',
    },
    {
      'value': RoleConstants.kepsek,
      'label': 'Kepala Sekolah',
      'icon': Icons.account_balance,
      'color': AppStyles.roleKepsek,
      'prefix': 'K_',
      'hint': 'ID Kepsek (contoh: K_123456)',
    },
    {
      'value': RoleConstants.admin,
      'label': 'Admin',
      'icon': Icons.admin_panel_settings,
      'color': AppStyles.roleAdmin,
      'prefix': 'A_',
      'hint': 'ID Admin (contoh: A_123456)',
    },
  ];

  Map<String, dynamic> get _selectedRoleData {
    return _roleOptions.firstWhere(
      (role) => role['value'] == _selectedRole,
      orElse: () => _roleOptions[0],
    );
  }

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
                width: 450,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Daftar Akun Baru', style: AppStyles.headingMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Silakan lengkapi data diri Anda',
                        style: AppStyles.captionText,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Role selection
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daftar sebagai:', style: AppStyles.bodyText),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    _roleOptions.map((role) {
                                      final bool isSelected =
                                          _selectedRole == role['value'];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: ChoiceChip(
                                          label: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                role['icon'],
                                                size: 16,
                                                color:
                                                    isSelected
                                                        ? Colors.white
                                                        : role['color'],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(role['label']),
                                            ],
                                          ),
                                          selected: isSelected,
                                          selectedColor: role['color'],
                                          backgroundColor: AppStyles.bgCard,
                                          labelStyle: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : AppStyles.textPrimary,
                                          ),
                                          onSelected: (selected) {
                                            if (selected) {
                                              setState(() {
                                                _selectedRole = role['value'];
                                                _idUnikController.clear();
                                              });
                                            }
                                          },
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Nama Lengkap',
                        prefixIcon: Icons.person,
                        controller: _namaController,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: _selectedRoleData['hint'],
                        prefixIcon: Icons.badge,
                        controller: _idUnikController,
                        validator:
                            (value) => Validators.validateIdUnik(
                              value,
                              _selectedRoleData['prefix'],
                            ),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Konfirmasi Password',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppStyles.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        obscureText: _obscureConfirmPassword,
                        controller: _confirmPasswordController,
                        validator:
                            (value) => Validators.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppStyles.primaryColor,
                            ),
                          )
                          : CustomButton(
                            text: 'Daftar',
                            icon: Icons.person_add,
                            onPressed: _handleRegister,
                            width: double.infinity,
                            gradient: AppStyles.accentGradient,
                          ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sudah punya akun?', style: AppStyles.bodyText),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              );
                            },
                            child: Text(
                              'Masuk',
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

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Cek apakah ID unik sudah digunakan
        final isIdUnique = await _firestoreService.checkUniqueId(
          _idUnikController.text.trim(),
        );

        if (!isIdUnique) {
          _showMessage(
            'ID tersebut sudah digunakan. Silakan gunakan ID lain.',
            StatusConstants.warning,
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Buat akun di Firebase Auth
        final user = await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (user != null) {
          // Simpan data pengguna ke Firestore
          await _firestoreService.saveUser(
            user.uid,
            _emailController.text.trim(),
            _namaController.text.trim(),
            _selectedRole,
            _idUnikController.text.trim(),
            isVerified: false, // Default false, perlu verifikasi admin
          );

          // Catat aktivitas pendaftaran
          await _firestoreService.logActivity(
            user.uid,
            _selectedRole,
            'register',
            'Pendaftaran pengguna baru sebagai ${_selectedRoleData['label']}',
          );

          _showMessage(
            'Pendaftaran berhasil! Akun Anda akan diverifikasi oleh admin.',
            StatusConstants.success,
          );

          // Arahkan ke halaman login setelah delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          });
        } else {
          _showMessage(
            'Pendaftaran gagal. Silakan coba lagi.',
            StatusConstants.error,
          );
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
}
