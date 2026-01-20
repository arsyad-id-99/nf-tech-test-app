import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nf_tech_test_app/features/students/bloc/offline_student_bloc.dart';
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
  final bool isOffline; // Tambahkan ini
  final String? error;

  const StudentAddState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isOffline = false, // Default false
    this.error,
  });

  StudentAddState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isOffline,
    String? error,
  }) {
    return StudentAddState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isOffline: isOffline ?? this.isOffline,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, isOffline, error];
}

// --- BLOC ---
class StudentAddBloc extends Bloc<AddStudentEvent, StudentAddState> {
  final StudentService service;
  final OfflineStudentBloc offlineBloc; // Tambahkan dependency ke bloc offline

  StudentAddBloc(this.service, this.offlineBloc)
    : super(const StudentAddState()) {
    on<AddStudentSubmitted>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: true,
          isSuccess: false,
          isOffline: false,
          error: null,
        ),
      );
      debugPrint("Add Siswa");

      try {
        await service.addStudent(event.data, event.token);
        emit(
          state.copyWith(isLoading: false, isSuccess: true, isOffline: false),
        );
      } catch (e) {
        // Cek apakah error disebabkan oleh koneksi internet
        debugPrint('Error saat menambahkan siswa: $e');
        if (_isNetworkError(e)) {
          // Masukkan ke antrean offline
          offlineBloc.add(AddStudentToOfflineQueue(event.data));

          // Emit sukses dengan tanda 'isOffline'
          emit(
            state.copyWith(isLoading: false, isSuccess: true, isOffline: true),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: false,
              error: e.toString(),
            ),
          );
        }
      }
    });
  }

  // Fungsi pembantu untuk mendeteksi error jaringan
  bool _isNetworkError(dynamic e) {
    if (e is DioException) {
      return e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error.toString().contains('SocketException');
    }
    return e.toString().contains('SocketException');
  }
}
