import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/student_model.dart';
import '../../../data/services/student_service.dart';

// --- Events ---
abstract class StudentDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchStudentDetail extends StudentDetailEvent {
  final String nisn;
  final String token;
  FetchStudentDetail(this.nisn, this.token);
  @override
  List<Object> get props => [nisn];
}

// --- States ---
abstract class StudentDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class StudentDetailInitial extends StudentDetailState {}

class StudentDetailLoading extends StudentDetailState {}

class StudentDetailLoaded extends StudentDetailState {
  final Student student;
  StudentDetailLoaded(this.student);
  @override
  List<Object> get props => [student];
}

class StudentDetailError extends StudentDetailState {
  final String message;
  StudentDetailError(this.message);
}

// --- Bloc ---
class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  final StudentService service;
  StudentDetailBloc(this.service) : super(StudentDetailInitial()) {
    on<FetchStudentDetail>((event, emit) async {
      emit(StudentDetailLoading());
      try {
        final student = await service.getStudentDetail(event.nisn, event.token);
        emit(StudentDetailLoaded(student));
      } catch (e) {
        emit(StudentDetailError(e.toString()));
      }
    });
  }
}
