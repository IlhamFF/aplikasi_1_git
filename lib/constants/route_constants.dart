/// Konstanta untuk semua rute aplikasi
/// Digunakan untuk navigasi dan definisi rute
class RouteConstants {
  // Auth routes
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String notifications = '/notifications';

  // Admin routes
  static const String manageUsers = '/manage-users';
  static const String manageUsersAdd = '/manage-users/add';
  static const String manageUsersEdit = '/manage-users/edit';
  static const String manageUsersDetail = '/manage-users/detail';
  static const String auditLog = '/audit-log';
  static const String masterData = '/master-data';
  static const String backup = '/backup';

  // Teacher routes
  static const String myClasses = '/my-classes';
  static const String myClassesDetail = '/my-classes/detail';
  static const String assessments = '/assessments';
  static const String assessmentsAdd = '/assessments/add';
  static const String assessmentsEdit = '/assessments/edit';
  static const String teachingSchedule = '/teaching-schedule';
  static const String communication = '/communication';

  // Staff routes
  static const String schoolData = '/school-data';
  static const String manageStudents = '/manage-students';
  static const String manageStudentsAdd = '/manage-students/add';
  static const String manageStudentsEdit = '/manage-students/edit';
  static const String manageStudentsDetail = '/manage-students/detail';
  static const String finance = '/finance';
  static const String financePayment = '/finance/payment';
  static const String financeReport = '/finance/report';
  static const String letters = '/letters';
  static const String inventory = '/inventory';

  // Principal routes
  static const String schoolReports = '/school-reports';
  static const String teacherPerformance = '/teacher-performance';
  static const String approvals = '/approvals';
  static const String approvalsDetail = '/approvals/detail';

  // Student routes
  static const String classSchedules = '/class-schedules';
  static const String grades = '/grades';
  static const String assignments = '/assignments';
  static const String assignmentsDetail = '/assignments/detail';
  static const String assignmentsSubmit = '/assignments/submit';
  static const String attendance = '/attendance';

  // Shared routes
  static const String eLearning = '/e-learning';
  static const String eLearningDetail = '/e-learning/detail';
  static const String eLearningMaterial = '/e-learning/material';
  static const String settings = '/settings';
  static const String help = '/help';

  // Error routes
  static const String notFound = '/404';
  static const String unauthorized = '/401';
  static const String serverError = '/500';

  // Utility method to get route name from path
  static String getRouteName(String path) {
    final Map<String, String> routeNames = {
      splash: 'Splash Screen',
      auth: 'Autentikasi',
      login: 'Login',
      register: 'Registrasi',
      forgotPassword: 'Lupa Password',
      dashboard: 'Dashboard',
      profile: 'Profil',
      profileEdit: 'Edit Profil',
      notifications: 'Notifikasi',
      manageUsers: 'Kelola Pengguna',
      manageUsersAdd: 'Tambah Pengguna',
      manageUsersEdit: 'Edit Pengguna',
      manageUsersDetail: 'Detail Pengguna',
      auditLog: 'Audit Log',
      masterData: 'Master Data',
      backup: 'Backup Database',
      myClasses: 'Kelas Saya',
      myClassesDetail: 'Detail Kelas',
      assessments: 'Penilaian',
      assessmentsAdd: 'Tambah Penilaian',
      assessmentsEdit: 'Edit Penilaian',
      teachingSchedule: 'Jadwal Mengajar',
      communication: 'Komunikasi',
      schoolData: 'Data Sekolah',
      manageStudents: 'Kelola Siswa',
      manageStudentsAdd: 'Tambah Siswa',
      manageStudentsEdit: 'Edit Siswa',
      manageStudentsDetail: 'Detail Siswa',
      finance: 'Keuangan',
      financePayment: 'Pembayaran',
      financeReport: 'Laporan Keuangan',
      letters: 'Surat-Menyurat',
      inventory: 'Inventaris',
      schoolReports: 'Laporan Sekolah',
      teacherPerformance: 'Kinerja Guru',
      approvals: 'Persetujuan',
      approvalsDetail: 'Detail Persetujuan',
      classSchedules: 'Jadwal Kelas',
      grades: 'Nilai',
      assignments: 'Tugas',
      assignmentsDetail: 'Detail Tugas',
      assignmentsSubmit: 'Kumpulkan Tugas',
      attendance: 'Absensi',
      eLearning: 'E-Learning',
      eLearningDetail: 'Detail E-Learning',
      eLearningMaterial: 'Materi E-Learning',
      settings: 'Pengaturan',
      help: 'Bantuan',
      notFound: 'Halaman Tidak Ditemukan',
      unauthorized: 'Tidak Memiliki Akses',
      serverError: 'Kesalahan Server',
    };

    return routeNames[path] ?? 'Unknown Route';
  }
}
