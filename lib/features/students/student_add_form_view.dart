import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nf_tech_test_app/features/auth/auth_cubit.dart';
import 'package:nf_tech_test_app/features/students/bloc/student_add_bloc.dart'; // Tambahkan package intl di pubspec.yaml

class StudentAddFormView extends StatefulWidget {
  const StudentAddFormView({super.key});

  @override
  State<StudentAddFormView> createState() => _StudentAddFormViewState();
}

class _StudentAddFormViewState extends State<StudentAddFormView> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  final _tglLahirController = TextEditingController();

  String? _selectedJurusan;

  // Fungsi untuk memunculkan kalender
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2007),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tglLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Helper function untuk menampilkan dialog loading
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Menyimpan data siswa..."),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Siswa Baru")),
      body: BlocListener<StudentAddBloc, StudentAddState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.isSuccess != current.isSuccess ||
            previous.error != current.error,
        listener: (context, state) {
          // 1. Jika state berubah menjadi loading, tampilkan popup
          if (state.isLoading) {
            _showLoadingDialog(context);
          }

          // 2. Jika proses selesai (Sukses atau Error), tutup popup
          if (!state.isLoading && (state.isSuccess || state.error != null)) {
            // Menutup dialog loading
            Navigator.of(context, rootNavigator: true).pop();
          }

          // 3. Aksi lanjutan setelah popup ditutup
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Data berhasil disimpan"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Kembali ke halaman List
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nisnController,
                decoration: const InputDecoration(
                  labelText: "NISN",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "NISN wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tglLahirController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Tanggal Lahir",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _selectDate(context),
                validator: (v) =>
                    v!.isEmpty ? "Tanggal lahir wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Jurusan",
                  border: OutlineInputBorder(),
                ),
                items: ['IPA', 'IPS', 'Bahasa']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedJurusan = val),
                validator: (v) => v == null ? "Jurusan wajib dipilih" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final token = context.read<AuthCubit>().state.token ?? '';

                    context.read<StudentAddBloc>().add(
                      AddStudentSubmitted(
                        data: {
                          "namaLengkap": _namaController.text,
                          "nisn": _nisnController.text,
                          "tanggalLahir": _tglLahirController.text,
                          "jurusan": _selectedJurusan,
                        },
                        token: token,
                      ),
                    );
                  }
                },
                child: const Text("Simpan Data Siswa"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
