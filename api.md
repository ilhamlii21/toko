# Dokumentasi API: Key-Value Store (app_cache)

Dokumentasi ini menjelaskan implementasi basis data NoSQL tipe **Key-Value** menggunakan Supabase REST API untuk keperluan praktikum Basis Data.

## 1. Konsep Dasar (Referensi Modul)
* [cite_start]**Definisi**: Data disimpan dalam pasangan kunci/nilai (key/value) sebagai array byte[cite: 25].
* [cite_start]**Struktur**: Menggunakan tabel hash di mana setiap kunci (key) bersifat unik[cite: 27].
* [cite_start]**Fleksibilitas**: Nilai (value) dapat berupa JSON, BLOB, string, atau angka[cite: 27].
* [cite_start]**Karakteristik**: Performa tinggi, sangat skalabel, dan kompleksitas rendah[cite: 26].

## 2. Informasi Endpoint
* **Base URL**: `https://ebjemienphzgoxibttwe.supabase.co/rest/v1/app_cache`
* [cite_start]**Format Data**: JSON (Semi-terstruktur)[cite: 10].
* **Autentikasi**: Memerlukan `apikey` dan `Authorization` (Bearer Token) pada Header.

## 3. Struktur Tabel (Schema)
[cite_start]Tabel ini merepresentasikan penyimpanan tanpa skema tetap (*schema-less*)[cite: 29].

| Atribut | Tipe Data | Deskripsi |
| :--- | :--- | :--- |
| `key` | `varchar` (PK) | [cite_start]Kunci unik pengidentifikasi data (Unique Identifier)[cite: 106]. |
| `value` | `jsonb` | [cite_start]Konten data (mendukung string, integer, dan objek JSON)[cite: 27]. |
| `update_at` | `timestamp` | Waktu modifikasi terakhir (opsional). |

## 4. Contoh Data Terkelola
Berdasarkan kueri terbaru, berikut adalah representasi data dalam tabel:

```json
[
    {
        "key": "config_api",
        "value": { "retry": true, "timeout": 30 },
        "update_at": null
    },
    {
        "key": "last_session",
        "value": 1714200000,
        "update_at": null
    },
    {
        "key": "promo_banner",
        "value": {
            "id": "eid_01",
            "active": true,
            "image_url": "[https://link-gambar.com](https://link-gambar.com)"
        },
        "update_at": null
    }
]