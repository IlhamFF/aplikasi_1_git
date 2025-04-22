class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
  }

  static String? validateIdUnik(String? value, String prefix) {
    if (value == null || value.isEmpty) {
      return 'ID tidak boleh kosong';
    }

    if (!value.startsWith(prefix)) {
      return 'ID harus dimulai dengan $prefix';
    }

    if (value.length < 8) {
      return 'ID minimal 8 karakter';
    }

    return null;
  }
}
