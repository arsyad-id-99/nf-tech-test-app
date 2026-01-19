import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nf_tech_test_app/common/constants.dart';
import 'package:nf_tech_test_app/data/services/student_service.dart';
import 'package:nf_tech_test_app/features/auth/auth_cubit.dart';
import 'package:nf_tech_test_app/features/students/bloc/student_bloc.dart';
import 'package:nf_tech_test_app/features/students/bloc/student_detail_bloc.dart';
import 'package:nf_tech_test_app/features/students/student_detail_view.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _selectedJurusan = 'Semua';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final authState = context.read<AuthCubit>().state;
    context.read<StudentBloc>().add(FetchStudents(token: authState.token!));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<StudentBloc>().add(LoadMoreStudents());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Siswa NF")),
      body: Column(
        children: [
          // 1. Search & Filter: Tetap muncul di paling atas
          _buildSearchAndFilter(authState.token!),

          Expanded(
            child: BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                // 3. Loading awal menggunakan Shimmer
                if (state.isLoading) {
                  return _buildShimmerLoading();
                }

                // 2. Placeholder terpusat (Satu widget untuk dua kondisi)
                if (state.students.isEmpty) {
                  return _buildEmptyState(
                    isSearching:
                        state.search.isNotEmpty || state.jurusan != 'Semua',
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.hasReachedMax
                      ? state.students.length
                      : state.students.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.students.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final student = state.students[index];
                    return _buildStudentCard(context, student);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true && context.mounted) {
            context.read<StudentBloc>().add(
              FetchStudents(token: authState.token!),
            );
            _searchController.clear();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSearchAndFilter(String token) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari Nama/NISN...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              onSubmitted: (value) {
                context.read<StudentBloc>().add(
                  FetchStudents(
                    search: value,
                    jurusan: _selectedJurusan,
                    token: token,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              value: _selectedJurusan,
              underline: const SizedBox(),
              items: AppConstants.jurusanOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() => _selectedJurusan = val!);
                context.read<StudentBloc>().add(
                  FetchStudents(
                    search: _searchController.text,
                    jurusan: val!,
                    token: token,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required bool isSearching}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.person_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? "Siswa tidak ditemukan"
                : "Belum ada data siswa terdaftar",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            isSearching
                ? "Coba gunakan kata kunci atau filter lain"
                : "Ketuk tombol + untuk menambah siswa baru",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Container(height: 80, width: double.infinity),
          ),
        );
      },
    );
  }

  Widget _buildStudentCard(BuildContext context, dynamic student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.secondary.withOpacity(0.2),
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          student.namaLengkap,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("NISN: ${student.nisn} | Jurusan: ${student.jurusan}"),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          final token = context.read<AuthCubit>().state.token!;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    StudentDetailBloc(StudentService())
                      ..add(FetchStudentDetail(student.nisn, token)),
                child: StudentDetailView(nisn: student.nisn),
              ),
            ),
          );
        },
      ),
    );
  }
}
