import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

// --- Events ---
abstract class OfflineStudentEvent extends Equatable {
  const OfflineStudentEvent();
  @override
  List<Object> get props => [];
}

class AddStudentToOfflineQueue extends OfflineStudentEvent {
  final Map<String, dynamic> studentData;
  const AddStudentToOfflineQueue(this.studentData);
}

class RemoveStudentFromQueue extends OfflineStudentEvent {
  final Map<String, dynamic> studentData;
  const RemoveStudentFromQueue(this.studentData);
}

// --- State ---
class OfflineStudentState extends Equatable {
  final List<Map<String, dynamic>> pendingStudents;
  const OfflineStudentState({this.pendingStudents = const []});

  @override
  List<Object> get props => [pendingStudents];
}

// --- Bloc ---
class OfflineStudentBloc
    extends HydratedBloc<OfflineStudentEvent, OfflineStudentState> {
  OfflineStudentBloc() : super(const OfflineStudentState()) {
    on<AddStudentToOfflineQueue>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.pendingStudents)
        ..add(event.studentData);
      emit(OfflineStudentState(pendingStudents: updatedList));
    });

    on<RemoveStudentFromQueue>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.pendingStudents)
        ..remove(event.studentData);
      emit(OfflineStudentState(pendingStudents: updatedList));
    });
  }

  // Logika untuk menyimpan ke local storage (JSON)
  @override
  OfflineStudentState? fromJson(Map<String, dynamic> json) {
    return OfflineStudentState(
      pendingStudents: List<Map<String, dynamic>>.from(json['pendingStudents']),
    );
  }

  @override
  Map<String, dynamic>? toJson(OfflineStudentState state) {
    return {'pendingStudents': state.pendingStudents};
  }
}
