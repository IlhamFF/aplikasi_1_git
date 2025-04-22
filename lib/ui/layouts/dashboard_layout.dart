import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/sidebar.dart';
import '../components/custom_app_bar.dart';
import '../../providers/user_session_provider.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const DashboardLayout({
    Key? key,
    required this.child,
    required this.title,
    this.actions,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 1000;
    final bool isMediumScreen = screenWidth > 600 && screenWidth <= 1000;

    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        actions: actions,
        showMenuButton: !isLargeScreen,
      ),
      drawer: !isLargeScreen ? Sidebar() : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar untuk layar besar
            if (isLargeScreen) Sidebar(),

            // Konten utama
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(isMediumScreen ? 16.0 : 24.0),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
