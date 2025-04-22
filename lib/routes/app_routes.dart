class AppRoutes {
  // Auth routes
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';

  // Main routes
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit'; // Ditambahkan
  static const String notifications = '/notifications';

  // Admin routes
  static const String manageUsers = '/manage-users';
  static const String manageStudents = '/manage-students'; // Ditambahkan
  static const String auditLog = '/audit-log';
  static const String masterData = '/master-data';
  static const String backup = '/backup';

  // Teacher routes
  static const String myClasses = '/my-classes';
  static const String assessments = '/assessments';
  static const String teachingSchedule = '/teaching-schedule';
  static const String communication = '/communication';

  // Staff routes
  static const String schoolData = '/school-data';
  static const String finance = '/finance';
  static const String letters = '/letters';
  static const String inventory = '/inventory';

  // Principal routes
  static const String schoolReports = '/school-reports';
  static const String teacherPerformance = '/teacher-performance';
  static const String approvals = '/approvals';

  // Student routes
  static const String classSchedules = '/class-schedules';
  static const String grades = '/grades';
  static const String assignments = '/assignments';
  static const String attendance = '/attendance';

  // Shared routes
  static const String eLearning = '/e-learning';
}
