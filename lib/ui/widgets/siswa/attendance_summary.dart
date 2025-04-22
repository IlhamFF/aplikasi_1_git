import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceSummary extends StatelessWidget {
  final Map<AttendanceStatus, int> summary;
  final List<AttendanceRecord> recentRecords;
  final String studentName;
  final String classInfo;
  final String academicYear;
  final VoidCallback onViewAll;

  const AttendanceSummary({
    Key? key,
    required this.summary,
    required this.recentRecords,
    required this.studentName,
    required this.classInfo,
    required this.academicYear,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = summary.values.fold(0, (sum, count) => sum + count);
    final presentPercentage =
        total > 0 ? (summary[AttendanceStatus.present] ?? 0) / total * 100 : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Rekap Kehadiran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$classInfo - $academicYear',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Attendance pie chart visualization
            Row(
              children: [
                // Pie chart
                Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: presentPercentage / 100,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              presentPercentage >= 75
                                  ? Colors.green
                                  : presentPercentage >= 50
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${presentPercentage.round()}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hadir',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Summary stats
                Expanded(
                  child: Column(
                    children: [
                      _buildAttendanceStatRow(
                        context,
                        'Hadir',
                        summary[AttendanceStatus.present] ?? 0,
                        Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _buildAttendanceStatRow(
                        context,
                        'Sakit',
                        summary[AttendanceStatus.sick] ?? 0,
                        Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      _buildAttendanceStatRow(
                        context,
                        'Izin',
                        summary[AttendanceStatus.permission] ?? 0,
                        Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      _buildAttendanceStatRow(
                        context,
                        'Alfa',
                        summary[AttendanceStatus.absent] ?? 0,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(),
            ),

            // Recent attendance records
            Text(
              'Kehadiran Terbaru',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (recentRecords.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Belum ada data kehadiran',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recentRecords.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final record = recentRecords[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getStatusColor(record.status).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          _getStatusIcon(record.status),
                          color: _getStatusColor(record.status),
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      DateFormat('EEEE, dd MMM yyyy').format(record.date),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _getStatusText(record.status),
                      style: TextStyle(color: _getStatusColor(record.status)),
                    ),
                    trailing: Text(
                      record.subject,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  );
                },
              ),

            // View all button
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: OutlinedButton(
                  onPressed: onViewAll,
                  child: Text('Lihat Semua Kehadiran'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatRow(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
        Spacer(),
        Text(count.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.sick:
        return Colors.blue;
      case AttendanceStatus.permission:
        return Colors.orange;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.late:
        return Colors.amber;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.sick:
        return Icons.healing;
      case AttendanceStatus.permission:
        return Icons.event_note;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.late:
        return Icons.access_time;
    }
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Hadir';
      case AttendanceStatus.sick:
        return 'Sakit';
      case AttendanceStatus.permission:
        return 'Izin';
      case AttendanceStatus.absent:
        return 'Alfa';
      case AttendanceStatus.late:
        return 'Terlambat';
    }
  }
}

enum AttendanceStatus { present, sick, permission, absent, late }

class AttendanceRecord {
  final String id;
  final DateTime date;
  final AttendanceStatus status;
  final String subject;
  final String? note;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.status,
    required this.subject,
    this.note,
  });
}
