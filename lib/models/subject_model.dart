/// Model untuk data mata pelajaran
class SubjectModel {
  /// ID unik mata pelajaran
  final String id;

  /// Nama mata pelajaran
  final String name;

  /// Deskripsi mata pelajaran
  final String description;

  /// Daftar ID guru yang mengajar mata pelajaran ini
  final List<String> teacherIds;

  /// Tingkat kelas yang mempelajari mata pelajaran ini
  final List<String> gradeLevel;

  /// Kode mata pelajaran
  final String? code;

  /// Jumlah jam pelajaran per minggu
  final int hoursPerWeek;

  /// Kategori mata pelajaran (umum, peminatan, muatan lokal, dll)
  final String? category;

  /// Status aktif mata pelajaran
  final bool isActive;

  /// Silabus mata pelajaran (URL dokumen)
  final String? syllabusUrl;

  /// Konstruktor
  SubjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherIds,
    required this.gradeLevel,
    this.code,
    this.hoursPerWeek = 2,
    this.category,
    this.isActive = true,
    this.syllabusUrl,
  });

  /// Membuat objek SubjectModel dari JSON
  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      teacherIds: List<String>.from(json['teacherIds'] ?? []),
      gradeLevel: List<String>.from(json['gradeLevel'] ?? []),
      code: json['code'],
      hoursPerWeek: json['hoursPerWeek'] ?? 2,
      category: json['category'],
      isActive: json['isActive'] ?? true,
      syllabusUrl: json['syllabusUrl'],
    );
  }

  /// Mengkonversi objek SubjectModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'teacherIds': teacherIds,
      'gradeLevel': gradeLevel,
      'code': code,
      'hoursPerWeek': hoursPerWeek,
      'category': category,
      'isActive': isActive,
      'syllabusUrl': syllabusUrl,
    };
  }

  /// Membuat salinan objek dengan nilai yang diperbarui
  SubjectModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? teacherIds,
    List<String>? gradeLevel,
    String? code,
    int? hoursPerWeek,
    String? category,
    bool? isActive,
    String? syllabusUrl,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      teacherIds: teacherIds ?? this.teacherIds,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      code: code ?? this.code,
      hoursPerWeek: hoursPerWeek ?? this.hoursPerWeek,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      syllabusUrl: syllabusUrl ?? this.syllabusUrl,
    );
  }

  /// Menambahkan guru ke mata pelajaran
  SubjectModel addTeacher(String teacherId) {
    if (teacherIds.contains(teacherId)) return this;

    final updatedTeacherIds = List<String>.from(teacherIds);
    updatedTeacherIds.add(teacherId);

    return copyWith(teacherIds: updatedTeacherIds);
  }

  /// Menghapus guru dari mata pelajaran
  SubjectModel removeTeacher(String teacherId) {
    final updatedTeacherIds = List<String>.from(teacherIds);
    updatedTeacherIds.remove(teacherId);

    return copyWith(teacherIds: updatedTeacherIds);
  }

  /// Memeriksa apakah mata pelajaran diajarkan di tingkat kelas tertentu
  bool isForGrade(String grade) {
    return gradeLevel.contains(grade);
  }

  /// Mendapatkan nama lengkap mata pelajaran dengan kode (jika ada)
  String get fullName {
    return code != null ? '$code - $name' : name;
  }
}
