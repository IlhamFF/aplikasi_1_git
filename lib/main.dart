import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// Firebase
import 'services/firebase_options.dart';

// Models (Tambahkan ini)
import 'models/user_model.dart';
import 'models/class_model.dart';
import 'models/subject_model.dart';
import 'models/schedule_model.dart';

// Constants (Tambahkan ini)
import 'constants/collection_constants.dart';

// Providers
import 'providers/user_session_provider.dart';

// Services
import 'services/firestore_service.dart';
import 'services/auth_service.dart';
import 'services/audit_log_service.dart'; // Tambahkan ini

// Theme
import 'ui/theme/app_theme.dart';

// Pages
import '/features/auth/auth_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/profile/profile_page.dart';
import 'features/profile/profile_update_page.dart';
import 'features/manage_users/manage_users_page.dart';
import 'features/manage_students/manage_students_page.dart';
import 'features/class_schedule/class_schedules_page.dart';

// Routes
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Mengatasi masalah Windows dengan Firestore
  if (Platform.isWindows) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        // Tambahkan provider lain di sini
      ],
      child: const MyApp(),
    ),
  );
}

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Run the app
    runApp(const MyApp());
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize Firebase',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserSessionProvider()),
      ],
      child: MaterialApp(
        title: 'Aplikasi Akademik Sekolah',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(),
        home: const AuthWrapper(),
        routes: {
          AppRoutes.auth: (context) => const AuthPage(),
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.register: (context) => const RegisterPage(),
          AppRoutes.dashboard: (context) => const DashboardPage(),
          AppRoutes.profile: (context) => const ProfilePage(),
          AppRoutes.profileEdit: (context) => const ProfileUpdatePage(),
          AppRoutes.manageUsers: (context) => const ManageUsersPage(),
          AppRoutes.manageStudents: (context) => const ManageStudentsPage(),
          AppRoutes.classSchedules: (context) => const ClassSchedulesPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final userSession = Provider.of<UserSessionProvider>(
      context,
      listen: false,
    );

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Show error if there's an auth error
        if (snapshot.hasError) {
          print('Auth error: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Authentication Error',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      userSession.clearUser();
                    },
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        // If user is logged in
        if (snapshot.hasData) {
          final user = snapshot.data!;

          // Get user data from Firestore
          return FutureBuilder<Map<String, dynamic>?>(
            future: firestoreService.getUser(user.uid),
            builder: (context, userSnapshot) {
              // Show loading indicator while fetching user data
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If user data exists, set user session and navigate to dashboard
              if (userSnapshot.hasData && userSnapshot.data != null) {
                final userData = userSnapshot.data!;

                // Set user session
                userSession.setUser(
                  user.uid,
                  userData['nama'] ?? 'Pengguna',
                  userData['id_level_user'] ?? 'S',
                  userData['id_unik'] ?? '',
                );

                // Navigate to dashboard
                return const DashboardPage();
              }

              // If user data doesn't exist, log out and show login page
              print('User data not found for UID: ${user.uid}');
              FirebaseAuth.instance.signOut();
              userSession.clearUser();
              return const LoginPage();
            },
          );
        }

        // If user is not logged in, show auth page
        userSession.clearUser();
        return const AuthPage();
      },
    );
  }
}
