# 💸 Atur Kas

Aplikasi pencatatan keuangan personal sederhana berbasis Flutter yang membantu pengguna mencatat pemasukan, pengeluaran, dan memantau saldo secara praktis dengan tampilan modern.

---

## ✨ Fitur Utama

### 📊 Dashboard Ringkas

* Menampilkan saldo saat ini
* Ringkasan pemasukan & pengeluaran bulan berjalan
* Riwayat transaksi bulan berjalan

### ➕ Tambah Transaksi

* Input pemasukan & pengeluaran
* Tanggal otomatis (default hari ini)
* Kategori opsional

### 📈 Laporan

* Filter berdasarkan:

  * Periode (harian / bulanan / tahunan)
  * Jenis transaksi
  * Kategori

### 🧾 Riwayat Transaksi

* Tampilan modern dan clean
* Informasi kategori & tanggal
* Indicator pemasukan / pengeluaran

### 🔒 Offline First

* Data disimpan lokal menggunakan `GetStorage`
* Tidak membutuhkan koneksi internet

### 📄 Kebijakan & Info Aplikasi

* Halaman terpisah untuk:

  * Kebijakan & Privasi
  * Syarat & Ketentuan
  * Informasi aplikasi

---

## 🧱 Arsitektur

Aplikasi menggunakan arsitektur modular berbasis GetX:

```plaintext
lib/
│
├── data/
│   └── models/
│
├── modules/
│   ├── dashboard/
│   ├── transaksi/
│   ├── laporan/
│   ├── info_app/
│   ├── kebijakan/
│   └── main_nav/
│
├── routes/
├── services/
├── shared/
│   ├── themes/
│   └── utils/
│
└── main.dart
```

---

## ⚙️ Tech Stack

### 🚀 Core

* **Flutter** → UI Framework
* **Dart** → Programming Language

### 🧠 State Management

* **GetX**

  * Reactive state (`Obx`)
  * Dependency Injection
  * Routing

### 💾 Local Storage

* **GetStorage**

  * Lightweight key-value storage
  * Offline-first architecture
  * Fast read/write

### 🌐 Internationalization & Formatting

* **intl**

  * Format mata uang (Rupiah)
  * Format tanggal (Indonesia)

---

## 🎨 Design System

Warna utama aplikasi:

| Role      | Color   |
| --------- | ------- |
| Primary   | #6367FF |
| Secondary | #8494FF |
| Tertiary  | #C9BEFF |
| Accent    | #FFDBFD |

---
