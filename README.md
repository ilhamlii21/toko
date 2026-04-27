# Toko - Supabase Key-Value App

Proyek Flutter ini mendemonstrasikan penggunaan arsitektur **Key-Value Based** dengan memanfaatkan Supabase sebagai backend storage. 

## Apa itu Key-Value Based?

Konsep **Key-Value Based** adalah paradigma penyimpanan data di mana setiap item data disimpan sebagai kumpulan pasangan kunci (Key) dan nilai (Value). Pendekatan ini sangat berbeda dengan database relasional (SQL) tradisional yang menggunakan struktur tabel dengan baris dan kolom yang kaku.

Dalam proyek ini:
- **Key**: Bertindak sebagai identifier unik (ID) untuk mencari data (misalnya: "cart_user_1", "app_config").
- **Value**: Berisi data yang sebenarnya. Value bisa berupa tipe data sederhana (teks/angka) atau struktur kompleks seperti format **JSON** yang menyimpan banyak atribut tanpa batas skema (schema-less).

## Implementasi pada Proyek

Aplikasi ini menggunakan tabel `app_cache` pada Supabase untuk menyimpan data dengan struktur Key-Value.

1. **Fleksibilitas Data (Schema-less)**
   Pada antarmuka aplikasi, pengguna dapat memasukkan Key spesifik dan Value yang dapat berupa teks biasa maupun struktur JSON dinamis (contoh: `{"nama": "Produk A", "harga": 10000}`). Sistem secara otomatis memparsing teks JSON ini menjadi struktur data yang utuh.

2. **Operasi CRUD berbasis Key**
   - **Create (POST)**: Menambahkan pasangan Key-Value baru.
   - **Read (GET)**: Mengambil seluruh data Key-Value atau mengambil Value spesifik berdasarkan Key.
   - **Update (PATCH)**: Memperbarui Value dari suatu Key yang sudah ada tanpa mengubah baris/dokumen lain.

## Keuntungan Pendekatan Ini

1. **Pengembangan yang Cepat & Dinamis**: Jika ada kebutuhan penambahan atribut pada produk atau keranjang belanja, Anda tidak perlu mengubah skema database (misal: melakukan migrasi atau `ALTER TABLE`). Anda cukup menambahkan field baru di dalam JSON pada Value.
2. **Performa Tinggi**: Sangat efisien untuk operasi baca-tulis sederhana yang menggunakan identifier pasti (Key).
3. **Cocok untuk Fitur Tertentu**: Pendekatan ini sangat ideal digunakan untuk fitur seperti *Shopping Cart* (keranjang belanja sementara), *App Preferences* (pengaturan preferensi aplikasi pengguna), atau *Caching* data yang sering diakses.

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
