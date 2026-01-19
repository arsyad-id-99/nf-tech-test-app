import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nf_tech_test_app/features/students/bloc/student_bloc.dart';
import 'package:nf_tech_test_app/features/theme/theme_cubit.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Siswa"),
        actions: [
          Switch(
            value: context.watch<ThemeCubit>().state == ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme();
            },
            activeThumbColor: Theme.of(
              context,
            ).colorScheme.secondary, // Warna Kuning NF
          ),
        ],
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentLoaded) {
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(student.fullName),
                  subtitle: Text(
                    "NISN: ${student.nisn} | Jurusan: ${student.major}",
                  ),
                  onTap: () {
                    // TODO: Navigasi ke Detail
                    Navigator.pushNamed(context, '/detail');
                  },
                );
              },
            );
          }

          return const Center(child: Text("Tidak ada data"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/register'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
