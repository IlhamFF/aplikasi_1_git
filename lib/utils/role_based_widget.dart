import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_session_provider.dart'; // Tambahkan ini
import '../constants/role_constants.dart'; // Tambahkan ini

class RoleBasedWidget extends StatelessWidget {
  final String currentRole;
  final Widget adminWidget;
  final Widget teacherWidget;
  final Widget staffWidget;
  final Widget principalWidget;
  final Widget studentWidget;
  final Widget defaultWidget;

  const RoleBasedWidget({
    Key? key,
    required this.currentRole,
    this.adminWidget = const SizedBox(),
    this.teacherWidget = const SizedBox(),
    this.staffWidget = const SizedBox(),
    this.principalWidget = const SizedBox(),
    this.studentWidget = const SizedBox(),
    this.defaultWidget = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (currentRole) {
      case 'A':
        return adminWidget;
      case 'G':
        return teacherWidget;
      case 'T':
        return staffWidget;
      case 'K':
        return principalWidget;
      case 'S':
        return studentWidget;
      default:
        return defaultWidget;
    }
  }
}
