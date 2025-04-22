import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/user_model.dart';
import '/constants/role_constants.dart';
import '/constants/collection_constants.dart';
import 'audit_log_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuditLogService _auditLogService = AuditLogService();

  // Login dengan email dan password
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Login gagal');
      }

      // Dapatkan data pengguna dari Firestore
      final userDoc =
          await _firestore
              .collection(Collections.users)
              .doc(userCredential.user!.uid)
              .get();

      if (!userDoc.exists) {
        throw Exception('Data pengguna tidak ditemukan');
      }

      final userData = userDoc.data()!;

      // Periksa apakah pengguna sudah diverifikasi
      if (!(userData['isVerified'] ?? false)) {
        throw Exception('Akun belum diverifikasi oleh admin');
      }

      // Update lastLogin
      await _firestore
          .collection(Collections.users)
          .doc(userCredential.user!.uid)
          .update({'lastLogin': FieldValue.serverTimestamp()});

      // Catat aktivitas login
      await _auditLogService.logActivity(
        userCredential.user!.uid,
        'Login',
        'Pengguna berhasil login',
      );

      // Kembalikan model pengguna
      return UserModel.fromJson({...userData, 'uid': userCredential.user!.uid});
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw Exception('Email tidak terdaftar');
          case 'wrong-password':
            throw Exception('Password salah');
          case 'user-disabled':
            throw Exception('Akun dinonaktifkan');
          default:
            throw Exception('Error: ${e.message}');
        }
      }
      rethrow;
    }
  }

  // Registrasi pengguna baru
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // Buat akun di Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Registrasi gagal');
      }

      // Simpan data pengguna di Firestore
      await _firestore
          .collection(Collections.users)
          .doc(userCredential.user!.uid)
          .set({
            'email': email,
            'name': name,
            'role': role,
            'isVerified': false, // Perlu verifikasi admin
            'photoUrl': '',
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
          });

      // Buat detail pengguna berdasarkan peran
      await _createUserDetails(userCredential.user!.uid, role);

      // Catat aktivitas registrasi
      await _auditLogService.logActivity(
        userCredential.user!.uid,
        'Registrasi',
        'Pengguna baru mendaftar dengan peran $role',
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            throw Exception('Email sudah digunakan');
          case 'weak-password':
            throw Exception('Password terlalu lemah');
          default:
            throw Exception('Error: ${e.message}');
        }
      }
      rethrow;
    }
  }

  // Buat detail pengguna berdasarkan peran
  Future<void> _createUserDetails(String uid, String role) async {
    final detailsCollection = _firestore.collection(Collections.userDetails);

    switch (role) {
      case RoleConstants.admin:
        await detailsCollection.doc(uid).set({
          'adminLevel': 1,
          'permissions': ['manage_users', 'verify_users', 'manage_system'],
        });
        break;
      case 'guru': // Gunakan string langsung alih-alih getter
        await detailsCollection.doc(uid).set({
          'nip': '',
          'subjects': [],
          'classesInCharge': [],
        });
        break;
      case 'siswa': // Gunakan string langsung alih-alih getter
        await detailsCollection.doc(uid).set({
          'nis': '',
          'classId': '',
          'parentName': '',
          'parentContact': '',
          'address': '',
        });
        break;
      case 'tata usaha': // Gunakan string langsung alih-alih getter
        await detailsCollection.doc(uid).set({
          'nip': '',
          'department': 'Tata Usaha',
          'position': '',
        });
        break;
      case 'kepala sekolah': // Gunakan string langsung alih-alih getter
        await detailsCollection.doc(uid).set({
          'nip': '',
          'startTerm': FieldValue.serverTimestamp(),
          'endTerm': null,
        });
        break;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _auditLogService.logActivity(
          user.uid,
          'Logout',
          'Pengguna logout',
        );
      }
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout gagal: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw Exception('Email tidak terdaftar');
          default:
            throw Exception('Error: ${e.message}');
        }
      }
      rethrow;
    }
  }

  // Verifikasi pengguna oleh admin
  Future<void> verifyUser(String uid) async {
    try {
      await _firestore.collection(Collections.users).doc(uid).update({
        'isVerified': true,
      });

      // Catat aktivitas verifikasi
      final admin = _auth.currentUser;
      if (admin != null) {
        await _auditLogService.logActivity(
          admin.uid,
          'Verifikasi Pengguna',
          'Admin memverifikasi pengguna $uid',
        );
      }
    } catch (e) {
      throw Exception('Verifikasi pengguna gagal: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc =
          await _firestore.collection(Collections.users).doc(user.uid).get();

      if (!userDoc.exists) return null;

      return UserModel.fromJson({...userDoc.data()!, 'uid': user.uid});
    } catch (e) {
      throw Exception('Gagal mendapatkan data pengguna: $e');
    }
  }
}
