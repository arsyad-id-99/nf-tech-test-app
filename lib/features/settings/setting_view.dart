import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nf_tech_test_app/features/theme/theme_cubit.dart';
import '../auth/auth_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan"), centerTitle: true),
      body: ListView(
        children: [
          // Bagian Dark Mode
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) {
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text("Mode Gelap"),
                subtitle: const Text("Ubah tampilan aplikasi"),
                value: state == ThemeMode.dark,
                onChanged: (bool value) {
                  // Panggil fungsi toggle di ThemeCubit Anda
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          const Divider(),

          // Bagian Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Keluar Akun",
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text("Akhiri sesi admin"),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  // Dialog Konfirmasi Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // 1. Hapus token di AuthCubit
                context.read<AuthCubit>().logout();

                // 2. Tutup dialog
                Navigator.pop(dialogContext);

                // 3. Kembali ke halaman login dan hapus semua history navigasi
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text(
                "Keluar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
