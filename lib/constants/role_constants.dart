class RoleConstants {
  static const String admin = 'A';
  static const String guru = 'G';
  static const String tu = 'T';
  static const String kepsek = 'K';
  static const String siswa = 'S';

  static String get teacher => 'guru';
  static String get student => 'siswa';
  static String get staff => 'tata usaha';
  static String get principal => 'kepala sekolah';

  static String getRoleName(String roleCode) {
    switch (roleCode) {
      case admin:
        return 'Admin';
      case guru:
        return 'Guru';
      case tu:
        return 'Tata Usaha';
      case kepsek:
        return 'Kepala Sekolah';
      case siswa:
        return 'Siswa';
      default:
        return 'Pengguna';
    }
  }
}
