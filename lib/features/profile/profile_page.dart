import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/components/custom_card.dart';
import '../../../ui/components/custom_button.dart';
import '../../../ui/components/custom_avatar.dart';
import '../../../ui/components/custom_app_bar.dart';
import '../../../ui/components/sidebar.dart';
import '../../../ui/components/status_badge.dart';
import '../../../ui/styles/app_styles.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../services/firestore_service.dart';
import '../../../providers/user_session_provider.dart';
import '../../../routes/app_routes.dart';
import 'profile_update_page.dart';
import '../../../models/user_model.dart'; // Tambahkan ini
import '../../../constants/collection_constants.dart'; // Tambahkan ini

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profil Pengguna'),
      body: Row(
        children: [
          const Sidebar(activeMenu: '/profile'),
          Expanded(
            child: Container(
              color: AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
              padding: const EdgeInsets.all(24),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: firestoreService.getUser(userSession.uid ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppStyles.statusError,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Terjadi kesalahan saat memuat data',
                            style: AppStyles.headingMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Silakan coba lagi nanti',
                            style: AppStyles.captionText,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Coba Lagi',
                            icon: Icons.refresh,
                            onPressed: () {
                              // Refresh halaman
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  final userData = snapshot.data ?? {};
                  final nama =
                      userData['nama'] ?? userSession.nama ?? 'Pengguna';
                  final initials =
                      nama.isNotEmpty ? nama[0].toUpperCase() : 'P';
                  final idUnik =
                      userData['id_unik'] ?? userSession.idUnik ?? '-';
                  final role =
                      userData['id_level_user'] ??
                      userSession.idLevelUser ??
                      'S';
                  final fotoUrl = userData['foto_url'] as String?;
                  final email = userData['email'] ?? '-';
                  final isVerified = userData['is_verified'] ?? false;
                  final kelasJabatan = userData['kelas_jabatan'] ?? '-';

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      Expanded(
                        flex: 1,
                        child: CustomCard(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomAvatar(
                                  initials: initials,
                                  imageUrl: fotoUrl,
                                  radius: 60,
                                  backgroundColor: _getRoleColor(role),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  nama,
                                  style: AppStyles.headingMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(role).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    _getRoleName(role),
                                    style: TextStyle(
                                      color: _getRoleColor(role),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                StatusBadge(
                                  label:
                                      isVerified
                                          ? 'Terverifikasi'
                                          : 'Belum Verifikasi',
                                  color:
                                      isVerified
                                          ? AppStyles.statusSuccess
                                          : AppStyles.statusWarning,
                                ),
                                const SizedBox(height: 32),
                                CustomButton(
                                  text: "Edit Profil",
                                  icon: Icons.edit,
                                  width: double.infinity,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const ProfileUpdatePage(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  text: "Ubah Password",
                                  icon: Icons.lock,
                                  width: double.infinity,
                                  gradient: AppStyles.accentGradient,
                                  onPressed: () {
                                    // Implementasi ubah password
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  text: "Logout",
                                  icon: Icons.logout,
                                  width: double.infinity,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppStyles.statusError.withOpacity(0.8),
                                      AppStyles.statusError,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  onPressed: () {
                                    _showLogoutConfirmationDialog(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Detail Profile
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Profil',
                              style: AppStyles.headingLarge,
                            ),
                            const SizedBox(height: 24),
                            CustomCard(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildProfileSection(
                                      title: 'Informasi Dasar',
                                      icon: Icons.person,
                                      children: [
                                        _buildProfileItem(
                                          label: 'Nama Lengkap',
                                          value: nama,
                                        ),
                                        _buildProfileItem(
                                          label: 'ID',
                                          value: idUnik,
                                        ),
                                        _buildProfileItem(
                                          label: 'Role',
                                          value: _getRoleName(role),
                                        ),
                                        _buildProfileItem(
                                          label:
                                              role == 'S' ? 'Kelas' : 'Jabatan',
                                          value: kelasJabatan,
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 32),
                                    _buildProfileSection(
                                      title: 'Kontak',
                                      icon: Icons.contact_mail,
                                      children: [
                                        _buildProfileItem(
                                          label: 'Email',
                                          value: email,
                                        ),
                                        _buildProfileItem(
                                          label: 'No. Telepon',
                                          value: userData['telepon'] ?? '-',
                                        ),
                                        _buildProfileItem(
                                          label: 'Alamat',
                                          value: userData['alamat'] ?? '-',
                                        ),
                                      ],
                                    ),
                                    if (role == 'S') ...[
                                      const Divider(height: 32),
                                      _buildProfileSection(
                                        title: 'Informasi Akademik',
                                        icon: Icons.school,
                                        children: [
                                          _buildProfileItem(
                                            label: 'Tahun Masuk',
                                            value:
                                                userData['tahun_masuk'] ?? '-',
                                          ),
                                          _buildProfileItem(
                                            label: 'Wali Kelas',
                                            value:
                                                userData['wali_kelas'] ?? '-',
                                          ),
                                          _buildProfileItem(
                                            label: 'Status',
                                            value: 'Aktif',
                                            valueColor: AppStyles.statusSuccess,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomCard(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Aktivitas Terbaru',
                                          style: AppStyles.headingMedium,
                                        ),
                                        TextButton.icon(
                                          icon: const Icon(Icons.history),
                                          label: const Text('Lihat Semua'),
                                          onPressed: () {
                                            // Lihat semua aktivitas
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildActivityItem(
                                      action: 'Login',
                                      time: '2 jam yang lalu',
                                      icon: Icons.login,
                                      color: AppStyles.statusInfo,
                                    ),
                                    _buildActivityItem(
                                      action: 'Mengubah profil',
                                      time: '3 hari yang lalu',
                                      icon: Icons.edit,
                                      color: AppStyles.primaryColor,
                                    ),
                                    _buildActivityItem(
                                      action: 'Mengubah password',
                                      time: '1 minggu yang lalu',
                                      icon: Icons.lock,
                                      color: AppStyles.accentColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppStyles.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyles.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildProfileItem({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                color: AppStyles.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? AppStyles.textPrimary,
                fontWeight:
                    valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String action,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(time, style: AppStyles.captionText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.statusError,
              ),
              onPressed: () {
                // Implementasi logout
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, AppRoutes.auth);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
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

  String _getRoleName(String role) {
    switch (role) {
      case 'A':
        return 'Admin';
      case 'G':
        return 'Guru';
      case 'T':
        return 'Tata Usaha';
      case 'K':
        return 'Kepala Sekolah';
      case 'S':
        return 'Siswa';
      default:
        return 'Pengguna';
    }
  }
}
