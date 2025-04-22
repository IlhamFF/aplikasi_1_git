import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentCard extends StatelessWidget {
  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  final PaymentStatus status;
  final DateTime? paymentDate;
  final String? paymentMethod;
  final String? receiptNumber;
  final VoidCallback onPay;
  final VoidCallback onViewDetail;

  const PaymentCard({
    Key? key,
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.paymentDate,
    this.paymentMethod,
    this.receiptNumber,
    required this.onPay,
    required this.onViewDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final bool isOverdue =
        status == PaymentStatus.unpaid && DateTime.now().isAfter(dueDate);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getStatusColor(status, isOverdue).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: $id',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status, isOverdue).withOpacity(0.2),
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
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      currencyFormat.format(amount),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
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
                      'Jatuh tempo: ${DateFormat('dd MMM yyyy').format(dueDate)}',
                      style: TextStyle(
                        color: isOverdue ? Colors.red : Colors.grey.shade700,
                        fontWeight:
                            isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),

                // Payment details if paid
                if (status == PaymentStatus.paid && paymentDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'Informasi Pembayaran',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Bayar',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy',
                                    ).format(paymentDate!),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            if (paymentMethod != null)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Metode Pembayaran',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      paymentMethod!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if (receiptNumber != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nomor Kwitansi',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  receiptNumber!,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
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
                  onPressed: onViewDetail,
                  child: Text('Lihat Detail'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                if (status == PaymentStatus.unpaid)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: onPay,
                      child: Text('Bayar Sekarang'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status, bool isOverdue) {
    if (isOverdue) return Colors.red;

    switch (status) {
      case PaymentStatus.unpaid:
        return Colors.orange;
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.partial:
        return Colors.blue;
    }
  }

  String _getStatusText(PaymentStatus status, bool isOverdue) {
    if (isOverdue) return 'Terlambat';

    switch (status) {
      case PaymentStatus.unpaid:
        return 'Belum Dibayar';
      case PaymentStatus.paid:
        return 'Lunas';
      case PaymentStatus.partial:
        return 'Bayar Sebagian';
    }
  }
}

enum PaymentStatus { unpaid, paid, partial }
