import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String namaLengkap;
  final String nisn;
  final String jurusan;
  final DateTime tanggalLahir;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Student({
    required this.namaLengkap,
    required this.nisn,
    required this.jurusan,
    required this.tanggalLahir,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      namaLengkap: json['namaLengkap'] ?? '',
      nisn: json['nisn'] ?? '',
      jurusan: json['jurusan'] ?? '',
      // Mengonversi string ISO8601 dari API menjadi objek DateTime
      tanggalLahir: DateTime.parse(json['tanggalLahir']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    namaLengkap,
    nisn,
    jurusan,
    tanggalLahir,
    createdAt,
    updatedAt,
  ];
}
