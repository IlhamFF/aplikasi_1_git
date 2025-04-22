import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk data kelas
class ClassModel {
  /// ID unik kelas
  final String id;

  /// Nama kelas
  final String name;

  /// Tingkat kelas (1, 2, 3, dll)
  final String grade;

  /// Tahun akademik (contoh: 2023/2024)
  final String academicYear;

  /// ID guru wali kelas
  final String homeRoomTeacherId;

  /// Daftar ID siswa dalam kelas
  final List<String> studentIds;

  /// Kapasitas maksimum kelas
  final int maxCapacity;

  /// Ruangan kelas
  final String? room;

  /// Deskripsi kelas
  final String? description;

  /// Status aktif kelas
  final bool isActive;

  /// Konstruktor
  ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.academicYear,
    required this.homeRoomTeacherId,
    required this.studentIds,
    this.maxCapacity = 30,
    this.room,
    this.description,
    this.isActive = true,
  });

  /// Membuat objek ClassModel dari JSON
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      academicYear: json['academicYear'] ?? '',
      homeRoomTeacherId: json['homeRoomTeacherId'] ?? '',
      studentIds: List<String>.from(json['studentIds'] ?? []),
      maxCapacity: json['maxCapacity'] ?? 30,
      room: json['room'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }

  /// Mengkonversi objek ClassModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'academicYear': academicYear,
      'homeRoomTeacherId': homeRoomTeacherId,
      'studentIds': studentIds,
      'maxCapacity': maxCapacity,
      'room': room,
      'description': description,
      'isActive': isActive,
    };
  }

  /// Membuat salinan objek dengan nilai yang diperbarui
  ClassModel copyWith({
    String? id,
    String? name,
    String? grade,
    String? academicYear,
    String? homeRoomTeacherId,
    List<String>? studentIds,
    int? maxCapacity,
    String? room,
    String? description,
    bool? isActive,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      academicYear: academicYear ?? this.academicYear,
      homeRoomTeacherId: homeRoomTeacherId ?? this.homeRoomTeacherId,
      studentIds: studentIds ?? this.studentIds,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      room: room ?? this.room,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Mendapatkan jumlah siswa dalam kelas
  int get studentCount => studentIds.length;

  /// Memeriksa apakah kelas sudah penuh
  bool get isFull => studentIds.length >= maxCapacity;

  /// Mendapatkan persentase kapasitas yang terisi
  double get capacityPercentage =>
      maxCapacity > 0 ? (studentIds.length / maxCapacity) * 100 : 0;

  /// Menambahkan siswa ke kelas
  ClassModel addStudent(String studentId) {
    if (studentIds.contains(studentId)) return this;

    final updatedStudentIds = List<String>.from(studentIds);
    updatedStudentIds.add(studentId);

    return copyWith(studentIds: updatedStudentIds);
  }

  /// Menghapus siswa dari kelas
  ClassModel removeStudent(String studentId) {
    final updatedStudentIds = List<String>.from(studentIds);
    updatedStudentIds.remove(studentId);

    return copyWith(studentIds: updatedStudentIds);
  }
}
