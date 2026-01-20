import 'package:flutter_test/flutter_test.dart';
import 'package:nf_tech_test_app/data/models/student_model.dart';

void main() {
  group('Student Model Test', () {
    test('Harus mengonversi JSON ke Student Object dengan benar', () {
      final json = {
        "namaLengkap": "Budi Siregar",
        "nisn": "091290192",
        "jurusan": "IPA",
        "tanggalLahir": "2007-12-10T00:00:00.000Z",
      };

      final student = Student.fromJson(json);

      expect(student.namaLengkap, "Budi Siregar");
      expect(student.nisn, "091290192");
      expect(student.jurusan, "IPA");
    });
  });
}
