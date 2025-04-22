import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/components/custom_card.dart';
import '../../../ui/components/custom_button.dart';
import '../../../ui/components/custom_text_field.dart';
import '../../../ui/components/custom_app_bar.dart';
import '../../../ui/components/custom_avatar.dart';
import '../../../ui/components/sidebar.dart';
import '../../../ui/styles/app_styles.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../services/firestore_service.dart';
import '../../../providers/user_session_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../models/user_model.dart'; // Tambahkan ini
import '../../../constants/collection_constants.dart'; // Tambahkan ini

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kelasJabatanController = TextEditingController();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;
  String? _fotoUrl;
  String _initials = 'P';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userSession = Provider.of<UserSessionProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await _firestoreService.getUser(userSession.uid ?? '');

      if (userData != null && mounted) {
        setState(() {
          _namaController.text = userData['nama'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _teleponController.text = userData['telepon'] ?? '';
          _alamatController.text = userData['alamat'] ?? '';
          _kelasJabatanController.text = userData['kelas_jabatan'] ?? '';
          _fotoUrl = userData['foto_url'];

          if (_namaController.text.isNotEmpty) {
            _initials = _namaController.text[0].toUpperCase();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppStyles.statusError,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final String role = userSession.idLevelUser ?? 'S';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Profil'),
      body: Row(
        children: [
          const Sidebar(activeMenu: '/profile'),
          Expanded(
            child: Container(
              color: AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
              padding: const EdgeInsets.all(24),
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edit Profil',
                                style: AppStyles.headingLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Perbarui informasi profil Anda',
                                style: AppStyles.captionText,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Foto profil
                                  CustomCard(
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        children: [
                                          CustomAvatar(
                                            initials: _initials,
                                            imageUrl: _fotoUrl,
                                            radius: 60,
                                            backgroundColor: _getRoleColor(
                                              role,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          CustomButton(
                                            text: 'Ubah Foto',
                                            icon: Icons.photo_camera,
                                            width: double.infinity,
                                            onPressed: () {
                                              // Implementasi ubah foto
                                            },
                                          ),
                                          if (_fotoUrl != null) ...[
                                            const SizedBox(height: 16),
                                            CustomButton(
                                              text: 'Hapus Foto',
                                              icon: Icons.delete,
                                              width: double.infinity,
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppStyles.statusError
                                                      .withOpacity(0.8),
                                                  AppStyles.statusError,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              onPressed: () {
                                                // Implementasi hapus foto
                                                setState(() {
                                                  _fotoUrl = null;
                                                });
                                              },
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  // Form data profil
                                  Expanded(
                                    child: CustomCard(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Informasi Dasar',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppStyles.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              hintText: 'Nama Lengkap',
                                              prefixIcon: Icons.person,
                                              controller: _namaController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Nama tidak boleh kosong';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              hintText: 'Email',
                                              prefixIcon: Icons.email,
                                              controller: _emailController,
                                              enabled:
                                                  false, // Email tidak bisa diubah
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              hintText: 'No. Telepon',
                                              prefixIcon: Icons.phone,
                                              controller: _teleponController,
                                              keyboardType: TextInputType.phone,
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              hintText: 'Alamat',
                                              prefixIcon: Icons.home,
                                              controller: _alamatController,
                                              maxLines: 3,
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              hintText:
                                                  role == 'S'
                                                      ? 'Kelas'
                                                      : 'Jabatan',
                                              prefixIcon:
                                                  role == 'S'
                                                      ? Icons.class_
                                                      : Icons.work,
                                              controller:
                                                  _kelasJabatanController,
                                            ),
                                            const SizedBox(height: 24),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CustomButton(
                                                  text: 'Batal',
                                                  icon: Icons.cancel,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.grey.withOpacity(
                                                        0.8,
                                                      ),
                                                      Colors.grey,
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                CustomButton(
                                                  text: 'Simpan',
                                                  icon: Icons.save,
                                                  onPressed: _handleSave,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userSession = Provider.of<UserSessionProvider>(
          context,
          listen: false,
        );

        // Update data di Firestore
        await _firestoreService.updateUser(
          userSession.uid ?? '',
          _namaController.text,
          _kelasJabatanController.text,
          telepon: _teleponController.text,
          alamat: _alamatController.text,
          fotoUrl: _fotoUrl,
        );

        // Update data di provider
        userSession.setUser(
          userSession.uid ?? '',
          _namaController.text,
          userSession.idLevelUser ?? 'S',
          userSession.idUnik ?? '',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profil berhasil diperbarui'),
              backgroundColor: AppStyles.statusSuccess,
            ),
          );

          Navigator.pushReplacementNamed(context, AppRoutes.profile);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: AppStyles.statusError,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'A':
        return AppStyles.roleAdmin;
      case 'G':
        return AppStyles.roleGuru;
      case 'T':
        return AppStyles.roleTU;
      case 'K':
        return AppStyles.roleKepsek;
      case 'S':
        return AppStyles.roleSiswa;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    _kelasJabatanController.dispose();
    super.dispose();
  }
}
