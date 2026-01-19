import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nf_tech_test_app/features/auth/auth_cubit.dart';
import 'package:nf_tech_test_app/features/login/login_view.dart';
import 'package:nf_tech_test_app/features/students/student_add_form_view.dart';
import 'package:nf_tech_test_app/features/students/student_detail_view.dart';
import 'package:nf_tech_test_app/features/students/student_list_view.dart';
import 'package:nf_tech_test_app/features/theme/theme_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'data/services/student_service.dart';
import 'features/students/bloc/student_bloc.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF00458E), // Biru NF
    onPrimary: Colors.white,
    secondary: Color(0xFFFDB813), // Kuning NF
    onSecondary: Colors.black,
    surface: Colors.white,
    onSurface: Color(0xFF333333), // Teks Gelap
    error: Color(0xFFB00020),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00458E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFDB813),
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF4A8FE7), // Biru yang lebih terang untuk aksesibilitas
    onPrimary: Colors.white,
    secondary: Color(0xFFFDB813), // Tetap Kuning NF
    onSecondary: Colors.black,
    surface: Color(0xFF121212), // Latar belakang gelap standar
    onSurface: Colors.white,
    primaryContainer: Color(0xFF002B5B), // Biru gelap untuk card/container
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFDB813),
      foregroundColor: Colors.black,
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final studentService = StudentService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) =>
              StudentBloc(studentService)..add(FetchStudents()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'NF Tech Test App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: context.read<AuthCubit>().state.isAuthenticated
                ? const StudentListView()
                : const LoginView(),
            routes: {
              '/login': (context) => LoginView(),
              '/list': (context) => const StudentListView(),
              '/detail': (context) => const StudentDetailView(),
              '/register': (context) => StudentAddFormView(),
            },
          );
        },
      ),
    );
  }
}
