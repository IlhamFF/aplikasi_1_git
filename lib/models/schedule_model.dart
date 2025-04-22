import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk jadwal pelajaran
class ScheduleModel {
  /// ID unik jadwal
  final String id;

  /// ID kelas
  final String classId;

  /// ID mata pelajaran
  final String subjectId;

  /// ID guru yang mengajar
  final String teacherId;

  /// Hari (Senin, Selasa, dll)
  final String day;

  /// Waktu mulai (format: HH:mm)
  final String startTime;

  /// Waktu selesai (format: HH:mm)
  final String endTime;

  /// Ruangan
  final String room;

  /// Semester (Ganjil/Genap)
  final String semester;

  /// Tahun akademik
  final String academicYear;

  /// Catatan tambahan
  final String? notes;

  /// Status aktif jadwal
  final bool isActive;

  /// Tanggal mulai berlaku jadwal
  final DateTime? effectiveStartDate;

  /// Tanggal berakhir jadwal
  final DateTime? effectiveEndDate;

  /// Konstruktor
  ScheduleModel({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.semester,
    required this.academicYear,
    this.notes,
    this.isActive = true,
    this.effectiveStartDate,
    this.effectiveEndDate,
  });

  /// Membuat objek ScheduleModel dari JSON
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? '',
      classId: json['classId'] ?? '',
      subjectId: json['subjectId'] ?? '',
      teacherId: json['teacherId'] ?? '',
      day: json['day'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'] ?? '',
      semester: json['semester'] ?? '',
      academicYear: json['academicYear'] ?? '',
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      effectiveStartDate:
          json['effectiveStartDate'] != null
              ? (json['effectiveStartDate'] is Timestamp
                  ? (json['effectiveStartDate'] as Timestamp).toDate()
                  : DateTime.parse(json['effectiveStartDate'].toString()))
              : null,
      effectiveEndDate:
          json['effectiveEndDate'] != null
              ? (json['effectiveEndDate'] is Timestamp
                  ? (json['effectiveEndDate'] as Timestamp).toDate()
                  : DateTime.parse(json['effectiveEndDate'].toString()))
              : null,
    );
  }

  /// Mengkonversi objek ScheduleModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'semester': semester,
      'academicYear': academicYear,
      'notes': notes,
      'isActive': isActive,
      'effectiveStartDate': effectiveStartDate,
      'effectiveEndDate': effectiveEndDate,
    };
  }

  /// Membuat salinan objek dengan nilai yang diperbarui
  ScheduleModel copyWith({
    String? id,
    String? classId,
    String? subjectId,
    String? teacherId,
    String? day,
    String? startTime,
    String? endTime,
    String? room,
    String? semester,
    String? academicYear,
    String? notes,
    bool? isActive,
    DateTime? effectiveStartDate,
    DateTime? effectiveEndDate,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      semester: semester ?? this.semester,
      academicYear: academicYear ?? this.academicYear,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      effectiveEndDate: effectiveEndDate ?? this.effectiveEndDate,
    );
  }

  /// Mendapatkan durasi jadwal dalam menit
  int get durationMinutes {
    try {
      final start = _parseTimeToMinutes(startTime);
      final end = _parseTimeToMinutes(endTime);

      if (end < start) {
        // Jika jadwal melewati tengah malam
        return (24 * 60 - start) + end;
      }

      return end - start;
    } catch (e) {
      return 0;
    }
  }

  /// Mengkonversi format waktu (HH:mm) ke menit
  int _parseTimeToMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    return hours * 60 + minutes;
  }

  /// Memeriksa apakah jadwal berlaku pada tanggal tertentu
  bool isEffectiveOn(DateTime date) {
    if (!isActive) return false;

    if (effectiveStartDate != null && date.isBefore(effectiveStartDate!)) {
      return false;
    }

    if (effectiveEndDate != null && date.isAfter(effectiveEndDate!)) {
      return false;
    }

    return true;
  }

  /// Memeriksa apakah jadwal bentrok dengan jadwal lain
  bool conflictsWith(ScheduleModel other) {
    // Jadwal harus pada hari yang sama untuk bentrok
    if (day != other.day) return false;

    // Jadwal harus pada semester dan tahun akademik yang sama
    if (semester != other.semester || academicYear != other.academicYear) {
      return false;
    }

    // Periksa apakah waktu bentrok
    final thisStart = _parseTimeToMinutes(startTime);
    final thisEnd = _parseTimeToMinutes(endTime);
    final otherStart = _parseTimeToMinutes(other.startTime);
    final otherEnd = _parseTimeToMinutes(other.endTime);

    // Jadwal bentrok jika:
    // 1. Jadwal ini dimulai saat jadwal lain sedang berlangsung
    // 2. Jadwal ini berakhir saat jadwal lain sedang berlangsung
    // 3. Jadwal ini mencakup seluruh jadwal lain

    return (thisStart >= otherStart && thisStart < otherEnd) ||
        (thisEnd > otherStart && thisEnd <= otherEnd) ||
        (thisStart <= otherStart && thisEnd >= otherEnd);
  }

  /// Mendapatkan representasi string dari jadwal
  String get timeRange => '$startTime - $endTime';

  /// Mendapatkan hari dalam format yang lebih mudah dibaca
  String get formattedDay {
    switch (day.toLowerCase()) {
      case 'monday':
      case 'senin':
        return 'Senin';
      case 'tuesday':
      case 'selasa':
        return 'Selasa';
      case 'wednesday':
      case 'rabu':
        return 'Rabu';
      case 'thursday':
      case 'kamis':
        return 'Kamis';
      case 'friday':
      case 'jumat':
        return 'Jumat';
      case 'saturday':
      case 'sabtu':
        return 'Sabtu';
      case 'sunday':
      case 'minggu':
        return 'Minggu';
      default:
        return day;
    }
  }
}
