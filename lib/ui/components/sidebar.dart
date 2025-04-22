import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles/app_styles.dart';
import '../../services/auth_service.dart';
import '../../providers/user_session_provider.dart';
import '../../features/auth/login_page.dart';
import '../../features/manage_users/manage_users_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../constants/role_constants.dart'; // Tambahkan ini
import '../../models/user_model.dart'; // Tambahkan ini

class Sidebar extends StatelessWidget {
  final String activeMenu;

  const Sidebar({Key? key, required this.activeMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final authService = AuthService();
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppStyles.primaryColor),
              child: Image.asset('assets/logo.png', height: 50),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            if (userSession.idLevelUser == 'A')
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text("Kelola Pengguna"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageUsersPage(),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await authService.signOut();
                userSession.clearUser();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      );
    }

    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset('assets/logo.png', height: 50),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          if (userSession.idLevelUser == 'A')
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Kelola Pengguna"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageUsersPage(),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await authService.signOut();
              userSession.clearUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
