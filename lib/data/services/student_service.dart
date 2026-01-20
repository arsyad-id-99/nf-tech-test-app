import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:nf_tech_test_app/common/constants.dart';
import 'package:nf_tech_test_app/data/models/student_model.dart';

class StudentService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<Map<String, dynamic>> fetchStudents({
    String? search,
    String? jurusan,
    int page = 1,
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        '/student',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (jurusan != null && jurusan != 'Semua') 'jurusan': jurusan,
          'page': page,
          'limit': 10,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      debugPrint(response.toString());
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw 'Gagal mengambil data siswa';
    }
  }

  Future<void> addStudent(
    Map<String, dynamic> studentData,
    String token,
  ) async {
    try {
      await _dio.post(
        '/student',
        data: studentData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      debugPrint(e.toString());
      throw e.response?.data['message'] ?? e;
    }
  }

  Future<Student> getStudentDetail(String nisn, String token) async {
    try {
      final response = await _dio.get(
        '/student/$nisn',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return Student.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Gagal memuat detail siswa';
    }
  }
}
