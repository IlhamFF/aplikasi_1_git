import 'package:flutter/material.dart';

class ClassScheduleCard extends StatelessWidget {
  final String subject;
  final String teacher;
  final String classRoom;
  final String startTime;
  final String endTime;
  final String day;
  final bool isActive;
  final VoidCallback? onTap;

  const ClassScheduleCard({
    Key? key,
    required this.subject,
    required this.teacher,
    required this.classRoom,
    required this.startTime,
    required this.endTime,
    required this.day,
    this.isActive = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isActive ? Theme.of(context).primaryColor : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? Colors.white.withOpacity(0.2)
                              : Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$startTime - $endTime',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            isActive
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subject
              Text(
                subject,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : null,
                ),
              ),
              const SizedBox(height: 8),

              // Teacher
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: isActive ? Colors.white70 : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    teacher,
                    style: TextStyle(
                      color: isActive ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Class room
              Row(
                children: [
                  Icon(
                    Icons.room,
                    size: 16,
                    color: isActive ? Colors.white70 : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    classRoom,
                    style: TextStyle(
                      color: isActive ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),

              // Status indicator for active class
              if (isActive)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sedang Berlangsung',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
