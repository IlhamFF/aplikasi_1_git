import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk data pengguna
class UserModel {
  /// ID unik pengguna (dari Firebase Auth)
  final String uid;

  /// Alamat email pengguna
  final String email;

  /// Nama lengkap pengguna
  final String name;

  /// Peran pengguna (admin, guru, siswa, dll)
  final String role;

  /// Status verifikasi pengguna
  final bool isVerified;

  /// URL foto profil pengguna
  final String photoUrl;

  /// Waktu pembuatan akun
  final DateTime createdAt;

  /// Waktu login terakhir
  final DateTime lastLogin;

  /// Nomor telepon pengguna
  final String? phoneNumber;

  /// Alamat pengguna
  final String? address;

  /// Status aktif pengguna
  final bool isActive;

  /// Konstruktor
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.isVerified = false,
    this.photoUrl = '',
    required this.createdAt,
    required this.lastLogin,
    this.phoneNumber,
    this.address,
    this.isActive = true,
  });

  /// Membuat objek UserModel dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
      photoUrl: json['photoUrl'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? (json['createdAt'] is Timestamp
                  ? (json['createdAt'] as Timestamp).toDate()
                  : DateTime.parse(json['createdAt'].toString()))
              : DateTime.now(),
      lastLogin:
          json['lastLogin'] != null
              ? (json['lastLogin'] is Timestamp
                  ? (json['lastLogin'] as Timestamp).toDate()
                  : DateTime.parse(json['lastLogin'].toString()))
              : DateTime.now(),
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      isActive: json['isActive'] ?? true,
    );
  }

  /// Mengkonversi objek UserModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'isVerified': isVerified,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'phoneNumber': phoneNumber,
      'address': address,
      'isActive': isActive,
    };
  }

  /// Membuat salinan objek dengan nilai yang diperbarui
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? role,
    bool? isVerified,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? phoneNumber,
    String? address,
    bool? isActive,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Mendapatkan inisial dari nama pengguna
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '';
  }

  /// Mendapatkan nama peran yang ditampilkan
  String get displayRole {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'guru':
        return 'Guru';
      case 'siswa':
        return 'Siswa';
      case 'tata usaha':
        return 'Tata Usaha';
      case 'kepala sekolah':
        return 'Kepala Sekolah';
      default:
        return role;
    }
  }
}
