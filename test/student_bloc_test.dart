import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nf_tech_test_app/features/students/bloc/student_bloc.dart';
import 'package:nf_tech_test_app/data/services/student_service.dart';

// Membuat Service Tiruan (Mock)
class MockStudentService extends Mock implements StudentService {}

void main() {
  late MockStudentService mockService;
  late StudentBloc studentBloc;

  setUp(() {
    mockService = MockStudentService();
    studentBloc = StudentBloc(mockService);
  });

  tearDown(() => studentBloc.close());

  group('StudentBloc Test', () {
    blocTest<StudentBloc, StudentState>(
      'Harus mengeluarkan [Loading, Loaded] saat berhasil fetch data',
      build: () {
        // Mocking respon API
        when(
          () => mockService.fetchStudents(
            token: any(named: 'token'),
            search: any(named: 'search'), // Tambahkan ini
            jurusan: any(named: 'jurusan'),
          ),
        ).thenAnswer(
          (_) async => {
            "data": [], // Data kosong sebagai contoh
            "meta": {"total": 0},
          },
        );
        return studentBloc;
      },
      act: (bloc) => bloc.add(const FetchStudents(token: 'fake_token')),
      expect: () => [
        isA<StudentState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StudentState>().having((s) => s.isLoading, 'isLoading', false),
      ],
    );
  });
}
