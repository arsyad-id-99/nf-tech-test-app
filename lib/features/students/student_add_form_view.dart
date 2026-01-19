import 'package:flutter/material.dart';

class StudentAddFormView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  StudentAddFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pendaftaran Siswa")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
              validator: (v) => v!.isEmpty ? "Nama tidak boleh kosong" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: "NISN"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kelas"),
              items: ["10-A", "10-B", "11-A", "11-B"].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Trigger Submit Event ke BLoC
                }
              },
              child: const Text("Simpan Data"),
            ),
          ],
        ),
      ),
    );
  }
}
