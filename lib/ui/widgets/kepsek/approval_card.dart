                  ),
                ),
                const SizedBox(height: 16),
                
                // Requester info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        requesterName.isNotEmpty ? requesterName[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          requesterName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          requesterRole,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      'Diajukan: ${DateFormat('dd MMM yyyy').format(requestDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                
                // Attachments
                if (attachments != null && attachments!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lampiran:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...attachments!.map((attachment) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_file,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                attachment,
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onView,
                  child: Text('Lihat Detail'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 8),
                if (status == ApprovalStatus.pending) ...[
                  OutlinedButton(
                    onPressed: onReject,
                    child: Text('Tolak'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      foregroundColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onApprove,
                    child: Text('Setujui'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.pending:
        return Colors.orange;
      case ApprovalStatus.approved:
        return Colors.green;
      case ApprovalStatus.rejected:
        return Colors.red;
    }
  }
  
  String _getStatusText(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.pending:
        return 'Menunggu Persetujuan';
      case ApprovalStatus.approved:
        return 'Disetujui';
      case ApprovalStatus.rejected:
        return 'Ditolak';
    }
  }
}

enum ApprovalStatus {
  pending,
  approved,
  rejected,
}