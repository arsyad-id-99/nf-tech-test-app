import 'package:flutter/material.dart';

class StudentDetailView extends StatelessWidget {
  const StudentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Siswa")),
      body: const Center(child: Text("Detail Siswa akan ditampilkan di sini")),
    );
  }
}
