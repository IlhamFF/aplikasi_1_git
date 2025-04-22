import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/components/custom_card.dart';
import '../../../ui/components/custom_app_bar.dart';
import '../../../ui/components/animated_card.dart';
import '../../../ui/components/sidebar.dart';
import '../../../ui/components/custom_search_bar.dart';
import '../../../ui/components/custom_tab.dart';
import '../../../ui/styles/app_styles.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../providers/user_session_provider.dart';
import '../../../utils/role_based_widget.dart';
import '../../../constants/role_constants.dart';
import '../../../models/user_model.dart'; // Tambahkan ini
import '../../../constants/collection_constants.dart'; // Tambahkan ini

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All', 'To do', 'In progress', 'Done'];

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSessionProvider>(context);
    final String role = userSession.idLevelUser ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          const Sidebar(activeMenu: '/dashboard'),
          Expanded(
            child: Container(
              color: AppTheme.isDarkMode ? AppStyles.bgDark : AppStyles.bgLight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main content area
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(userSession),
                          const SizedBox(height: 24),

                          // Summary cards
                          _buildSummaryCards(role),
                          const SizedBox(height: 32),

                          // Task overview section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Task Overview',
                                style: AppStyles.headingMedium,
                              ),
                              CustomTabBar(
                                tabs: _tabs,
                                selectedIndex: _selectedTabIndex,
                                onTabSelected: (index) {
                                  setState(() {
                                    _selectedTabIndex = index;
                                  });
                                },
                                height: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Task cards
                          _buildTaskCards(role),
                          const SizedBox(height: 32),

                          // Active projects section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Active Projects',
                                style: AppStyles.headingMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  // See all projects
                                },
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    color: AppStyles.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Project cards
                          _buildProjectCards(role),
                        ],
                      ),
                    ),
                  ),

                  // Right sidebar
                  if (MediaQuery.of(context).size.width > 1200)
                    Container(
                      width: 300,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.isDarkMode
                                ? AppStyles.bgCard
                                : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Team members
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Team Members',
                                style: AppStyles.headingMedium.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  // Add team member
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTeamMembers(),
                          const SizedBox(height: 24),

                          // Premium account card
                          CustomCard(
                            gradient: AppStyles.accentGradient,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      'assets/images/rocket.png',
                                      height: 80,
                                    ),
                                  ],
                                ),
                                Text(
                                  'Get Premium Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'To add more members',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Upgrade account
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppStyles.accentColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Upgrade Now'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Recent messages
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Messages',
                                style: AppStyles.headingMedium.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  // More options
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildRecentMessages(),
                        ],
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

  Widget _buildHeader(UserSessionProvider userSession) {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, ${userSession.nama ?? "User"}',
              style: AppStyles.headingLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Today, ${now.day} ${_getMonthName(now.month)} ${now.year}',
              style: AppStyles.captionText,
            ),
          ],
        ),
        SizedBox(
          width: 300,
          child: CustomSearchBar(
            hintText: 'Search...',
            onChanged: (value) {
              // Handle search
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(String role) {
    return RoleBasedWidget(
      currentRole: role,
      adminWidget: _buildAdminSummary(),
      teacherWidget: _buildTeacherSummary(),
      staffWidget: _buildStaffSummary(),
      principalWidget: _buildPrincipalSummary(),
      studentWidget: _buildStudentSummary(),
      defaultWidget: _buildDefaultSummary(),
    );
  }

  Widget _buildAdminSummary() {
    return Row(
      children: [
        Expanded(
          child: AnimatedCard(
            child: CustomCard(
              gradient: AppStyles.primaryGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You Have 10 Pending Tasks',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.task_alt, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2 tasks are in progress',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Check tasks
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppStyles.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Check'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: AnimatedCard(
            delay: const Duration(milliseconds: 100),
            child: CustomCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Sprint',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppStyles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '3 Task Done',
                          style: TextStyle(
                            color: AppStyles.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '2 New Task',
                          style: TextStyle(
                            color: AppStyles.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppStyles.primaryColor.withOpacity(0.2),
                        width: 8,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '30%',
                            style: TextStyle(
                              color: AppStyles.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              color: AppStyles.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherSummary() {
    // Similar to _buildAdminSummary but with teacher-specific data
    return _buildAdminSummary();
  }

  Widget _buildStaffSummary() {
    // Similar to _buildAdminSummary but with staff-specific data
    return _buildAdminSummary();
  }

  Widget _buildPrincipalSummary() {
    // Similar to _buildAdminSummary but with principal-specific data
    return _buildAdminSummary();
  }

  Widget _buildStudentSummary() {
    // Similar to _buildAdminSummary but with student-specific data
    return _buildAdminSummary();
  }

  Widget _buildDefaultSummary() {
    // Default summary for unknown roles
    return _buildAdminSummary();
  }

  Widget _buildTaskCards(String role) {
    // Sample task data
    final List<Map<String, dynamic>> tasks = [
      {
        'title': 'Landing page UI Design',
        'dueDate': 'Due in 2 days',
        'status': 'todo',
        'assignees': ['A', 'B', 'C'],
        'comments': 18,
        'attachments': 23,
      },
      {
        'title': 'Landing page UI Design',
        'dueDate': 'Due in 1 days',
        'status': 'in_progress',
        'assignees': ['D', 'E', 'F'],
        'comments': 15,
        'attachments': 34,
      },
      {
        'title': 'Landing page UI Design',
        'dueDate': 'Due in today',
        'status': 'done',
        'assignees': ['G', 'H', 'I'],
        'comments': 12,
        'attachments': 36,
      },
    ];

    // Filter tasks based on selected tab
    List<Map<String, dynamic>> filteredTasks = [];
    if (_selectedTabIndex == 0) {
      filteredTasks = tasks;
    } else if (_selectedTabIndex == 1) {
      filteredTasks = tasks.where((task) => task['status'] == 'todo').toList();
    } else if (_selectedTabIndex == 2) {
      filteredTasks =
          tasks.where((task) => task['status'] == 'in_progress').toList();
    } else if (_selectedTabIndex == 3) {
      filteredTasks = tasks.where((task) => task['status'] == 'done').toList();
    }

    return Row(
      children:
          filteredTasks.map((task) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AnimatedCard(
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getStatusColor(task['status']),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  task['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppStyles.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: AppStyles.textSecondary,
                              ),
                              onPressed: () {
                                // Show task options
                              },
                            ),
                          ],
                        ),
                        Text(
                          task['dueDate'],
                          style: TextStyle(
                            color: AppStyles.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              task['status'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _getStatusText(task['status']),
                            style: TextStyle(
                              color: _getStatusColor(task['status']),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Assignees
                            Row(
                              children: [
                                for (
                                  int i = 0;
                                  i < task['assignees'].length;
                                  i++
                                )
                                  Container(
                                    margin: EdgeInsets.only(
                                      right:
                                          i == task['assignees'].length - 1
                                              ? 0
                                              : -8,
                                    ),
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: _getAvatarColor(
                                        task['assignees'][i],
                                      ),
                                      child: Text(
                                        task['assignees'][i],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Task stats
                            Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  size: 16,
                                  color: AppStyles.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${task['comments']}',
                                  style: TextStyle(
                                    color: AppStyles.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.attach_file,
                                  size: 16,
                                  color: AppStyles.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${task['attachments']}',
                                  style: TextStyle(
                                    color: AppStyles.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildProjectCards(String role) {
    // Sample project data
    final List<Map<String, dynamic>> projects = [
      {
        'name': 'Taxi online',
        'releaseTime': 'Oct 21, 2023',
        'icon': Icons.local_taxi,
        'color': AppStyles.primaryColor,
      },
      {
        'name': 'E-movies mobile',
        'releaseTime': 'Nov 15, 2023',
        'icon': Icons.movie,
        'color': AppStyles.warningColor,
      },
      {
        'name': 'Video converter app',
        'releaseTime': 'Dec 1, 2023',
        'icon': Icons.video_library,
        'color': AppStyles.accentColor,
      },
    ];

    return Row(
      children:
          projects.map((project) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AnimatedCard(
                  child: CustomCard(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: project['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(project['icon'], color: project['color']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Release time: ',
                                    style: TextStyle(
                                      color: AppStyles.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppStyles.primaryColor.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      project['releaseTime'],
                                      style: TextStyle(
                                        color: AppStyles.primaryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTeamMembers() {
    // Sample team members
    final List<Map<String, dynamic>> members = [
      {'name': 'A', 'color': AppStyles.primaryColor},
      {'name': 'B', 'color': AppStyles.accentColor},
      {'name': 'C', 'color': AppStyles.warningColor},
      {'name': 'D', 'color': AppStyles.statusSuccess},
      {'name': 'E', 'color': AppStyles.statusError},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...members.map((member) {
          return CircleAvatar(
            radius: 20,
            backgroundColor: member['color'].withOpacity(0.2),
            child: Text(
              member['name'],
              style: TextStyle(
                color: member['color'],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
        CircleAvatar(
          radius: 20,
          backgroundColor: AppStyles.bgCard,
          child: Icon(Icons.add, color: AppStyles.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRecentMessages() {
    // Sample messages
    final List<Map<String, dynamic>> messages = [
      {
        'name': 'Samantha',
        'message': 'I added my new tasks',
        'time': '13m',
        'avatar': 'S',
        'color': AppStyles.accentColor,
        'isRead': false,
      },
      {
        'name': 'John',
        'message': 'well done john!',
        'time': '1h',
        'avatar': 'J',
        'color': AppStyles.primaryColor,
        'isRead': true,
      },
      {
        'name': 'Alexander Purwoto',
        'message': 'Am I doing it right?',
        'time': '2h',
        'avatar': 'A',
        'color': AppStyles.statusSuccess,
        'isRead': true,
      },
    ];

    return Column(
      children:
          messages.map((message) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: message['color'].withOpacity(0.2),
                    child: Text(
                      message['avatar'],
                      style: TextStyle(
                        color: message['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppStyles.textPrimary,
                          ),
                        ),
                        Text(
                          message['message'],
                          style: TextStyle(
                            color: AppStyles.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message['time'],
                        style: TextStyle(
                          color: AppStyles.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (!message['isRead'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStyles.accentColor,
                          ),
                        )
                      else
                        Icon(
                          Icons.check,
                          size: 16,
                          color: AppStyles.statusSuccess,
                        ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'todo':
        return AppStyles.statusError;
      case 'in_progress':
        return AppStyles.warningColor;
      case 'done':
        return AppStyles.statusSuccess;
      default:
        return AppStyles.statusInfo;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'todo':
        return 'Todo';
      case 'in_progress':
        return 'In Progress';
      case 'done':
        return 'Done';
      default:
        return 'Unknown';
    }
  }

  Color _getAvatarColor(String initial) {
    switch (initial) {
      case 'A':
        return AppStyles.primaryColor;
      case 'B':
        return AppStyles.accentColor;
      case 'C':
        return AppStyles.warningColor;
      case 'D':
        return AppStyles.statusSuccess;
      case 'E':
        return AppStyles.statusError;
      case 'F':
        return AppStyles.statusInfo;
      case 'G':
        return AppStyles.roleAdmin;
      case 'H':
        return AppStyles.roleGuru;
      case 'I':
        return AppStyles.roleTU;
      default:
        return Colors.grey;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
