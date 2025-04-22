import 'package:flutter/material.dart';
import '../components/custom_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String? photoUrl;
  final bool isVerified;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.role,
    required this.email,
    this.photoUrl,
    required this.isVerified,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar dan informasi profil
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CustomAvatar(photoUrl: photoUrl, name: name, size: 100),
                const SizedBox(width: 24),

                // Informasi profil
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isVerified)
                            Icon(Icons.verified, color: Colors.blue, size: 20),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getRoleColor(role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getRoleDisplay(role),
                          style: TextStyle(
                            color: _getRoleColor(role),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.email, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tombol edit profil
                ElevatedButton.icon(
                  onPressed: onEditProfile,
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profil'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'guru':
        return Colors.blue;
      case 'siswa':
        return Colors.green;
      case 'tata usaha':
        return Colors.orange;
      case 'kepala sekolah':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplay(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'guru':
        return 'Guru';
      case 'siswa':
        return 'Siswa';
      case 'tata usaha':
        return 'Tata Usaha';
      case 'kepala sekolah':
        return 'Kepala Sekolah';
      default:
        return role;
    }
  }
}
