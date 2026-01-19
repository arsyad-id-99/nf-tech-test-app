import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'bloc/student_detail_bloc.dart';
import '../../../data/models/student_model.dart';

class StudentDetailView extends StatelessWidget {
  final String nisn;

  const StudentDetailView({super.key, required this.nisn});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Siswa"), centerTitle: true),
      body: BlocBuilder<StudentDetailBloc, StudentDetailState>(
        builder: (context, state) {
          if (state is StudentDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentDetailLoaded) {
            final student = state.student;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildHeader(theme, student),
                  const SizedBox(height: 24),
                  _buildInfoSection(theme, student),
                ],
              ),
            );
          } else if (state is StudentDetailError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Student student) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.secondary, // Kuning NF
          child: Icon(
            Icons.person,
            size: 60,
            color: theme.colorScheme.primary,
          ), // Biru NF
        ),
        const SizedBox(height: 16),
        Text(
          student.namaLengkap,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "NISN: ${student.nisn}",
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoSection(ThemeData theme, Student student) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: .2)),
      ),
      child: Column(
        children: [
          _infoTile(Icons.school, "Jurusan", student.jurusan, theme),
          _infoTile(
            Icons.cake,
            "Tanggal Lahir",
            _formatDate(student.tanggalLahir),
            theme,
          ),
          _infoTile(
            Icons.event_available,
            "Terdaftar Pada",
            _formatDate(student.createdAt),
            theme,
          ),
          _infoTile(
            Icons.edit_calendar,
            "Terakhir Diperbarui",
            _formatDate(student.updatedAt),
            theme,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String label,
    String value,
    ThemeData theme, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }
}
