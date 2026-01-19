import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://nf-tech-test-api.vercel.app/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      // Full Handling Error Dio
      if (e.response != null) {
        // Error dari Server (misal: 401 Unauthorized)
        throw e.response?.data['message'] ?? 'Gagal login, periksa akun Anda';
      } else {
        // Error Jaringan atau Timeout
        throw 'Tidak ada koneksi internet';
      }
    }
  }
}
