import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nf_tech_test_app/data/services/auth_service.dart';
import 'package:nf_tech_test_app/data/services/notification_service.dart';
import 'package:nf_tech_test_app/features/auth/auth_cubit.dart';
import 'package:nf_tech_test_app/features/login/bloc/login_bloc.dart';
import 'package:nf_tech_test_app/features/login/login_view.dart';
import 'package:nf_tech_test_app/features/settings/setting_view.dart';
import 'package:nf_tech_test_app/features/students/bloc/offline_student_bloc.dart';
import 'package:nf_tech_test_app/features/students/bloc/student_add_bloc.dart';
import 'package:nf_tech_test_app/features/students/bloc/student_detail_bloc.dart';
import 'package:nf_tech_test_app/features/students/student_add_form_view.dart';
import 'package:nf_tech_test_app/features/students/student_detail_view.dart';
import 'package:nf_tech_test_app/features/students/student_list_view.dart';
import 'package:nf_tech_test_app/features/theme/theme_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'data/services/student_service.dart';
import 'features/students/bloc/student_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF00458E),
    onPrimary: Colors.white,
    secondary: Color(0xFFFDB813),
    onSecondary: Colors.black,
    surface: Colors.white,
    onSurface: Color(0xFF333333),
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
    primary: Color(0xFF4A8FE7),
    onPrimary: Colors.white,
    secondary: Color(0xFFFDB813),
    onSecondary: Colors.black,
    surface: Color(0xFF121212),
    onSurface: Colors.white,
    primaryContainer: Color(0xFF002B5B),
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Menangani pesan background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Inisialisasi Service Notifikasi
  await NotificationService().initNotification();

  await initializeDateFormatting('id_ID', null);
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
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => OfflineStudentBloc()),

        BlocProvider<StudentAddBloc>(
          create: (context) => StudentAddBloc(
            studentService,
            context.read<OfflineStudentBloc>(),
          ),
        ),
        BlocProvider(create: (context) => LoginBloc(AuthService())),
        BlocProvider(create: (context) => StudentBloc(studentService)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'NF Tech Test App',
            navigatorKey: navigatorKey,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: context.read<AuthCubit>().state.isAuthenticated
                ? const StudentListView()
                : const LoginView(),
            onGenerateRoute: (settings) {
              if (settings.name == '/detail') {
                final nisn = settings.arguments as String;
                final token = context.read<AuthCubit>().state.token!;

                return MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) =>
                          StudentDetailBloc(StudentService())
                            ..add(FetchStudentDetail(nisn, token)),
                      child: StudentDetailView(nisn: nisn),
                    );
                  },
                );
              }

              if (settings.name == '/login') {
                return MaterialPageRoute(builder: (_) => const LoginView());
              }
              if (settings.name == '/list') {
                return MaterialPageRoute(
                  builder: (_) => const StudentListView(),
                );
              }
              if (settings.name == '/add') {
                return MaterialPageRoute(
                  builder: (_) => const StudentAddFormView(),
                );
              }
              if (settings.name == '/settings') {
                return MaterialPageRoute(builder: (_) => const SettingsView());
              }

              return null;
            },
          );
        },
      ),
    );
  }
}
