import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nf_tech_test_app/common/constants.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
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
      debugPrint(e.toString());
      // Full Handling Error Dio
      if (e.response != null) {
        // Error dari Server (misal: 401 Unauthorized)
        throw e.response?.data['msg'] ?? 'Gagal login, periksa akun Anda';
      } else {
        // Error Jaringan atau Timeout
        throw 'Tidak ada koneksi internet';
      }
    }
  }
}
