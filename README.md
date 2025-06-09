# Maroon App

**Maroon App** adalah aplikasi presensi berbasis Flutter yang menggabungkan teknologi **Face Recognition** dan **Geolocation** untuk memastikan kehadiran pengguna secara aman dan akurat. Aplikasi ini dibuat sebagai proyek personal yang menunjukkan kemampuan dalam pengembangan aplikasi mobile menggunakan Flutter dan berbagai teknologi pendukung.

## 🚀 Fitur Utama

- 🔒 **Face Recognition**
  - Menggunakan kamera untuk registrasi dan verifikasi wajah pengguna.
  - Perbandingan wajah dilakukan secara lokal menggunakan model MobileFaceNet.
  
- 📍 **Geolocation-based Attendance**
  - Menggunakan lokasi GPS untuk memastikan pengguna berada di area yang telah ditentukan saat melakukan presensi.
  - Presensi hanya dapat dilakukan jika pengguna berada di dalam radius yang diizinkan.

- 💾 **Penyimpanan Data**
  - Data wajah disimpan secara lokal dan juga diunggah ke Firebase untuk cadangan.
  - Presensi dan informasi pengguna disimpan di Firebase Firestore.

- 👨‍💼 **Admin Panel (Aplikasi Terpisah)**
  - Aplikasi monitoring khusus admin untuk melihat aktivitas presensi secara real-time.

## 🛠️ Teknologi yang Digunakan

- **Flutter** – Framework utama pengembangan aplikasi.
- **MobileFaceNet** – Model face recognition ringan untuk perangkat mobile.
- **Firebase** – Autentikasi, penyimpanan data pengguna, dan presensi.
- **Geolocator** – Mendapatkan lokasi pengguna secara akurat.

## 📸 Cara Kerja Face Recognition

1. Pengguna melakukan registrasi wajah menggunakan kamera.
2. Embedding wajah disimpan secara lokal dan di Firebase.
3. Saat presensi, wajah pengguna dibandingkan dengan embedding yang sudah terdaftar.
4. Jika wajah cocok dan lokasi sesuai, presensi dianggap berhasil.

## 🌍 Geolocation Flow

- Aplikasi meminta izin lokasi.
- Lokasi pengguna dibandingkan dengan lokasi kantor/sekolah yang ditentukan.
- Radius ditentukan untuk area presensi (belum menggunakan poligon).

## 🔐 Keamanan

- Data penting disimpan aman di Firebase.
- Verifikasi wajah mencegah user palsu melakukan presensi.

## 🧪 Status Pengembangan

✅ Versi MVP selesai  
🔜 Rencana pengembangan selanjutnya:
- Menambahkan **Geo-fencing** untuk presisi lokasi.
- Sistem verifikasi wajah saat registrasi akun untuk mencegah penyalahgunaan.

## 👨‍💻 Kontributor

- **Bayu Ilham** – Flutter Developer & Project Owner  

---

