import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatelessWidget {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final NotificationType type;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  
  const NotificationItem({
    Key? key,
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
    required this.onTap,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => onDismiss(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: isRead ? null : Theme.of(context).primaryColor.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon berdasarkan tipe notifikasi
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTypeIcon(type),
                  color: _getTypeColor(type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              // Konten notifikasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(time, locale: 'id'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Indikator belum dibaca
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.assignment:
        return Icons.assignment;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.grade:
        return Icons.grade;
      case NotificationType.attendance:
        return Icons.calendar_today;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.system:
        return Icons.info;
    }
  }
  
  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.assignment:
        return Colors.blue;
      case NotificationType.announcement:
        return Colors.purple;
      case NotificationType.grade:
        return Colors.green;
      case NotificationType.attendance:
        return Colors.orange;
      case NotificationType.message:
        return Colors.teal;
      case NotificationType.system:
        return Colors.red;
    }
  }
}

enum NotificationType {
  assignment,
  announcement,
  grade,
  attendance,
  message,
  system,
}