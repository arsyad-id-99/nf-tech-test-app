import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String fullName;
  final String nisn;
  final String major;

  const Student({
    required this.id,
    required this.fullName,
    required this.nisn,
    required this.major,
  });

  @override
  List<Object?> get props => [id, fullName, nisn, major];
}
