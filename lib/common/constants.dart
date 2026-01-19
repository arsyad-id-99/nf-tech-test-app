class AppConstants {
  // --- API Configuration ---
  static const String baseUrl = 'https://nf-tech-test-api.vercel.app/api';

  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // --- Filter Options ---
  static const List<String> jurusanOptions = [
    'Semua Jurusan',
    'IPA',
    'IPS',
    'Bahasa',
  ];

  static const String tokenKey = 'user_token_key';
  static const String themeKey = 'app_theme_index';

  // --- Validation Messages ---
  static const String reqMessage = 'Field ini wajib diisi';
  static const String loginErrMessage =
      'Gagal login, periksa kembali akun Anda';
}
