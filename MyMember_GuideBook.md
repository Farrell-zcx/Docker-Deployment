<p align="center">
  <img src="mymember/public/images/logo.png" alt="MyMember Logo" width="100" />
</p>

<h1 align="center">📘 MyMember — Guide Book</h1>

<p align="center">
  <strong>Panduan Penggunaan Aplikasi Manajemen Keanggotaan</strong><br/>
  <em>Versi 1.0 — Oktober 2026</em>
</p>

---

## Daftar Isi

1. [Pendahuluan](#1-pendahuluan)
2. [Prasyarat & Akses Aplikasi](#2-prasyarat--akses-aplikasi)
3. [Login ke MyMember (via SSO Engine)](#3-login-ke-mymember-via-sso-engine)
4. [Dashboard — Ringkasan Operasional](#4-dashboard--ringkasan-operasional)
5. [Kelola Member (CRUD + OCR)](#5-kelola-member-crud--ocr)
   - 5.1 [Tambah Member Baru (Manual)](#51-tambah-member-baru-manual)
   - 5.2 [Tambah Member dengan Scan KTP (OCR)](#52-tambah-member-dengan-scan-ktp-ocr)
   - 5.3 [Edit Data Member](#53-edit-data-member)
   - 5.4 [Hapus Member](#54-hapus-member)
6. [Daftar Member (Read-Only)](#6-daftar-member-read-only)
7. [Kiosk Controller — Remote Kiosk & Live Camera Feed](#7-kiosk-controller--remote-kiosk--live-camera-feed)
8. [Check-in Member via Kiosk (Tablet)](#8-check-in-member-via-kiosk-tablet)
9. [Riwayat Kunjungan & Export](#9-riwayat-kunjungan--export)
   - 9.1 [Melihat & Filter Riwayat](#91-melihat--filter-riwayat)
   - 9.2 [Export ke Excel (.xlsx)](#92-export-ke-excel-xlsx)
   - 9.3 [Export ke PDF](#93-export-ke-pdf)
10. [Email Reminder Otomatis (H-2 Expired)](#10-email-reminder-otomatis-h-2-expired)
11. [Kelola Pengguna Admin](#11-kelola-pengguna-admin)
12. [Logout & Single Logout (SLO)](#12-logout--single-logout-slo)
13. [FAQ & Troubleshooting](#13-faq--troubleshooting)

---

## 1. Pendahuluan

**MyMember** adalah aplikasi web untuk mengelola keanggotaan (membership) di tempat usaha seperti gym, coworking space, atau club. Sistem ini menggantikan proses check-in manual dengan **pemindaian KTP otomatis** menggunakan teknologi OCR (Optical Character Recognition).

### Apa yang Bisa Dilakukan MyMember?

| Fitur | Keterangan |
|-------|------------|
| **Smart OCR Check-in** | Scan KTP via kamera tablet, NIK & Nama terdeteksi otomatis |
| **Remote Kiosk Control** | Admin bisa mengendalikan kamera tablet kiosk dari dashboard desktop |
| **Live Camera Feed** | Pantau kamera kiosk secara real-time dari panel admin |
| **Kelola Member** | Tambah, edit, hapus data member dengan mudah |
| **Auto-fill via OCR** | Data NIK & Nama otomatis terisi dari hasil scan KTP |
| **Riwayat Kunjungan** | Lihat log check-in member dengan filter tanggal |
| **Export Excel & PDF** | Download laporan kunjungan dalam format Excel atau PDF |
| **Email Reminder H-2** | Notifikasi otomatis 2 hari sebelum membership expired |
| **Single Sign-On (SSO)** | Login terpusat via SSO Engine, satu akun untuk semua aplikasi |

---

## 2. Prasyarat & Akses Aplikasi

Sebelum menggunakan MyMember, pastikan hal-hal berikut sudah terpenuhi:

### Untuk Admin/Resepsionis:
- ✅ **Akun SSO sudah dibuatkan** oleh Admin SSO Pusat
- ✅ **Akses ke aplikasi MyMember sudah diberikan** oleh Admin SSO Pusat (Lapis 2)
- ✅ **Password sudah diaktifkan** melalui email aktivasi yang diterima

### URL Akses:

| Lingkungan | URL |
|------------|-----|
| Lokal (Laragon) | `http://mymember.test` |
| Docker (localhost) | `http://mymember.localhost` |
| Produksi | Sesuai konfigurasi domain perusahaan |

### Browser yang Didukung:
- Google Chrome (direkomendasikan)
- Mozilla Firefox
- Microsoft Edge

> **💡 Tips:** Gunakan resolusi layar minimal **1280×720** untuk pengalaman terbaik.

---

## 3. Login ke MyMember (via SSO Engine)

MyMember menggunakan **Single Sign-On (SSO)** untuk autentikasi. Anda **tidak perlu** membuat akun terpisah di MyMember — cukup gunakan akun SSO yang sudah dibuat oleh Admin SSO Pusat.

### Langkah-langkah Login:

**Langkah 1:** Buka URL MyMember di browser.

> 📸 **[SCREENSHOT: Halaman utama MyMember yang otomatis redirect ke SSO Engine]**

**Langkah 2:** Anda akan otomatis diarahkan ke halaman login SSO Engine. Masukkan **email atau username** dan **password** SSO Anda.

> 📸 **[SCREENSHOT: Form login SSO Engine dengan field email/username dan password]**

**Langkah 3:** Jika Anda sudah pernah login ke SSO Engine sebelumnya (misalnya dari Inventory), akan muncul layar konfirmasi untuk melanjutkan dengan akun yang sama atau beralih akun.

> 📸 **[SCREENSHOT: Layar konfirmasi "Continue as [username]" atau "Switch Account"]**

**Langkah 4:** Setelah login berhasil, Anda akan diarahkan kembali ke **Dashboard MyMember**.

> 📸 **[SCREENSHOT: Dashboard MyMember setelah berhasil login]**

### ⚠️ Error yang Mungkin Muncul:

| Pesan Error | Penyebab | Solusi |
|-------------|----------|--------|
| "Anda belum memiliki akses ke aplikasi ini" | Admin SSO belum memberikan akses MyMember | Hubungi Admin SSO untuk memberikan akses |
| "Email atau password salah" | Kredensial login tidak tepat | Periksa kembali email dan password |
| "State tidak valid" | Sesi otorisasi kedaluwarsa | Refresh halaman dan coba login ulang |

---

## 4. Dashboard — Ringkasan Operasional

Setelah login, Anda akan masuk ke halaman **Dashboard** yang menampilkan ringkasan operasional secara real-time.

> 📸 **[SCREENSHOT: Halaman Dashboard lengkap dengan semua kartu KPI dan tabel log kunjungan]**

### Informasi yang Ditampilkan:

#### Kartu KPI (Key Performance Indicator)

| Kartu | Informasi |
|-------|-----------|
| **Pengunjung Hari Ini** | Jumlah check-in member sejak tengah malam hari ini |
| **Total Member Aktif** | Jumlah seluruh member yang terdaftar di sistem |

> 📸 **[SCREENSHOT: Close-up kartu KPI "Pengunjung Hari Ini" dan "Total Member Aktif"]**

#### Log Kunjungan Real-time

Di bawah kartu KPI, terdapat tabel log kunjungan terbaru yang **auto-update** tanpa perlu refresh halaman.

> 📸 **[SCREENSHOT: Tabel log kunjungan real-time di dashboard]**

### Navigasi Sidebar

Di sisi kiri terdapat sidebar navigasi untuk berpindah antar menu:

| Menu | Keterangan |
|------|------------|
| 🏠 **Dashboard** | Halaman ringkasan (halaman ini) |
| 📋 **Kelola Member** | CRUD member + integrasi OCR |
| 👥 **Daftar Member** | Daftar member read-only |
| 📷 **Kiosk Controller** | Remote kontrol kamera kiosk tablet |
| 📊 **Riwayat Kunjungan** | Log kunjungan + export Excel/PDF |
| 👤 **Kelola Pengguna** | Daftar admin yang terdaftar |

> 📸 **[SCREENSHOT: Sidebar navigasi MyMember dengan semua menu terlihat]**

---

## 5. Kelola Member (CRUD + OCR)

Menu **Kelola Member** adalah fitur utama untuk menambah, mengedit, dan menghapus data member. Halaman ini juga terintegrasi dengan fitur **Scan KTP (OCR)** untuk mengisi data secara otomatis.

> 📸 **[SCREENSHOT: Halaman Kelola Member lengkap — form di kiri, tabel member di kanan]**

### 5.1 Tambah Member Baru (Manual)

**Langkah 1:** Klik menu **"Kelola Member"** di sidebar.

**Langkah 2:** Isi form di sebelah kiri halaman:

| Field | Keterangan | Wajib? |
|-------|------------|--------|
| **Nomor NIK** | 16 digit NIK dari KTP | ✅ Ya |
| **Nama Lengkap** | Nama sesuai KTP | ✅ Ya |
| **Nomor HP** | Nomor handphone member | ✅ Ya |
| **Email** | Alamat email member | ✅ Ya |
| **Tipe Member** | Pilih dari dropdown tipe membership | ✅ Ya |

> 📸 **[SCREENSHOT: Form input member dengan semua field terisi contoh data]**

**Langkah 3:** Klik tombol **"Simpan"** untuk menyimpan data member baru.

> ✅ Kuota dan tanggal expired akan **otomatis terisi** berdasarkan tipe member yang dipilih.

> 📸 **[SCREENSHOT: Notifikasi sukses "Data member berhasil disimpan!"]**

### 5.2 Tambah Member dengan Scan KTP (OCR)

Fitur ini memungkinkan Anda mengisi data **NIK** dan **Nama Lengkap** secara otomatis dari foto KTP.

**Langkah 1:** Di halaman Kelola Member, klik tombol **"Scan KTP"** atau **ikon kamera**.

> 📸 **[SCREENSHOT: Tombol "Scan KTP" yang ada di halaman Kelola Member]**

**Langkah 2:** Pilih file foto KTP dari komputer Anda, atau gunakan kamera tablet kiosk (lihat bagian [Kiosk Controller](#7-kiosk-controller--remote-kiosk--live-camera-feed)).

> 📸 **[SCREENSHOT: Dialog pemilihan file foto KTP]**

**Langkah 3:** Tunggu proses OCR selesai (biasanya 2-5 detik). Sistem akan menampilkan hasil pembacaan:

| Hasil OCR | Keterangan |
|-----------|------------|
| **NIK** | 16 digit NIK yang terdeteksi dari KTP |
| **Nama** | Nama lengkap yang terbaca dari KTP |

> 📸 **[SCREENSHOT: Hasil OCR dengan NIK dan Nama yang berhasil terdeteksi]**

**Langkah 4:** Field **NIK** dan **Nama Lengkap** akan **terisi otomatis** di form. Lengkapi data lainnya (HP, Email, Tipe Member) dan klik **"Simpan"**.

> 📸 **[SCREENSHOT: Form yang sudah terisi otomatis dari hasil scan KTP]**

### 5.3 Edit Data Member

**Langkah 1:** Di tabel member (sebelah kanan halaman), cari member yang ingin diedit.

**Langkah 2:** Klik tombol **"Edit"** (ikon pensil) pada baris member tersebut.

> 📸 **[SCREENSHOT: Baris tabel member dengan tombol Edit yang ditandai]**

**Langkah 3:** Data member akan muncul di form sebelah kiri. Ubah data yang diperlukan.

**Langkah 4:** Klik tombol **"Update"** untuk menyimpan perubahan.

> 📸 **[SCREENSHOT: Notifikasi sukses "Data member berhasil diperbarui!"]**

### 5.4 Hapus Member

**Langkah 1:** Di tabel member, cari member yang ingin dihapus.

**Langkah 2:** Klik tombol **"Hapus"** (ikon tong sampah) pada baris member tersebut.

**Langkah 3:** Konfirmasi penghapusan pada dialog yang muncul.

> 📸 **[SCREENSHOT: Dialog konfirmasi "Apakah Anda yakin ingin menghapus member ini?"]**

> ⚠️ **Perhatian:** Data member yang dihapus menggunakan mekanisme **soft-delete**, sehingga data tidak benar-benar hilang dari database.

---

## 6. Daftar Member (Read-Only)

Menu **Daftar Member** menampilkan seluruh member yang terdaftar dalam format tabel read-only (tidak bisa diedit dari sini).

> 📸 **[SCREENSHOT: Halaman Daftar Member dengan tabel lengkap semua member]**

### Informasi yang Ditampilkan:

| Kolom | Keterangan |
|-------|------------|
| **NIK** | Nomor Induk Kependudukan |
| **Nama** | Nama lengkap member |
| **HP** | Nomor handphone |
| **Email** | Alamat email |
| **Tipe Member** | Jenis membership |
| **Sisa Kuota** | Jumlah kunjungan tersisa |
| **Expired** | Tanggal kadaluarsa membership |
| **Status** | Aktif / Kuota Habis / Expired |

> 💡 **Tips:** Gunakan halaman ini untuk melihat ringkasan cepat tanpa risiko mengubah data secara tidak sengaja.

---

## 7. Kiosk Controller — Remote Kiosk & Live Camera Feed

Menu **Kiosk Controller** memungkinkan admin untuk mengendalikan kamera tablet kiosk secara remote dan memantau live camera feed dari desktop.

> 📸 **[SCREENSHOT: Halaman Kiosk Controller dengan live camera feed dan tombol kontrol]**

### Cara Menggunakan Kiosk Controller:

**Langkah 1:** Pastikan tablet kiosk sudah diletakkan di posisi check-in dan membuka halaman kiosk (`/ocr`).

**Langkah 2:** Buka menu **"Kiosk Controller"** dari sidebar.

**Langkah 3:** Anda akan melihat **live camera feed** dari tablet kiosk. Indikator status koneksi menunjukkan apakah kiosk sedang online atau offline.

| Indikator | Status |
|-----------|--------|
| 🟢 **Hijau** | Kiosk online, kamera aktif |
| 🔴 **Merah** | Kiosk offline atau tidak terdeteksi |

> 📸 **[SCREENSHOT: Indikator status kiosk "Online" berwarna hijau]**

**Langkah 4:** Saat member menunjukkan KTP di depan kamera, klik tombol **"Take Picture & Scan"** untuk menangkap gambar dan menjalankan proses OCR.

> 📸 **[SCREENSHOT: Tombol "Take Picture & Scan" dan area live camera feed]**

**Langkah 5:** Hasil scan akan muncul di layar tablet kiosk untuk konfirmasi member.

> 📸 **[SCREENSHOT: Tampilan tablet kiosk yang menunjukkan hasil scan KTP]**

---

## 8. Check-in Member via Kiosk (Tablet)

Proses check-in menggunakan tablet kiosk melibatkan dua pihak: **Admin** (di desktop) dan **Member** (di depan tablet kiosk).

### Alur Check-in:

```
Member menunjukkan KTP   ──►   Admin klik "Take Picture & Scan"
         │                              │
         ▼                              ▼
   Kamera kiosk aktif          Tablet menangkap gambar
         │                              │
         ▼                              ▼
   OCR memproses KTP           NIK & Nama terdeteksi
         │                              │
         ▼                              ▼
   Layar konfirmasi           Member menekan "Konfirmasi"
```

### Skenario Hasil Check-in:

| Skenario | Tampilan di Kiosk | Tindakan |
|----------|-------------------|----------|
| ✅ **Member terdaftar, kuota tersedia** | "Selamat datang, [Nama]! Check-in berhasil." | Kuota otomatis berkurang 1 |
| ⚠️ **Member terdaftar, kuota habis** | "Kuota Anda habis. Silakan top-up." | Admin bantu perpanjang membership |
| ⏰ **Member terdaftar, membership expired** | "Membership Anda sudah kadaluarsa." | Admin bantu perpanjang membership |
| ❌ **Belum terdaftar** | "NIK belum terdaftar. Hubungi admin." | Admin daftarkan sebagai member baru |

> 📸 **[SCREENSHOT: Layar tablet kiosk menunjukkan "Check-in berhasil!" untuk member terdaftar]**

> 📸 **[SCREENSHOT: Layar tablet kiosk menunjukkan "Kuota Anda habis" untuk member tanpa kuota]**

> 📸 **[SCREENSHOT: Layar tablet kiosk menunjukkan "NIK belum terdaftar" untuk non-member]**

---

## 9. Riwayat Kunjungan & Export

Menu **Riwayat Kunjungan** menampilkan log seluruh check-in member beserta fitur export data.

> 📸 **[SCREENSHOT: Halaman Riwayat Kunjungan lengkap dengan tabel dan tombol export]**

### 9.1 Melihat & Filter Riwayat

**Langkah 1:** Klik menu **"Riwayat Kunjungan"** di sidebar.

**Langkah 2:** Tabel akan menampilkan log kunjungan terbaru. Gunakan **filter tanggal** untuk mempersempit pencarian.

| Field Filter | Keterangan |
|-------------|------------|
| **Tanggal Mulai** | Batas awal periode yang ingin ditampilkan |
| **Tanggal Akhir** | Batas akhir periode yang ingin ditampilkan |

> 📸 **[SCREENSHOT: Filter tanggal yang sudah diisi dengan rentang tanggal tertentu]**

**Langkah 3:** Klik tombol **"Filter"** atau **"Cari"** untuk menerapkan filter.

### Informasi yang Ditampilkan:

| Kolom | Keterangan |
|-------|------------|
| **No** | Nomor urut |
| **NIK** | NIK member yang check-in |
| **Nama** | Nama member |
| **Waktu Check-in** | Tanggal dan jam check-in |
| **Kuota Awal** | Kuota sebelum check-in |
| **Kuota Akhir** | Kuota setelah check-in (otomatis -1) |

### 9.2 Export ke Excel (.xlsx)

**Langkah 1:** Atur filter tanggal sesuai kebutuhan (opsional).

**Langkah 2:** Klik tombol **"Export Excel"** (ikon spreadsheet).

> 📸 **[SCREENSHOT: Tombol "Export Excel" yang ditandai dengan ikon spreadsheet]**

**Langkah 3:** File Excel akan otomatis terdownload ke komputer Anda.

> 📸 **[SCREENSHOT: Contoh file Excel hasil export yang dibuka di Microsoft Excel]**

### 9.3 Export ke PDF

**Langkah 1:** Atur filter tanggal sesuai kebutuhan (opsional).

**Langkah 2:** Klik tombol **"Export PDF"** (ikon PDF).

> 📸 **[SCREENSHOT: Tombol "Export PDF" yang ditandai dengan ikon PDF]**

**Langkah 3:** File PDF akan otomatis terdownload atau terbuka di tab baru browser.

> 📸 **[SCREENSHOT: Contoh file PDF hasil export yang berisi laporan kunjungan]**

---

## 10. Email Reminder Otomatis (H-2 Expired)

MyMember memiliki fitur **notifikasi email otomatis** yang dikirim ke member **2 hari sebelum membership-nya kadaluarsa**.

### Cara Kerja:

1. Sistem memeriksa seluruh member yang membership-nya akan expired dalam 2 hari ke depan.
2. Email reminder dikirimkan secara otomatis melalui SMTP (Gmail / Mailtrap).
3. Flag `reminder_terkirim` mencegah pengiriman email ganda.
4. Flag otomatis di-reset jika data member di-update.

### Jadwal Pengiriman:

| Waktu | Keterangan |
|-------|------------|
| **07:00 WIB** | Pengiriman reminder pagi |
| **18:00 WIB** | Pengiriman reminder sore |

> 📸 **[SCREENSHOT: Contoh email reminder yang diterima member di inbox]**

> 💡 **Catatan:** Fitur ini berjalan otomatis di background. Admin tidak perlu melakukan tindakan manual apapun selama konfigurasi SMTP sudah benar.

### Tes Manual (Opsional):

Jika ingin menguji pengiriman email secara manual, jalankan perintah berikut di terminal:

```bash
php spark email:reminder
```

---

## 11. Kelola Pengguna Admin

Menu **Kelola Pengguna** menampilkan daftar admin/resepsionis yang telah dibuat melalui SSO Engine dan memiliki akses ke MyMember.

> 📸 **[SCREENSHOT: Halaman Kelola Pengguna dengan daftar admin yang terdaftar]**

### Informasi yang Ditampilkan:

| Kolom | Keterangan |
|-------|------------|
| **Username** | Username admin |
| **Email** | Email SSO yang terhubung |
| **Nama Resepsionis** | Nama yang ditampilkan di sistem |
| **SSO User ID** | ID unik dari SSO Engine |
| **Terakhir Disinkronkan** | Waktu terakhir data disinkronkan dari SSO |

> ⚠️ **Penting:** Untuk menambah admin baru, prosesnya dilakukan di **SSO Engine** (bukan di MyMember). Lihat [SSO Engine Guide Book](SSO_Engine_GuideBook.md) untuk detailnya.

---

## 12. Logout & Single Logout (SLO)

MyMember mendukung **Single Logout (SLO)** yang terkoordinasi dengan SSO Engine. Saat Anda logout dari MyMember, sesi di **semua aplikasi** yang menggunakan SSO Engine (termasuk Inventory) akan **otomatis berakhir**.

### Langkah Logout:

**Langkah 1:** Klik tombol **"Logout"** di sidebar atau topbar.

> 📸 **[SCREENSHOT: Tombol Logout yang ada di sidebar/topbar]**

**Langkah 2:** Sistem akan:
1. Memanggil SSO Engine untuk me-revoke semua refresh token.
2. Memasukkan token aktif ke Redis Blacklist.
3. Menghapus sesi lokal MyMember.
4. Mengarahkan Anda kembali ke halaman login.

> 📸 **[SCREENSHOT: Halaman login setelah berhasil logout]**

> ⚠️ **Perhatian:** Setelah logout, jika Anda masih memiliki tab Inventory yang terbuka, sesi di Inventory juga akan **otomatis terlogout** pada request berikutnya (dalam 0 detik jika Redis aktif).

---

## 13. FAQ & Troubleshooting

### ❓ Saya tidak bisa login, muncul pesan "Anda belum memiliki akses ke aplikasi ini."

**Penyebab:** Admin SSO Pusat belum memberikan akses aplikasi MyMember ke akun Anda.

**Solusi:** Hubungi Admin SSO Pusat dan minta mereka memberikan akses ke aplikasi **MyMember** melalui menu "Kelola Akses" di SSO Engine.

---

### ❓ Hasil scan KTP tidak akurat, NIK salah.

**Penyebab:** Foto KTP buram, terlalu gelap, atau posisi KTP tidak lurus.

**Solusi:**
- Pastikan KTP dalam posisi **tegak dan rata** di depan kamera.
- Pastikan **pencahayaan cukup** (hindari bayangan dan pantulan).
- Bersihkan lensa kamera tablet jika kotor.
- Jika tetap gagal, input data secara manual.

---

### ❓ Live camera feed di Kiosk Controller tidak muncul.

**Penyebab:** Tablet kiosk tidak terhubung ke jaringan atau halaman kiosk belum dibuka.

**Solusi:**
- Pastikan tablet kiosk terhubung ke **jaringan WiFi yang sama**.
- Pastikan halaman kiosk (`/ocr`) sudah terbuka di browser tablet.
- Cek indikator status koneksi — jika merah, tablet sedang offline.

---

### ❓ Email reminder tidak terkirim.

**Penyebab:** Konfigurasi SMTP belum benar.

**Solusi:**
- Periksa konfigurasi SMTP di file `.env`:
  ```ini
  email.SMTPHost = "smtp.gmail.com"
  email.SMTPUser = "your-email@gmail.com"
  email.SMTPPass = "xxxx xxxx xxxx xxxx"   # App Password
  email.SMTPPort = 587
  email.SMTPCrypto = "tls"
  ```
- Jika menggunakan Gmail, pastikan sudah membuat **App Password** (bukan password akun biasa).
- Tes manual dengan: `php spark email:reminder`

---

### ❓ Setelah logout, saya masih bisa mengakses dashboard.

**Penyebab:** Cache browser atau sesi lokal belum benar-benar terhapus.

**Solusi:**
- Buka URL `http://mymember.test/admin/session-fix` untuk membersihkan sesi secara paksa.
- Atau bersihkan cookies browser untuk domain `mymember.test`.

---

<p align="center">
  <strong>— Akhir Guide Book MyMember —</strong><br/>
  <sub>Dokumen ini disusun untuk membantu admin/resepsionis menggunakan aplikasi MyMember secara optimal.</sub><br/>
  <sub>© 2026 MyMember. All rights reserved.</sub>
</p>
