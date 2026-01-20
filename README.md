# NF Tech Test App 
Aplikasi Manajemen Data Siswa yang dibangun dengan Flutter sebagai bagian dari technical test. Aplikasi ini mengimplementasikan fitur manajemen state tingkat lanjut, sinkronisasi offline, dan push notifikasi.

## Kredensial Demo App
* username : admin1/admin2/admin3
* password : admin

## 🚀 Fitur Utama
* **Manajemen Siswa**: Tambah dan lihat daftar siswa dengan antarmuka yang sederhana.
* **Pencarian & Filter**: Filter berdasarkan jurusan dan pencarian nama secara real-time.
* **Mode Offline (Hydrated BLoC)**: Simpan data siswa secara lokal saat tidak ada internet dan sinkronisasi otomatis saat kembali online.
* **Push Notification**: Integrasi Firebase Cloud Messaging untuk pemberitahuan real-time.
* **Manajemen Tema**: Mendukung Dark Mode dan Light Mode.
* **Arsitektur BLoC**: Menggunakan library `flutter_bloc` untuk memisahkan logika bisnis dari UI.

## 🛠️ Tech Stack
* **Framework**: Flutter
* **State Management**: Flutter BLoC & Hydrated BLoC
* **Networking**: Dio (HTTP Client)
* **Backend Integration**: Firebase (FCM & Analytics)
* **Local Storage**: Hydrated Storage (Path Provider)
* **Testing**: Bloc Test, Mocktail

## ⚙️ Persiapan & Instalasi
### Persiapan
* Flutter SDK (Versi terbaru direkomendasikan)
* Dart SDK
* Android Studio / VS Code
* Backend REST API **by Arsyad** - [nf-tech-test-api](https://github.com/arsyad-id-99/nf-tech-test-api)

###  Instalasi
1. **Clone Repositori** 
```
git clone https://github.com/arsyad-id-99/nf-tech-test-app.git
cd nf-tech-test-app
```
2. **Install Dependencies**
```
flutter pub get
```
3. **Konfigurasi Firebase**
* Pastikan Anda sudah meletakkan file `google-services.json` di direktori `android/app/`.

4. **Jalankan Aplikasi**
```
flutter run
```

## 📂 Struktur Proyek
```
lib/
├── data/
│   ├── models/       # Data model (JSON Serialization)
│   ├── services/     # API/Network services (Dio)
├── features/
│   ├── auth/         # Login & Authentication logic
│   ├── students/     # Student List, Add, and Detail features
│   ├── settings/     # Theme & App configuration
├── common/           # Notification service & shared constants
└── main.dart         # Entry point & Global Provider setup
```

## 🧪 Pengujian
Proyek ini dilengkapi dengan unit test untuk memastikan integritas data dan validitas logika bisnis (BLoC).

**Menjalankan Test**
```
flutter test
```
**Cakupan Test:**
* `student_model_test.dart`: Memastikan pemetaan JSON ke objek benar.
* `student_bloc_test.dart`: Memastikan aliran state (Loading -> Success/Error) berfungsi.

#### Author
**Arsyad** - [@arsyad-id-99](https://github.com/arsyad-id-99).

