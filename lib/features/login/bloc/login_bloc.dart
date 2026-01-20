import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nf_tech_test_app/data/services/notification_service.dart';
import '../../../data/services/auth_service.dart';

// --- Events ---
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;
  LoginSubmitted(this.username, this.password);
}

// --- States ---
abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> userData;
  LoginSuccess(this.userData);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

// --- Bloc ---
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc(this.authService) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final deviceToken = await NotificationService().getDeviceToken();
        debugPrint("Device Token: $deviceToken");
        final data = await authService.login(
          event.username,
          event.password,
          deviceToken,
        );
        emit(LoginSuccess(data));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
