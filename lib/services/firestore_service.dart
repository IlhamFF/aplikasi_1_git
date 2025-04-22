import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/class_model.dart';
import '../models/subject_model.dart';
import '../models/schedule_model.dart';
import '../constants/collection_constants.dart';
import 'audit_log_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuditLogService _auditLogService = AuditLogService();

  // CRUD Pengguna
  Future<List<UserModel>> getUsers({String? role}) async {
    try {
      Query query = _firestore.collection(Collections.users);

      if (role != null) {
        query = query.where('role', isEqualTo: role);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) => UserModel.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'uid': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mendapatkan daftar pengguna: $e');
    }
  }

  Future<UserModel> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection(Collections.users).doc(uid).get();

      if (!doc.exists) {
        throw Exception('Pengguna tidak ditemukan');
      }

      return UserModel.fromJson({...doc.data()!, 'uid': doc.id});
    } catch (e) {
      throw Exception('Gagal mendapatkan data pengguna: $e');
    }
  }

  Future<void> updateUser(
    String uid,
    Map<String, dynamic> data,
    String actorId,
  ) async {
    try {
      await _firestore.collection(Collections.users).doc(uid).update(data);

      // Catat aktivitas update
      await _auditLogService.logActivity(
        actorId,
        'Update Pengguna',
        'Memperbarui data pengguna $uid',
      );
    } catch (e) {
      throw Exception('Gagal memperbarui data pengguna: $e');
    }
  }

  Future<void> deleteUser(String uid, String actorId) async {
    try {
      // Hapus data pengguna dari Firestore
      await _firestore.collection(Collections.users).doc(uid).delete();

      // Hapus detail pengguna
      await _firestore.collection(Collections.userDetails).doc(uid).delete();

      // Catat aktivitas penghapusan
      await _auditLogService.logActivity(
        actorId,
        'Hapus Pengguna',
        'Menghapus pengguna $uid',
      );
    } catch (e) {
      throw Exception('Gagal menghapus pengguna: $e');
    }
  }

  // CRUD Kelas
  Future<List<ClassModel>> getClasses() async {
    try {
      final snapshot = await _firestore.collection(Collections.classes).get();

      return snapshot.docs
          .map(
            (doc) => ClassModel.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mendapatkan daftar kelas: $e');
    }
  }

  Future<ClassModel> getClassById(String id) async {
    try {
      final doc =
          await _firestore.collection(Collections.classes).doc(id).get();

      if (!doc.exists) {
        throw Exception('Kelas tidak ditemukan');
      }

      return ClassModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Gagal mendapatkan data kelas: $e');
    }
  }

  Future<void> addClass(ClassModel classModel, String actorId) async {
    try {
      await _firestore
          .collection(Collections.classes)
          .doc(classModel.id)
          .set(classModel.toJson());

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Tambah Kelas',
        'Menambahkan kelas baru: ${classModel.name}',
      );
    } catch (e) {
      throw Exception('Gagal menambahkan kelas: $e');
    }
  }

  Future<void> updateClass(ClassModel classModel, String actorId) async {
    try {
      await _firestore
          .collection(Collections.classes)
          .doc(classModel.id)
          .update(classModel.toJson());

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Update Kelas',
        'Memperbarui kelas: ${classModel.name}',
      );
    } catch (e) {
      throw Exception('Gagal memperbarui kelas: $e');
    }
  }

  Future<void> deleteClass(String id, String actorId) async {
    try {
      await _firestore.collection(Collections.classes).doc(id).delete();

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Hapus Kelas',
        'Menghapus kelas dengan ID: $id',
      );
    } catch (e) {
      throw Exception('Gagal menghapus kelas: $e');
    }
  }

  // CRUD Mata Pelajaran
  Future<List<SubjectModel>> getSubjects() async {
    try {
      final snapshot = await _firestore.collection(Collections.subjects).get();

      return snapshot.docs
          .map(
            (doc) => SubjectModel.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mendapatkan daftar mata pelajaran: $e');
    }
  }

  Future<SubjectModel> getSubjectById(String id) async {
    try {
      final doc =
          await _firestore.collection(Collections.subjects).doc(id).get();

      if (!doc.exists) {
        throw Exception('Mata pelajaran tidak ditemukan');
      }

      return SubjectModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Gagal mendapatkan data mata pelajaran: $e');
    }
  }

  Future<void> addSubject(SubjectModel subject, String actorId) async {
    try {
      await _firestore
          .collection(Collections.subjects)
          .doc(subject.id)
          .set(subject.toJson());

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Tambah Mata Pelajaran',
        'Menambahkan mata pelajaran baru: ${subject.name}',
      );
    } catch (e) {
      throw Exception('Gagal menambahkan mata pelajaran: $e');
    }
  }

  Future<void> updateSubject(SubjectModel subject, String actorId) async {
    try {
      await _firestore
          .collection(Collections.subjects)
          .doc(subject.id)
          .update(subject.toJson());

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Update Mata Pelajaran',
        'Memperbarui mata pelajaran: ${subject.name}',
      );
    } catch (e) {
      throw Exception('Gagal memperbarui mata pelajaran: $e');
    }
  }

  Future<void> deleteSubject(String id, String actorId) async {
    try {
      await _firestore.collection(Collections.subjects).doc(id).delete();

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Hapus Mata Pelajaran',
        'Menghapus mata pelajaran dengan ID: $id',
      );
    } catch (e) {
      throw Exception('Gagal menghapus mata pelajaran: $e');
    }
  }

  // CRUD Jadwal
  Future<List<ScheduleModel>> getSchedules({
    String? classId,
    String? teacherId,
  }) async {
    try {
      Query query = _firestore.collection(Collections.schedules);

      if (classId != null) {
        query = query.where('classId', isEqualTo: classId);
      }

      if (teacherId != null) {
        query = query.where('teacherId', isEqualTo: teacherId);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) => ScheduleModel.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mendapatkan daftar jadwal: $e');
    }
  }

  Future<void> addSchedule(ScheduleModel schedule, String actorId) async {
    try {
      await _firestore
          .collection(Collections.schedules)
          .doc(schedule.id)
          .set(schedule.toJson());

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Tambah Jadwal',
        'Menambahkan jadwal baru untuk kelas dan mata pelajaran',
      );
    } catch (e) {
      throw Exception('Gagal menambahkan jadwal: $e');
    }
  }

  Future<void> updateSchedule(ScheduleModel schedule, String actorId) async {
    try {
      await _firestore
          .collection(Collections.schedules)
          .doc(schedule.id)
          .update(schedule.toJson());

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Update Jadwal',
        'Memperbarui jadwal',
      );
    } catch (e) {
      throw Exception('Gagal memperbarui jadwal: $e');
    }
  }

  Future<void> deleteSchedule(String id, String actorId) async {
    try {
      await _firestore.collection(Collections.schedules).doc(id).delete();

      // Catat aktivitas
      await _auditLogService.logActivity(
        actorId,
        'Hapus Jadwal',
        'Menghapus jadwal dengan ID: $id',
      );
    } catch (e) {
      throw Exception('Gagal menghapus jadwal: $e');
    }
  }
}
