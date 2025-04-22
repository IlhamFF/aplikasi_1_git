import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_session_provider.dart';
import '../../../ui/components/custom_card.dart';
import '../../../ui/components/custom_app_bar.dart';
import '../../../ui/components/sidebar.dart';
import '../../../ui/components/status_badge.dart';
import '../../../ui/styles/app_styles.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../utils/role_based_widget.dart';
import '../../constants/role_constants.dart';
import '../../../models/schedule_model.dart'; // Tambahkan ini
import '../../../models/subject_model.dart'; // Tambahkan ini
import '../../../models/class_model.dart'; // Tambahkan ini
import '../../../constants/collection_constants.dart'; // Tambahkan ini

class ClassSchedulesPage extends StatelessWidget {
  const ClassSchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final String role = userSession.idLevelUser ?? '';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Jadwal Kelas'),
      body: Row(
        children: [
          const Sidebar(activeMenu: '/class-schedules'),
          Expanded(
            child: Container(
              color: AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(),
                  const SizedBox(height: 24),

                  // Content berdasarkan role
                  Expanded(
                    child: RoleBasedWidget(
                      currentRole: role,
                      // Konten untuk Guru
                      teacherWidget: _buildTeacherSchedule(),
                      // Konten untuk Siswa
                      studentWidget: _buildStudentSchedule(),
                      // Default untuk role lain
                      defaultWidget: _buildDefaultContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jadwal Kelas', style: AppStyles.headingLarge),
        const SizedBox(height: 8),
        Text('Kelola dan lihat jadwal pelajaran', style: AppStyles.captionText),
      ],
    );
  }

  Widget _buildTeacherSchedule() {
    // Dummy data untuk jadwal mengajar guru
    final List<Map<String, dynamic>> teachingSchedule = [
      {
        'day': 'Senin',
        'schedules': [
          {
            'time': '07:00 - 08:30',
            'subject': 'Matematika',
            'class': '10A',
            'room': 'R101',
          },
          {
            'time': '10:15 - 11:45',
            'subject': 'Matematika',
            'class': '11B',
            'room': 'R203',
          },
        ],
      },
      {
        'day': 'Selasa',
        'schedules': [
          {
            'time': '08:45 - 10:15',
            'subject': 'Matematika',
            'class': '12C',
            'room': 'R305',
          },
        ],
      },
      {
        'day': 'Rabu',
        'schedules': [
          {
            'time': '07:00 - 08:30',
            'subject': 'Matematika',
            'class': '10B',
            'room': 'R102',
          },
          {
            'time': '12:30 - 14:00',
            'subject': 'Matematika',
            'class': '11A',
            'room': 'R201',
          },
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jadwal Mengajar', style: AppStyles.headingMedium),
            StatusBadge(
              label: 'Semester Ganjil 2023/2024',
              color: AppStyles.statusInfo,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: teachingSchedule.length,
            itemBuilder: (context, index) {
              final daySchedule = teachingSchedule[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      daySchedule['day'],
                      style: AppStyles.headingMedium.copyWith(
                        color: AppStyles.primaryColor,
                      ),
                    ),
                  ),
                  ...List.generate(daySchedule['schedules'].length, (idx) {
                    final schedule = daySchedule['schedules'][idx];
                    return CustomCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppStyles.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            schedule['time'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primaryColor,
                            ),
                          ),
                        ),
                        title: Text(
                          schedule['subject'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Kelas ${schedule['class']} - Ruang ${schedule['room']}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Detail jadwal
                        },
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudentSchedule() {
    // Dummy data untuk jadwal pelajaran siswa
    final List<Map<String, dynamic>> classSchedule = [
      {
        'time': '07:00 - 07:45',
        'subject': 'Upacara',
        'teacher': '-',
        'room': 'Lapangan',
      },
      {
        'time': '07:45 - 09:15',
        'subject': 'Bahasa Indonesia',
        'teacher': 'Budi Santoso',
        'room': 'R101',
      },
      {
        'time': '09:15 - 09:30',
        'subject': 'Istirahat',
        'teacher': '-',
        'room': '-',
      },
      {
        'time': '09:30 - 11:00',
        'subject': 'Matematika',
        'teacher': 'Siti Aminah',
        'room': 'R101',
      },
      {
        'time': '11:00 - 12:30',
        'subject': 'IPA',
        'teacher': 'Ahmad Hidayat',
        'room': 'Lab IPA',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jadwal Hari Ini - Senin', style: AppStyles.headingMedium),
            StatusBadge(label: 'Kelas 10A', color: AppStyles.statusInfo),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: classSchedule.length,
            itemBuilder: (context, index) {
              final schedule = classSchedule[index];
              final bool isBreak =
                  schedule['subject'] == 'Istirahat' ||
                  schedule['subject'] == 'Upacara';

              return CustomCard(
                margin: const EdgeInsets.only(bottom: 12),
                gradient:
                    isBreak
                        ? LinearGradient(
                          colors: [
                            AppStyles.accentColor.withOpacity(0.1),
                            AppStyles.accentColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isBreak
                                  ? AppStyles.accentColor.withOpacity(0.2)
                                  : AppStyles.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          schedule['time'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color:
                                isBreak
                                    ? AppStyles.accentColor
                                    : AppStyles.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    schedule['subject'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    isBreak
                        ? ''
                        : 'Pengajar: ${schedule['teacher']} - Ruang ${schedule['room']}',
                  ),
                  trailing:
                      isBreak
                          ? null
                          : const Icon(Icons.notes, color: Colors.grey),
                  onTap:
                      isBreak
                          ? null
                          : () {
                            // Detail jadwal
                          },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return Center(
      child: CustomCard(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: AppStyles.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text("Fitur Jadwal Kelas", style: AppStyles.headingMedium),
            const SizedBox(height: 8),
            Text(
              "Fitur ini hanya tersedia untuk Guru dan Siswa",
              style: AppStyles.captionText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              "Anda dapat melihat jadwal kelas dan pelajaran sesuai dengan role Anda. "
              "Guru dapat melihat jadwal mengajar, sementara siswa dapat melihat jadwal pelajaran.",
              style: AppStyles.bodyText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
