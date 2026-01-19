import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/student_model.dart';
import '../../../data/services/student_service.dart';

// --- EVENTS ---
abstract class StudentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchStudents extends StudentEvent {}

// --- STATES ---
abstract class StudentState extends Equatable {
  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;
  StudentLoaded(this.students);
  @override
  List<Object> get props => [students];
}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
}

// --- BLOC ---
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentService service;

  StudentBloc(this.service) : super(StudentInitial()) {
    on<FetchStudents>((event, emit) async {
      emit(StudentLoading());
      try {
        final data = await service.getStudents();
        emit(StudentLoaded(data));
      } catch (e) {
        emit(StudentError("Gagal memuat data siswa"));
      }
    });
  }
}
