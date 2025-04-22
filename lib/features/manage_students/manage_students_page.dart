import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/components/custom_card.dart';
import '../../../ui/components/custom_app_bar.dart';
import '../../../ui/components/custom_button.dart';
import '../../../ui/components/custom_text_field.dart';
import '../../../ui/components/sidebar.dart';
import '../../../ui/components/status_badge.dart';
import '../../../ui/styles/app_styles.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../providers/user_session_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../constants/role_constants.dart';
import '../../../models/user_model.dart'; // Tambahkan ini
import '../../../models/class_model.dart'; // Tambahkan ini
import '../../../constants/collection_constants.dart'; // Tambahkan ini

class ManageStudentsPage extends StatefulWidget {
  const ManageStudentsPage({super.key});

  @override
  _ManageStudentsPageState createState() => _ManageStudentsPageState();
}

class _ManageStudentsPageState extends State<ManageStudentsPage> {
  final _searchController = TextEditingController();
  final _firestoreService = FirestoreService();
  String _selectedClass = 'Semua Kelas';
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  final List<String> _classes = [
    'Semua Kelas',
    '10A',
    '10B',
    '11A',
    '11B',
    '12A',
    '12B',
  ];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Dummy data untuk contoh
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _students = [
          {
            'id': 'S_000001',
            'name': 'Ahmad Hidayat',
            'email': 'ahmad.hidayat@sekolah.id',
            'class': '10A',
            'status': 'active',
          },
          {
            'id': 'S_000002',
            'name': 'Siti Rahayu',
            'email': 'siti.rahayu@sekolah.id',
            'class': '10A',
            'status': 'active',
          },
          {
            'id': 'S_000003',
            'name': 'Budi Santoso',
            'email': 'budi.santoso@sekolah.id',
            'class': '11B',
            'status': 'active',
          },
          {
            'id': 'S_000004',
            'name': 'Dewi Lestari',
            'email': 'dewi.lestari@sekolah.id',
            'class': '11A',
            'status': 'inactive',
          },
          {
            'id': 'S_000005',
            'name': 'Eko Prasetyo',
            'email': 'eko.prasetyo@sekolah.id',
            'class': '12A',
            'status': 'active',
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

  List<Map<String, dynamic>> _getFilteredStudents() {
    final String searchQuery = _searchController.text.toLowerCase();

    return _students.where((student) {
      // Filter berdasarkan kelas
      if (_selectedClass != 'Semua Kelas' &&
          student['class'] != _selectedClass) {
        return false;
      }

      // Filter berdasarkan pencarian
      if (searchQuery.isNotEmpty) {
        return student['name'].toLowerCase().contains(searchQuery) ||
            student['id'].toLowerCase().contains(searchQuery) ||
            student['email'].toLowerCase().contains(searchQuery);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final filteredStudents = _getFilteredStudents();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Kelola Siswa'),
      body: Row(
        children: [
          const Sidebar(activeMenu: '/manage-students'),
          Expanded(
            child: Container(
              color: AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  Expanded(
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _buildStudentList(filteredStudents),
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
          _showAddStudentDialog();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kelola Siswa', style: AppStyles.headingLarge),
            const SizedBox(height: 4),
            Text(
              'Tambah, edit, dan kelola data siswa',
              style: AppStyles.captionText,
            ),
          ],
        ),
        CustomButton(
          text: 'Import Data',
          icon: Icons.upload_file,
          onPressed: () {
            // Import data siswa
          },
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
            hintText: 'Cari siswa berdasarkan nama, ID, atau email',
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
                value: _selectedClass,
                isExpanded: true,
                dropdownColor:
                    AppTheme.isDarkMode ? AppStyles.bgCard : Colors.white,
                items:
                    _classes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedClass = newValue!;
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
              _selectedClass = 'Semua Kelas';
            });
          },
        ),
      ],
    );
  }

  Widget _buildStudentList(List<Map<String, dynamic>> students) {
    if (students.isEmpty) {
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
              'Tidak ada siswa yang ditemukan',
              style: AppStyles.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coba ubah filter pencarian atau tambahkan siswa baru',
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
                    'Kelas',
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
              itemCount: students.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = students[index];
                return _buildStudentListItem(student);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListItem(Map<String, dynamic> student) {
    return InkWell(
      onTap: () {
        _showStudentDetailDialog(student);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                student['id'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppStyles.roleSiswa.withOpacity(0.2),
                    child: Text(
                      student['name'][0],
                      style: TextStyle(
                        color: AppStyles.roleSiswa,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      student['name'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(student['email'], overflow: TextOverflow.ellipsis),
            ),
            Expanded(flex: 1, child: Text(student['class'])),
            Expanded(
              flex: 1,
              child: StatusBadge(
                label: student['status'] == 'active' ? 'Aktif' : 'Nonaktif',
                color:
                    student['status'] == 'active'
                        ? AppStyles.statusSuccess
                        : AppStyles.statusError,
              ),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: AppStyles.primaryColor),
                    tooltip: 'Edit',
                    onPressed: () {
                      _showEditStudentDialog(student);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: AppStyles.statusError),
                    tooltip: 'Hapus',
                    onPressed: () {
                      _showDeleteConfirmationDialog(student);
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

  void _showStudentDetailDialog(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Siswa'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppStyles.roleSiswa.withOpacity(0.2),
                    child: Text(
                      student['name'][0],
                      style: TextStyle(
                        color: AppStyles.roleSiswa,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    student['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: StatusBadge(
                    label: student['status'] == 'active' ? 'Aktif' : 'Nonaktif',
                    color:
                        student['status'] == 'active'
                            ? AppStyles.statusSuccess
                            : AppStyles.statusError,
                  ),
                ),
                const SizedBox(height: 24),
                _buildDetailItem('ID Siswa', student['id']),
                _buildDetailItem('Email', student['email']),
                _buildDetailItem('Kelas', student['class']),
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditStudentDialog(student);
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

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final idController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedClass = _classes[1]; // Default to first class (10A)

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Siswa Baru'),
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
                    hintText: 'ID Siswa (S_XXXXXX)',
                    prefixIcon: Icons.badge,
                    controller: idController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ID tidak boleh kosong';
                      }
                      if (!value.startsWith('S_') || value.length < 8) {
                        return 'ID harus dimulai dengan S_ dan minimal 8 karakter';
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
                        value: selectedClass,
                        isExpanded: true,
                        dropdownColor:
                            AppTheme.isDarkMode
                                ? AppStyles.bgCard
                                : Colors.white,
                        hint: const Text('Pilih Kelas'),
                        items:
                            _classes.where((c) => c != 'Semua Kelas').map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          selectedClass = newValue!;
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();

                  // Tambahkan siswa baru ke daftar
                  setState(() {
                    _students.add({
                      'id': idController.text,
                      'name': nameController.text,
                      'email': emailController.text,
                      'class': selectedClass,
                      'status': 'active',
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Siswa ${nameController.text} berhasil ditambahkan',
                      ),
                      backgroundColor: AppStyles.statusSuccess,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditStudentDialog(Map<String, dynamic> student) {
    final nameController = TextEditingController(text: student['name']);
    final emailController = TextEditingController(text: student['email']);
    final idController = TextEditingController(text: student['id']);
    final formKey = GlobalKey<FormState>();
    String selectedClass = student['class'];
    String selectedStatus = student['status'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Siswa'),
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
                    hintText: 'ID Siswa (S_XXXXXX)',
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
                              value: selectedClass,
                              isExpanded: true,
                              dropdownColor:
                                  AppTheme.isDarkMode
                                      ? AppStyles.bgCard
                                      : Colors.white,
                              hint: const Text('Pilih Kelas'),
                              items:
                                  _classes.where((c) => c != 'Semua Kelas').map(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                              onChanged: (newValue) {
                                selectedClass = newValue!;
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
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              isExpanded: true,
                              dropdownColor:
                                  AppTheme.isDarkMode
                                      ? AppStyles.bgCard
                                      : Colors.white,
                              hint: const Text('Pilih Status'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'active',
                                  child: Text('Aktif'),
                                ),
                                DropdownMenuItem(
                                  value: 'inactive',
                                  child: Text('Nonaktif'),
                                ),
                              ],
                              onChanged: (newValue) {
                                selectedStatus = newValue!;
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();

                  // Update data siswa
                  setState(() {
                    final index = _students.indexWhere(
                      (s) => s['id'] == student['id'],
                    );
                    if (index != -1) {
                      _students[index] = {
                        'id': idController.text,
                        'name': nameController.text,
                        'email': emailController.text,
                        'class': selectedClass,
                        'status': selectedStatus,
                      };
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Data siswa ${nameController.text} berhasil diperbarui',
                      ),
                      backgroundColor: AppStyles.statusSuccess,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah Anda yakin ingin menghapus siswa ${student['name']}?',
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
              onPressed: () {
                Navigator.of(context).pop();

                // Hapus siswa dari daftar
                setState(() {
                  _students.removeWhere((s) => s['id'] == student['id']);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Siswa ${student['name']} berhasil dihapus'),
                    backgroundColor: AppStyles.statusSuccess,
                  ),
                );
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
