import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/components/custom_app_bar.dart';
import '../../../ui/components/custom_card.dart';
import '../../../ui/components/custom_button.dart';
import '../../../ui/components/custom_text_field.dart';
import '../../../ui/components/custom_list_tile.dart';
import '../../../ui/components/sidebar.dart';
import '../../../ui/components/status_badge.dart';
import '../../../ui/styles/app_styles.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../services/audit_log_service.dart';
import '../../../services/firestore_service.dart';
import '../../../providers/user_session_provider.dart';
import '../../../constants/role_constants.dart';
import '../../../models/user_model.dart'; // Tambahkan ini
import '../../../constants/collection_constants.dart'; // Tambahkan ini

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final _searchController = TextEditingController();
  final _auditLogService = AuditLogService();
  final _firestoreService = FirestoreService();
  String _selectedRole = 'Semua';
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  final List<String> _roles = [
    'Semua',
    'Admin',
    'Guru',
    'Tata Usaha',
    'Kepala Sekolah',
    'Siswa',
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Dummy data untuk contoh
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _users = [
          {
            'id': 'A_000001',
            'name': 'Admin Utama',
            'email': 'admin@sekolah.id',
            'role': 'A',
            'is_verified': true,
          },
          {
            'id': 'G_000001',
            'name': 'Budi Santoso',
            'email': 'budi.santoso@sekolah.id',
            'role': 'G',
            'is_verified': true,
          },
          {
            'id': 'G_000002',
            'name': 'Siti Aminah',
            'email': 'siti.aminah@sekolah.id',
            'role': 'G',
            'is_verified': true,
          },
          {
            'id': 'T_000001',
            'name': 'Joko Susilo',
            'email': 'joko.susilo@sekolah.id',
            'role': 'T',
            'is_verified': true,
          },
          {
            'id': 'K_000001',
            'name': 'Made Wirawan',
            'email': 'made.wirawan@sekolah.id',
            'role': 'K',
            'is_verified': true,
          },
          {
            'id': 'S_000001',
            'name': 'Ahmad Hidayat',
            'email': 'ahmad.hidayat@sekolah.id',
            'role': 'S',
            'is_verified': true,
          },
          {
            'id': 'S_000002',
            'name': 'Rina Wati',
            'email': 'rina.wati@sekolah.id',
            'role': 'S',
            'is_verified': false,
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppStyles.statusError,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    final String searchQuery = _searchController.text.toLowerCase();

    return _users.where((user) {
      // Filter berdasarkan role
      if (_selectedRole != 'Semua') {
        final String roleCode = _getRoleCode(_selectedRole);
        if (user['role'] != roleCode) {
          return false;
        }
      }

      // Filter berdasarkan pencarian
      if (searchQuery.isNotEmpty) {
        return user['name'].toLowerCase().contains(searchQuery) ||
            user['id'].toLowerCase().contains(searchQuery) ||
            user['email'].toLowerCase().contains(searchQuery);
      }

      return true;
    }).toList();
  }

  String _getRoleCode(String roleName) {
    switch (roleName) {
      case 'Admin':
        return 'A';
      case 'Guru':
        return 'G';
      case 'Tata Usaha':
        return 'T';
      case 'Kepala Sekolah':
        return 'K';
      case 'Siswa':
        return 'S';
      default:
        return '';
    }
  }

  String _getRoleName(String roleCode) {
    switch (roleCode) {
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
        return 'Unknown';
    }
  }

  Color _getRoleColor(String roleCode) {
    switch (roleCode) {
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
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final filteredUsers = _getFilteredUsers();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Kelola Pengguna'),
      body: Row(
        children: [
          const Sidebar(activeMenu: '/manage-users'),
          Expanded(
            child: Container(
              color: AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(userSession),
                  const SizedBox(height: 24),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  Expanded(
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _buildUserList(filteredUsers, userSession),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddUserDialog(userSession);
        },
      ),
    );
  }

  Widget _buildHeader(UserSessionProvider userSession) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kelola Pengguna', style: AppStyles.headingLarge),
            const SizedBox(height: 4),
            Text(
              'Tambah, edit, dan kelola akun pengguna',
              style: AppStyles.captionText,
            ),
          ],
        ),
        Row(
          children: [
            CustomButton(
              text: 'Audit Log',
              icon: Icons.history,
              onPressed: () {
                // Navigate to audit log
              },
            ),
            const SizedBox(width: 16),
            CustomButton(
              text: 'Refresh',
              icon: Icons.refresh,
              onPressed: _loadUsers,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomTextField(
            hintText: 'Cari pengguna berdasarkan nama, ID, atau email',
            prefixIcon: Icons.search,
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.isDarkMode ? AppStyles.bgCard : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRole,
                isExpanded: true,
                dropdownColor:
                    AppTheme.isDarkMode ? AppStyles.bgCard : Colors.white,
                items:
                    _roles.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CustomButton(
          text: 'Reset',
          icon: Icons.refresh,
          onPressed: () {
            setState(() {
              _searchController.clear();
              _selectedRole = 'Semua';
            });
          },
        ),
      ],
    );
  }

  Widget _buildUserList(
    List<Map<String, dynamic>> users,
    UserSessionProvider userSession,
  ) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppStyles.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pengguna yang ditemukan',
              style: AppStyles.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coba ubah filter pencarian atau tambahkan pengguna baru',
              style: AppStyles.captionText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return CustomCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'ID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Role',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 100),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserListItem(user, userSession);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> user,
    UserSessionProvider userSession,
  ) {
    final String roleName = _getRoleName(user['role']);
    final Color roleColor = _getRoleColor(user['role']);

    return InkWell(
      onTap: () {
        _showUserDetailDialog(user);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                user['id'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: roleColor.withOpacity(0.2),
                    child: Text(
                      user['name'][0],
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(user['name'], overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(user['email'], overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  roleName,
                  style: TextStyle(
                    fontSize: 12,
                    color: roleColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: StatusBadge(
                label:
                    user['is_verified'] ? 'Terverifikasi' : 'Belum Verifikasi',
                color:
                    user['is_verified']
                        ? AppStyles.statusSuccess
                        : AppStyles.statusWarning,
              ),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!user['is_verified'])
                    IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: AppStyles.statusSuccess,
                      ),
                      tooltip: 'Verifikasi',
                      onPressed: () {
                        _verifyUser(user, userSession);
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppStyles.primaryColor),
                    tooltip: 'Edit',
                    onPressed: () {
                      _showEditUserDialog(user, userSession);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: AppStyles.statusError),
                    tooltip: 'Hapus',
                    onPressed: () {
                      _showDeleteConfirmationDialog(user, userSession);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetailDialog(Map<String, dynamic> user) {
    final String roleName = _getRoleName(user['role']);
    final Color roleColor = _getRoleColor(user['role']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Pengguna'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: roleColor.withOpacity(0.2),
                    child: Text(
                      user['name'][0],
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      roleName,
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: StatusBadge(
                    label:
                        user['is_verified']
                            ? 'Terverifikasi'
                            : 'Belum Verifikasi',
                    color:
                        user['is_verified']
                            ? AppStyles.statusSuccess
                            : AppStyles.statusWarning,
                  ),
                ),
                const SizedBox(height: 24),
                _buildDetailItem('ID Pengguna', user['id']),
                _buildDetailItem('Email', user['email']),
                // Tambahkan detail lainnya sesuai kebutuhan
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
            if (!user['is_verified'])
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.statusSuccess,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _verifyUser(
                    user,
                    Provider.of<UserSessionProvider>(context, listen: false),
                  );
                },
                child: const Text('Verifikasi'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditUserDialog(
                  user,
                  Provider.of<UserSessionProvider>(context, listen: false),
                );
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
            child: Text(value, style: TextStyle(color: AppStyles.textPrimary)),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(UserSessionProvider userSession) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final idController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedRole = 'S'; // Default to Siswa

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Pengguna Baru'),
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    hintText: 'Nama Lengkap',
                    prefixIcon: Icons.person,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'ID Pengguna (X_XXXXXX)',
                    prefixIcon: Icons.badge,
                    controller: idController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ID tidak boleh kosong';
                      }
                      if (value.length < 8) {
                        return 'ID minimal 8 karakter';
                      }
                      final prefix = value.substring(0, 2);
                      if (prefix != 'A_' &&
                          prefix != 'G_' &&
                          prefix != 'T_' &&
                          prefix != 'K_' &&
                          prefix != 'S_') {
                        return 'ID harus dimulai dengan A_, G_, T_, K_, atau S_';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.isDarkMode ? AppStyles.bgCard : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        dropdownColor:
                            AppTheme.isDarkMode
                                ? AppStyles.bgCard
                                : Colors.white,
                        hint: const Text('Pilih Role'),
                        items: const [
                          DropdownMenuItem(value: 'A', child: Text('Admin')),
                          DropdownMenuItem(value: 'G', child: Text('Guru')),
                          DropdownMenuItem(
                            value: 'T',
                            child: Text('Tata Usaha'),
                          ),
                          DropdownMenuItem(
                            value: 'K',
                            child: Text('Kepala Sekolah'),
                          ),
                          DropdownMenuItem(value: 'S', child: Text('Siswa')),
                        ],
                        onChanged: (newValue) {
                          selectedRole = newValue!;
                          // Update ID prefix sesuai role
                          if (idController.text.isEmpty ||
                              idController.text.length < 2 ||
                              idController.text.substring(0, 2) !=
                                  '${selectedRole}_') {
                            idController.text = '${selectedRole}_';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();

                  // Tambahkan pengguna baru ke daftar
                  setState(() {
                    _users.add({
                      'id': idController.text,
                      'name': nameController.text,
                      'email': emailController.text,
                      'role': selectedRole,
                      'is_verified':
                          true, // Admin-created users are verified by default
                    });
                  });

                  // Log aktivitas
                  await _auditLogService.logAction(
                    userSession.idLevelUser ?? '',
                    'add_user',
                    'Menambah pengguna baru ${nameController.text} (${_getRoleName(selectedRole)}) oleh ${userSession.nama}',
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pengguna ${nameController.text} berhasil ditambahkan',
                        ),
                        backgroundColor: AppStyles.statusSuccess,
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(
    Map<String, dynamic> user,
    UserSessionProvider userSession,
  ) {
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);
    final idController = TextEditingController(text: user['id']);
    final formKey = GlobalKey<FormState>();
    String selectedRole = user['role'];
    bool isVerified = user['is_verified'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Pengguna'),
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    hintText: 'Nama Lengkap',
                    prefixIcon: Icons.person,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'ID Pengguna',
                    prefixIcon: Icons.badge,
                    controller: idController,
                    enabled: false, // ID tidak bisa diubah
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.isDarkMode
                                    ? AppStyles.bgCard
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedRole,
                              isExpanded: true,
                              dropdownColor:
                                  AppTheme.isDarkMode
                                      ? AppStyles.bgCard
                                      : Colors.white,
                              hint: const Text('Pilih Role'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'A',
                                  child: Text('Admin'),
                                ),
                                DropdownMenuItem(
                                  value: 'G',
                                  child: Text('Guru'),
                                ),
                                DropdownMenuItem(
                                  value: 'T',
                                  child: Text('Tata Usaha'),
                                ),
                                DropdownMenuItem(
                                  value: 'K',
                                  child: Text('Kepala Sekolah'),
                                ),
                                DropdownMenuItem(
                                  value: 'S',
                                  child: Text('Siswa'),
                                ),
                              ],
                              onChanged: (newValue) {
                                selectedRole = newValue!;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.isDarkMode
                                    ? AppStyles.bgCard
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<bool>(
                              value: isVerified,
                              isExpanded: true,
                              dropdownColor:
                                  AppTheme.isDarkMode
                                      ? AppStyles.bgCard
                                      : Colors.white,
                              hint: const Text('Status Verifikasi'),
                              items: const [
                                DropdownMenuItem(
                                  value: true,
                                  child: Text('Terverifikasi'),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text('Belum Verifikasi'),
                                ),
                              ],
                              onChanged: (newValue) {
                                isVerified = newValue!;
                              },
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();

                  // Update data pengguna
                  setState(() {
                    final index = _users.indexWhere(
                      (u) => u['id'] == user['id'],
                    );
                    if (index != -1) {
                      _users[index] = {
                        'id': idController.text,
                        'name': nameController.text,
                        'email': emailController.text,
                        'role': selectedRole,
                        'is_verified': isVerified,
                      };
                    }
                  });

                  // Log aktivitas
                  await _auditLogService.logAction(
                    userSession.idLevelUser ?? '',
                    'edit_user',
                    'Mengedit pengguna ${nameController.text} (${_getRoleName(selectedRole)}) oleh ${userSession.nama}',
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Data pengguna ${nameController.text} berhasil diperbarui',
                        ),
                        backgroundColor: AppStyles.statusSuccess,
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _verifyUser(
    Map<String, dynamic> user,
    UserSessionProvider userSession,
  ) async {
    // Update status verifikasi pengguna
    setState(() {
      final index = _users.indexWhere((u) => u['id'] == user['id']);
      if (index != -1) {
        _users[index]['is_verified'] = true;
      }
    });

    // Log aktivitas
    await _auditLogService.logAction(
      userSession.idLevelUser ?? '',
      'verify_user',
      'Memverifikasi pengguna ${user['name']} (${_getRoleName(user['role'])}) oleh ${userSession.nama}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pengguna ${user['name']} berhasil diverifikasi'),
        backgroundColor: AppStyles.statusSuccess,
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    Map<String, dynamic> user,
    UserSessionProvider userSession,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah Anda yakin ingin menghapus pengguna ${user['name']}?',
          ),
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
              onPressed: () async {
                Navigator.of(context).pop();

                // Hapus pengguna dari daftar
                setState(() {
                  _users.removeWhere((u) => u['id'] == user['id']);
                });

                // Log aktivitas
                await _auditLogService.logAction(
                  userSession.idLevelUser ?? '',
                  'delete_user',
                  'Menghapus pengguna ${user['name']} (${_getRoleName(user['role'])}) oleh ${userSession.nama}',
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Pengguna ${user['name']} berhasil dihapus',
                      ),
                      backgroundColor: AppStyles.statusSuccess,
                    ),
                  );
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
