import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuditLogTable extends StatelessWidget {
  final List<AuditLogItem> logs;
  final bool isLoading;
  final Function()? onRefresh;
  final Function(String)? onUserClick;

  const AuditLogTable({
    Key? key,
    required this.logs,
    this.isLoading = false,
    this.onRefresh,
    this.onUserClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Log Aktivitas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: isLoading ? null : onRefresh,
                ),
              ],
            ),
          ),

          const Divider(height: 0),

          // Table Header
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Waktu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Pengguna',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Aktivitas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Table Content
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (logs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Tidak ada data log aktivitas'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final log = logs[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          DateFormat('dd/MM/yy HH:mm').format(log.timestamp),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap:
                              onUserClick != null
                                  ? () => onUserClick!(log.userId)
                                  : null,
                          child: Text(
                            log.userName,
                            style: TextStyle(
                              fontSize: 14,
                              color: onUserClick != null ? Colors.blue : null,
                              decoration:
                                  onUserClick != null
                                      ? TextDecoration.underline
                                      : null,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getActionColor(log.action),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            log.action,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          log.description,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Pagination (optional)
          if (logs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text('Showing ${logs.length} entries')],
              ),
            ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Colors.green;
      case 'logout':
        return Colors.orange;
      case 'create':
      case 'tambah':
        return Colors.blue;
      case 'update':
      case 'edit':
        return Colors.amber;
      case 'delete':
      case 'hapus':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class AuditLogItem {
  final String id;
  final String userId;
  final String userName;
  final String action;
  final String description;
  final DateTime timestamp;

  AuditLogItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.description,
    required this.timestamp,
  });
}
