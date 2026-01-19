import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // Mengembalikan enum berdasarkan index yang disimpan
    return ThemeMode.values[json['theme_index'] as int];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // Menyimpan index enum ke storage
    return {'theme_index': state.index};
  }
}
