import 'package:hydrated_bloc/hydrated_bloc.dart';

// State sederhana untuk menyimpan token
class AuthState {
  final String? token;
  AuthState({this.token});

  bool get isAuthenticated => token != null;
}

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(AuthState());

  // Simpan token saat login berhasil
  void login(String token) {
    emit(AuthState(token: token));
  }

  // Hapus token saat logout
  void logout() {
    emit(AuthState(token: null));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState(token: json['token'] as String?);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {'token': state.token};
  }
}
