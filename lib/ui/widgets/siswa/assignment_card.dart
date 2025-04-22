import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignmentCard extends StatelessWidget {
  final String id;
  final String title;
  final String subject;
  final String teacher;
  final DateTime dueDate;
  final AssignmentStatus status;
  final double? score;
  final VoidCallback onTap;

  const AssignmentCard({
    Key? key,
    required this.id,
    required this.title,
    required this.subject,
    required this.teacher,
    required this.dueDate,
    required this.status,
    this.score,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOverdue =
        status == AssignmentStatus.notSubmitted &&
        DateTime.now().isAfter(dueDate);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        status,
                        isOverdue,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusText(status, isOverdue),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(status, isOverdue),
                      ),
                    ),
                  ),
                  if (score != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getScoreColor(score!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Nilai: ${score!.round()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(score!),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Subject and teacher
              Row(
                children: [
                  Icon(Icons.book, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(subject, style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(width: 16),
                  Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(teacher, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
              const SizedBox(height: 16),

              // Due date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tenggat: ${DateFormat('dd MMM yyyy, HH:mm').format(dueDate)}',
                    style: TextStyle(
                      color: isOverdue ? Colors.red : Colors.grey.shade700,
                      fontWeight:
                          isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),

              // Remaining time for not submitted assignments
              if (status == AssignmentStatus.notSubmitted && !isOverdue)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Sisa waktu: ${_getRemainingTime(dueDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(AssignmentStatus status, bool isOverdue) {
    if (isOverdue) return Colors.red;

    switch (status) {
      case AssignmentStatus.notSubmitted:
        return Colors.orange;
      case AssignmentStatus.submitted:
        return Colors.blue;
      case AssignmentStatus.graded:
        return Colors.green;
    }
  }

  String _getStatusText(AssignmentStatus status, bool isOverdue) {
    if (isOverdue) return 'Terlambat';

    switch (status) {
      case AssignmentStatus.notSubmitted:
        return 'Belum Dikumpulkan';
      case AssignmentStatus.submitted:
        return 'Sudah Dikumpulkan';
      case AssignmentStatus.graded:
        return 'Sudah Dinilai';
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getRemainingTime(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit';
    } else {
      return 'Kurang dari 1 menit';
    }
  }
}

enum AssignmentStatus { notSubmitted, submitted, graded }
