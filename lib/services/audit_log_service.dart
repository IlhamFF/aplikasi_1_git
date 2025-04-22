import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/collection_constants.dart';

class AuditLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logActivity(
    String userId,
    String action,
    String description,
  ) async {
    try {
      await _firestore.collection(Collections.auditLogs).add({
        'userId': userId,
        'action': action,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'ipAddress': '', // Bisa diisi jika diperlukan
        'userAgent': '', // Bisa diisi jika diperlukan
      });
    } catch (e) {
      print('Error logging activity: $e');
      // Tidak throw exception agar tidak mengganggu flow utama
    }
  }

  Future<List<Map<String, dynamic>>> getActivityLogs({
    String? userId,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    try {
      Query query = _firestore
          .collection(Collections.auditLogs)
          .orderBy('timestamp', descending: true);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (action != null) {
        query = query.where('action', isEqualTo: action);
      }

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      query = query.limit(limit);

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'userId': data['userId'] ?? '',
          'action': data['action'] ?? '',
          'description': data['description'] ?? '',
          'timestamp':
              data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate()
                  : DateTime.now(),
          'ipAddress': data['ipAddress'] ?? '',
          'userAgent': data['userAgent'] ?? '',
        };
      }).toList();
    } catch (e) {
      throw Exception('Gagal mendapatkan log aktivitas: $e');
    }
  }
}
