import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/student_model.dart';
import '../../../data/services/student_service.dart';

// --- EVENTS ---
abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk mengambil data pertama kali atau saat filter berubah
class FetchStudents extends StudentEvent {
  final String search;
  final String jurusan;
  final String token;

  const FetchStudents({this.search = '', this.jurusan = '', this.token = ''});

  @override
  List<Object?> get props => [search, jurusan, token];
}

// Event untuk mengambil halaman berikutnya (infinite scroll)
class LoadMoreStudents extends StudentEvent {}

// --- STATES ---
class StudentState extends Equatable {
  final List<Student> students;
  final bool isLoading;
  final bool isFetchingMore;
  final String? error;
  final int currentPage;
  final bool hasReachedMax;
  final String search;
  final String jurusan;
  final String token;

  const StudentState({
    this.students = const [],
    this.isLoading = false,
    this.isFetchingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.search = '',
    this.jurusan = '',
    this.token = '',
  });

  StudentState copyWith({
    List<Student>? students,
    bool? isLoading,
    bool? isFetchingMore,
    String? error,
    int? currentPage,
    bool? hasReachedMax,
    String? search,
    String? jurusan,
    String? token,
  }) {
    return StudentState(
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      search: search ?? this.search,
      jurusan: jurusan ?? this.jurusan,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
    students,
    isLoading,
    isFetchingMore,
    error,
    currentPage,
    hasReachedMax,
    search,
    jurusan,
    token,
  ];
}

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentService service;

  StudentBloc(this.service) : super(const StudentState()) {
    on<FetchStudents>(_onFetchStudents);
    on<LoadMoreStudents>(_onLoadMoreStudents);
  }

  Future<void> _onFetchStudents(
    FetchStudents event,
    Emitter<StudentState> emit,
  ) async {
    debugPrint(
      'Fetching students with search: ${event.search}, jurusan: ${event.jurusan}',
    );
    emit(
      state.copyWith(
        isLoading: true,
        search: event.search,
        jurusan: event.jurusan,
        currentPage: 1,
        hasReachedMax: false,
        token: event.token,
      ),
    );
    try {
      final res = await service.fetchStudents(
        search: event.search,
        jurusan: event.jurusan,
        page: 1,
        token: event.token,
      );
      debugPrint('Fetch result: $res');
      final List data = res['data'];
      final List<Student> students = data
          .map((e) => Student.fromJson(e))
          .toList();

      emit(
        state.copyWith(
          isLoading: false,
          students: students,
          hasReachedMax: students.length < 10,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching students: $e');
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMoreStudents(
    LoadMoreStudents event,
    Emitter<StudentState> emit,
  ) async {
    if (state.hasReachedMax || state.isFetchingMore) return;

    emit(state.copyWith(isFetchingMore: true));
    try {
      final nextPage = state.currentPage + 1;
      final res = await service.fetchStudents(
        search: state.search,
        jurusan: state.jurusan,
        page: nextPage,
        token: state.token,
      );
      final List data = res['data'];
      final List<Student> newStudents = data
          .map((e) => Student.fromJson(e))
          .toList();

      emit(
        state.copyWith(
          isFetchingMore: false,
          students: List.of(state.students)..addAll(newStudents),
          currentPage: nextPage,
          hasReachedMax: newStudents.isEmpty || newStudents.length < 10,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isFetchingMore: false));
    }
  }
}
