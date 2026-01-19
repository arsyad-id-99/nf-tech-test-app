import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/services/student_service.dart';

// --- EVENTS ---
abstract class AddStudentEvent extends Equatable {
  const AddStudentEvent();

  @override
  List<Object?> get props => [];
}

class AddStudentSubmitted extends AddStudentEvent {
  final Map<String, dynamic> data;
  final String token;

  const AddStudentSubmitted({required this.data, required this.token});

  @override
  List<Object?> get props => [data, token];
}

// --- STATES ---
class StudentAddState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const StudentAddState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  StudentAddState copyWith({bool? isLoading, bool? isSuccess, String? error}) {
    return StudentAddState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error, // Error di-reset jika tidak dikirim
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, error];
}

// --- BLOC ---
class StudentAddBloc extends Bloc<AddStudentEvent, StudentAddState> {
  final StudentService service;

  StudentAddBloc(this.service) : super(const StudentAddState()) {
    on<AddStudentSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, isSuccess: false, error: null));

      try {
        await service.addStudent(event.data, event.token);
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: e.toString(),
          ),
        );
      }
    });
  }
}
