import '../models/student_model.dart';

class StudentService {
  Future<List<Student>> getStudents() async {
    // Simulasi delay jaringan selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    return [
      const Student(
        id: '1',
        fullName: 'Budi Santoso',
        nisn: '0012345',
        major: '10-A',
      ),
      const Student(
        id: '2',
        fullName: 'Siti Aminah',
        nisn: '0012346',
        major: '11-B',
      ),
      const Student(
        id: '3',
        fullName: 'Andi Wijaya',
        nisn: '0012347',
        major: '10-A',
      ),
    ];
  }
}
