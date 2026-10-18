<h1 align="center">🛡️ SSO Engine — Guide Book</h1>

<p align="center">
  <strong>Panduan Penggunaan Sistem Autentikasi & Otorisasi Terpusat</strong><br/>
  <em>Versi 1.0 — Oktober 2026</em>
</p>

---

## Daftar Isi

1. [Pendahuluan](#1-pendahuluan)
2. [Konsep Otorisasi 3 Lapis](#2-konsep-otorisasi-3-lapis)
3. [Role & Tanggung Jawab Pengguna SSO Engine](#3-role--tanggung-jawab-pengguna-sso-engine)
4. [Prasyarat & Akses SSO Engine](#4-prasyarat--akses-sso-engine)
5. [Login Admin SSO Pusat](#5-login-admin-sso-pusat)
6. [Dashboard Admin SSO — Kelola Pengguna (Lapis 1)](#6-dashboard-admin-sso--kelola-pengguna-lapis-1)
   - 6.1 [Melihat Daftar Pengguna](#61-melihat-daftar-pengguna)
   - 6.2 [Menambah Pengguna Baru](#62-menambah-pengguna-baru)
   - 6.3 [Menghapus Pengguna](#63-menghapus-pengguna)
7. [Kelola Akses Aplikasi (Lapis 2)](#7-kelola-akses-aplikasi-lapis-2)
   - 7.1 [Memberikan Akses Aplikasi](#71-memberikan-akses-aplikasi)
   - 7.2 [Mencabut Akses Aplikasi](#72-mencabut-akses-aplikasi)
8. [Aktivasi Akun & Reset Password via Email](#8-aktivasi-akun--reset-password-via-email)
   - 8.1 [Alur Aktivasi Akun Baru](#81-alur-aktivasi-akun-baru)
   - 8.2 [Lupa Password (Forgot Password)](#82-lupa-password-forgot-password)
9. [Alur Login SSO untuk Karyawan](#9-alur-login-sso-untuk-karyawan)
10. [Single Logout (SLO)](#10-single-logout-slo)
11. [Flow End-to-End: Onboarding Karyawan Baru](#11-flow-end-to-end-onboarding-karyawan-baru)
12. [FAQ & Troubleshooting](#12-faq--troubleshooting)
13. [Referensi Teknis (untuk Developer)](#13-referensi-teknis-untuk-developer)

---

## 1. Pendahuluan

**SSO Engine** (Single Sign-On Engine) adalah sistem autentikasi dan otorisasi terpusat yang menjadi **satu-satunya pintu masuk** untuk seluruh aplikasi internal perusahaan, termasuk:

- 🏋️ **MyMember** — Aplikasi Manajemen Keanggotaan
- 📦 **Inventory** — Aplikasi Manajemen Inventaris

### Apa Manfaat SSO Engine?

| Manfaat | Keterangan |
|---------|------------|
| **Satu Akun untuk Semua** | Karyawan cukup memiliki 1 akun untuk mengakses semua aplikasi |
| **Kontrol Akses Terpusat** | Admin SSO menentukan siapa boleh mengakses aplikasi apa |
| **Keamanan Tinggi** | JWT RS256, refresh token rotation, Redis blacklist |
| **Single Logout** | Logout dari satu aplikasi = logout dari semua |
| **Aktivasi via Email** | Akun baru diaktifkan secara aman melalui email |

---

## 2. Konsep Otorisasi 3 Lapis

SSO Engine menggunakan model otorisasi **3 lapis** yang memisahkan tanggung jawab secara jelas:

```
┌──────────────────────────────────────────────────────┐
│                   SSO ENGINE (Pusat)                   │
│                                                        │
│  Lapis 1: IDENTITAS                                   │
│  "Siapa orang ini?"                                   │
│  ──► Tabel users (Email, Username, Password)          │
│                                                        │
│  Lapis 2: AKSES APLIKASI                              │
│  "Aplikasi mana yang boleh dia buka?"                 │
│  ──► Tabel user_application_access                    │
└────────────────────────┬─────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────┐
│            CLIENT APP (MyMember / Inventory)           │
│                                                        │
│  Lapis 3: ROLE INTERNAL                               │
│  "Begitu masuk aplikasi, dia jadi apa?"               │
│  ──► Tabel admin (MyMember) / users (Inventory)       │
└──────────────────────────────────────────────────────┘
```

### Analogi Sederhana:

Bayangkan gedung kantor bertingkat:

| Lapis | Analogi | Dikelola Oleh |
|-------|---------|---------------|
| **Lapis 1: Identitas** | Resepsionis lobby menerbitkan **kartu akses** karyawan | Admin SSO Pusat |
| **Lapis 2: Akses Aplikasi** | Resepsionis memprogram kartu agar bisa membuka **pintu lantai tertentu** | Admin SSO Pusat |
| **Lapis 3: Role Internal** | Kepala lantai menentukan **jabatan/meja kerja** karyawan di lantainya | Admin masing-masing aplikasi |

> 📸 **[SCREENSHOT: Diagram 3 lapis otorisasi — bisa berupa diagram dari dashboard atau infografis]**

### Prinsip Keamanan:

> ⚠️ **Jika karyawan belum diberikan akses ke suatu aplikasi (Lapis 2), token tidak akan pernah diterbitkan.** Penolakan terjadi di SSO Engine, sebelum karyawan sampai ke aplikasi tujuan.

---

## 3. Role & Tanggung Jawab Pengguna SSO Engine

| Peran | Tanggung Jawab | Akses di SSO Engine |
|-------|----------------|---------------------|
| **Admin SSO Pusat** | Mengelola akun karyawan, memberikan/mencabut akses aplikasi | Dashboard Admin SSO (`/admin/users`) |
| **Karyawan Biasa** | Login ke aplikasi melalui SSO Engine | Hanya form login (`/authorize`) |
| **Admin Aplikasi** | Menentukan role internal di masing-masing aplikasi | Dashboard Kelola Pengguna di aplikasi masing-masing |

> 💡 **Catatan:** Admin SSO Pusat mengurus **"siapa boleh buka pintu mana"**, sementara Admin Aplikasi mengurus **"setelah masuk, dia jadi apa"**.

---

## 4. Prasyarat & Akses SSO Engine

### Untuk Admin SSO Pusat:
- ✅ Akun sudah terdaftar di tabel `sso_admins` (dibuatkan saat setup awal/seeder)
- ✅ Password sudah diaktifkan melalui email aktivasi
- ✅ Memiliki akses ke halaman admin SSO Engine

### URL Akses:

| Lingkungan | URL Admin SSO | URL Login Karyawan |
|------------|---------------|--------------------|
| Lokal (Laragon) | `http://sso-engine.test/authorize-admin` | `http://sso-engine.test/authorize` |
| Docker (localhost) | `http://sso.localhost/authorize-admin` | `http://sso.localhost/authorize` |
| Produksi | Sesuai konfigurasi domain | Sesuai konfigurasi domain |

---

## 5. Login Admin SSO Pusat

Admin SSO Pusat memiliki **halaman login terpisah** dari login karyawan biasa.

### Langkah-langkah Login:

**Langkah 1:** Buka URL Admin SSO Engine di browser: `/authorize-admin`

> 📸 **[SCREENSHOT: Halaman login admin SSO Engine dengan form email dan password]**

**Langkah 2:** Masukkan **email** dan **password** akun Admin SSO Anda.

**Langkah 3:** Klik tombol **"Login"**. Jika berhasil, Anda akan diarahkan ke **Dashboard Kelola Pengguna**.

> 📸 **[SCREENSHOT: Dashboard Kelola Pengguna SSO Engine setelah login berhasil]**

### ⚠️ Error yang Mungkin Muncul:

| Pesan Error | Penyebab | Solusi |
|-------------|----------|--------|
| "Email atau password salah" | Kredensial tidak tepat | Periksa kembali email dan password |
| "Anda bukan admin SSO" | Akun tidak terdaftar di `sso_admins` | Hubungi admin SSO yang sudah ada atau developer |
| Tidak bisa akses `/authorize-admin` | URL tidak terdaftar di route | Pastikan URL benar dan server berjalan |

---

## 6. Dashboard Admin SSO — Kelola Pengguna (Lapis 1)

Halaman **Kelola Pengguna** adalah pusat kendali untuk mengelola seluruh akun karyawan di ekosistem SSO.

> 📸 **[SCREENSHOT: Halaman utama Kelola Pengguna SSO dengan daftar tabel pengguna]**

### 6.1 Melihat Daftar Pengguna

Setelah login, Anda akan melihat tabel semua pengguna SSO yang terdaftar.

### Informasi yang Ditampilkan:

| Kolom | Keterangan |
|-------|------------|
| **Email** | Alamat email karyawan |
| **Username** | Username untuk login |
| **Status** | Aktif (password sudah diset) atau Belum Aktivasi |
| **Tanggal Dibuat** | Kapan akun dibuat |
| **Aksi** | Tombol Kelola Akses, Hapus |

> 📸 **[SCREENSHOT: Tabel daftar pengguna SSO dengan kolom-kolom lengkap]**

### 6.2 Menambah Pengguna Baru

Ini adalah langkah pertama untuk membuat akun karyawan baru. **Registrasi mandiri dinonaktifkan** — hanya Admin SSO yang bisa menambah pengguna.

**Langkah 1:** Di halaman Kelola Pengguna, cari form **"Tambah Pengguna Baru"**.

> 📸 **[SCREENSHOT: Form "Tambah Pengguna Baru" dengan field email dan username]**

**Langkah 2:** Isi data berikut:

| Field | Keterangan | Wajib? |
|-------|------------|--------|
| **Email** | Alamat email karyawan (harus valid dan unik) | ✅ Ya |
| **Username** | Username untuk login (harus unik) | ✅ Ya |

**Langkah 3:** Klik tombol **"Tambah User"** atau **"Simpan"**.

**Langkah 4:** Sistem akan:
1. Membuat akun baru dengan status **Belum Aktivasi**.
2. **Mengirim email aktivasi** ke alamat email karyawan secara otomatis.

> 📸 **[SCREENSHOT: Notifikasi sukses "User berhasil ditambahkan dan email aktivasi telah dikirim"]**

> ⚠️ **Penting:** Setelah menambah user, Anda **harus memberikan akses aplikasi** (Lapis 2) agar karyawan bisa login ke MyMember atau Inventory. Lihat bagian [Kelola Akses Aplikasi](#7-kelola-akses-aplikasi-lapis-2).

### 6.3 Menghapus Pengguna

**Langkah 1:** Di tabel daftar pengguna, cari user yang ingin dihapus.

**Langkah 2:** Klik tombol **"Hapus"** pada baris user tersebut.

> 📸 **[SCREENSHOT: Tombol Hapus pada baris user di tabel]**

**Langkah 3:** Konfirmasi penghapusan pada dialog yang muncul.

> 📸 **[SCREENSHOT: Dialog konfirmasi "Apakah Anda yakin ingin menghapus user ini?"]**

> ⚠️ **Perhatian:** Menghapus user dari SSO Engine juga akan **otomatis menghapus data user** yang terkait di:
> - **MyMember** (tabel `admin`)
> - **Inventory** (tabel `users`)
>
> Tindakan ini **tidak bisa dibatalkan**.

> 📸 **[SCREENSHOT: Notifikasi sukses "User berhasil dihapus dari SSO Engine, MyMember, dan Inventory."]**

---

## 7. Kelola Akses Aplikasi (Lapis 2)

Setelah akun karyawan dibuat (Lapis 1), langkah berikutnya adalah menentukan **aplikasi apa saja** yang boleh diakses oleh karyawan tersebut.

### 7.1 Memberikan Akses Aplikasi

**Langkah 1:** Di tabel daftar pengguna, klik tombol **"Kelola Akses"** pada baris user yang ingin diatur.

> 📸 **[SCREENSHOT: Tombol "Kelola Akses" pada baris user di tabel]**

**Langkah 2:** Anda akan diarahkan ke halaman **Kelola Akses Aplikasi** untuk user tersebut. Di halaman ini, Anda akan melihat:
- Informasi user (email, username)
- Daftar semua aplikasi yang tersedia
- Status akses untuk setiap aplikasi (✅ Aktif atau ❌ Belum Diberikan)

> 📸 **[SCREENSHOT: Halaman Kelola Akses Aplikasi dengan daftar aplikasi (MyMember, Inventory)]**

**Langkah 3:** Untuk memberikan akses ke aplikasi tertentu, pilih aplikasi dari dropdown dan klik **"Berikan Akses"**.

> 📸 **[SCREENSHOT: Dropdown pemilihan aplikasi dan tombol "Berikan Akses"]**

**Langkah 4:** Setelah akses diberikan, status akan berubah menjadi ✅ **Aktif** dan user tersebut bisa login ke aplikasi yang bersangkutan.

> 📸 **[SCREENSHOT: Status akses berubah menjadi "Aktif" dengan tombol "Cabut Akses"]**

#### Contoh Skenario:

| Karyawan | Akses yang Diberikan | Bisa Login ke |
|----------|---------------------|---------------|
| Budi (Resepsionis) | MyMember saja | ✅ MyMember, ❌ Inventory |
| Ani (Staff Gudang) | Inventory saja | ❌ MyMember, ✅ Inventory |
| Doni (Manager) | MyMember + Inventory | ✅ MyMember, ✅ Inventory |

### 7.2 Mencabut Akses Aplikasi

Jika karyawan tidak lagi memerlukan akses ke suatu aplikasi (misalnya pindah divisi atau resign):

**Langkah 1:** Buka halaman **Kelola Akses** untuk user tersebut.

**Langkah 2:** Klik tombol **"Cabut Akses"** pada aplikasi yang ingin dicabut.

> 📸 **[SCREENSHOT: Tombol "Cabut Akses" berwarna merah di samping nama aplikasi]**

**Langkah 3:** Konfirmasi pencabutan akses.

> 📸 **[SCREENSHOT: Notifikasi sukses "Akses aplikasi berhasil dicabut."]**

### Apa yang Terjadi Setelah Akses Dicabut?

1. ✅ **Pencabutan dicatat** di database (`revoked_at`), bukan dihapus — ada jejak audit.
2. ✅ **Refresh token direvoke** secara otomatis.
3. ✅ **JTI dimasukkan ke Redis Blacklist** — sesi aktif karyawan di aplikasi tersebut **langsung berakhir** (0 detik delay jika Redis aktif).
4. ✅ Karyawan **tidak bisa login lagi** ke aplikasi tersebut sampai akses diberikan kembali.

> ⚠️ **Pencabutan akses bersifat instan.** Jika karyawan sedang menggunakan aplikasi, ia akan langsung ter-logout pada request berikutnya.

---

## 8. Aktivasi Akun & Reset Password via Email

### 8.1 Alur Aktivasi Akun Baru

Saat Admin SSO menambah user baru, karyawan tersebut akan menerima **email aktivasi** berisi link untuk membuat password.

#### Alur dari sisi karyawan:

**Langkah 1:** Karyawan membuka email dengan subjek **"Aktivasi Akun SSO Engine"**.

> 📸 **[SCREENSHOT: Contoh email aktivasi yang diterima karyawan di inbox]**

**Langkah 2:** Klik tombol/link **"Aktivasi Akun"** di dalam email.

> 📸 **[SCREENSHOT: Isi email aktivasi dengan tombol "Aktivasi Akun" yang mencolok]**

**Langkah 3:** Karyawan diarahkan ke halaman **Buat Password** di SSO Engine.

> 📸 **[SCREENSHOT: Form buat password baru dengan field "Password" dan "Konfirmasi Password"]**

**Langkah 4:** Masukkan password baru (minimal 8 karakter) dan konfirmasi ulang.

**Langkah 5:** Klik tombol **"Simpan Password"**. Akun kini aktif dan siap digunakan.

> 📸 **[SCREENSHOT: Halaman sukses "Password berhasil dibuat. Akun Anda sudah aktif."]**

> ⚠️ **Link aktivasi berlaku selama 10 menit.** Jika expired, Admin SSO perlu mengirim ulang email aktivasi.

### 8.2 Lupa Password (Forgot Password)

Karyawan yang lupa password bisa me-reset sendiri tanpa menghubungi admin.

**Langkah 1:** Di halaman login SSO, klik link **"Lupa Password?"**.

> 📸 **[SCREENSHOT: Link "Lupa Password?" di bawah form login SSO]**

**Langkah 2:** Masukkan **alamat email** yang terdaftar di SSO Engine.

> 📸 **[SCREENSHOT: Form input email untuk reset password]**

**Langkah 3:** Klik tombol **"Kirim Link Reset"**.

**Langkah 4:** Buka email yang diterima, klik link **"Reset Password"**.

> 📸 **[SCREENSHOT: Contoh email reset password yang diterima]**

**Langkah 5:** Buat password baru dan simpan.

> 📸 **[SCREENSHOT: Form buat password baru dari link reset]**

> 📸 **[SCREENSHOT: Halaman sukses "Password berhasil direset."]**

---

## 9. Alur Login SSO untuk Karyawan

Karyawan biasa (bukan Admin SSO) login melalui **aplikasi tujuan** (MyMember atau Inventory), yang kemudian mengarahkan mereka ke SSO Engine.

### Alur Login:

```
Karyawan buka MyMember/Inventory
         │
         ▼
   Redirect otomatis ke SSO Engine (/authorize)
         │
         ▼
   Form Login SSO Engine
         │
         ▼
   Validasi email & password (Lapis 1)
         │
         ├── ❌ Salah → "Email atau password salah"
         │
         ▼
   Cek akses aplikasi (Lapis 2)
         │
         ├── ❌ Belum ada akses → "Hubungi Admin SSO"
         │
         ▼
   ✅ Token diterbitkan → Redirect kembali ke aplikasi
         │
         ▼
   Aplikasi verifikasi token → Buat sesi lokal
         │
         ▼
   ✅ Dashboard terbuka!
```

> 📸 **[SCREENSHOT: Flow lengkap login dari sisi karyawan — halaman login SSO]**

> 📸 **[SCREENSHOT: Halaman error "Anda belum memiliki akses ke aplikasi ini" jika Lapis 2 gagal]**

### Sesi Aktif (Continue Login):

Jika karyawan sudah login ke SSO Engine dari aplikasi lain (misalnya sudah login Inventory, lalu membuka MyMember), SSO Engine akan menampilkan layar konfirmasi:

> 📸 **[SCREENSHOT: Layar "Continue as [username]" dengan opsi "Lanjutkan" dan "Ganti Akun"]**

- Klik **"Lanjutkan"** → langsung masuk tanpa memasukkan password lagi.
- Klik **"Ganti Akun"** → kembali ke form login untuk menggunakan akun lain.

---

## 10. Single Logout (SLO)

SSO Engine mendukung **Single Logout (SLO)** yang terkoordinasi. Saat karyawan logout dari **satu aplikasi manapun**, sesi di **semua aplikasi** yang menggunakan SSO Engine akan otomatis berakhir.

### Cara Kerja SLO:

```
Karyawan klik "Logout" di MyMember
         │
         ▼
   MyMember panggil POST /logout ke SSO Engine
         │
         ▼
   SSO Engine revoke SEMUA refresh token milik user
         │
         ▼
   SSO Engine masukkan semua JTI ke Redis Blacklist (TTL 15 menit)
         │
         ▼
   MyMember destroy sesi lokal
         │
         ▼
   Redirect ke SSO /logout-web → bersihkan sesi SSO browser
         │
         ▼
   ✅ User ter-logout dari MyMember, Inventory, dan SSO Engine
```

> 📸 **[SCREENSHOT: Proses logout yang sukses — karyawan kembali ke halaman login]**

### Dampak SLO:

| Aplikasi | Efek |
|----------|------|
| **Aplikasi tempat logout** | Sesi langsung dihapus |
| **Aplikasi lain (masih terbuka)** | Sesi berakhir pada request berikutnya (instan jika Redis aktif) |
| **SSO Engine** | Sesi browser SSO dibersihkan |

---

## 11. Flow End-to-End: Onboarding Karyawan Baru

Berikut adalah langkah-langkah lengkap untuk mendaftarkan karyawan baru hingga bisa login ke aplikasi:

### Langkah 1: Admin SSO — Buat Akun (Lapis 1)

1. Login ke SSO Engine → Dashboard Kelola Pengguna
2. Isi form **Tambah Pengguna Baru** (email + username)
3. Klik **Simpan** → Email aktivasi terkirim otomatis

> 📸 **[SCREENSHOT: Admin SSO menambah user baru di dashboard]**

### Langkah 2: Admin SSO — Berikan Akses Aplikasi (Lapis 2)

1. Di tabel pengguna, klik **"Kelola Akses"** pada karyawan baru
2. Berikan akses ke aplikasi yang diperlukan (MyMember / Inventory / keduanya)

> 📸 **[SCREENSHOT: Admin SSO memberikan akses MyMember dan Inventory ke user baru]**

### Langkah 3: Admin Aplikasi — Atur Role (Lapis 3, khusus Inventory)

> ⚠️ **Untuk MyMember:** Langkah ini **tidak diperlukan** karena MyMember hanya punya 1 role (`admin`) dan akun otomatis dibuat saat login pertama (JIT Provisioning).

Untuk **Inventory:**
1. Admin Inventory login ke dashboard Inventory
2. Buka menu **Kelola Pengguna**
3. Tambahkan email karyawan dan tentukan role (`admin` / `staff`)

> 📸 **[SCREENSHOT: Admin Inventory menentukan role untuk karyawan baru]**

### Langkah 4: Karyawan — Aktivasi Akun

1. Karyawan buka email aktivasi
2. Klik link aktivasi
3. Buat password baru
4. Akun aktif!

> 📸 **[SCREENSHOT: Karyawan berhasil mengaktifkan akun dan membuat password]**

### Langkah 5: Karyawan — Login ke Aplikasi

1. Buka URL aplikasi (MyMember / Inventory)
2. Otomatis diarahkan ke SSO Engine
3. Login dengan email dan password
4. ✅ Berhasil masuk ke dashboard aplikasi!

> 📸 **[SCREENSHOT: Karyawan berhasil login dan masuk ke dashboard MyMember/Inventory]**

### Checklist Onboarding:

| No | Langkah | Dilakukan oleh | Status |
|----|---------|----------------|--------|
| 1 | Buat akun SSO | Admin SSO | ☐ |
| 2 | Berikan akses aplikasi | Admin SSO | ☐ |
| 3 | Tentukan role (Inventory saja) | Admin Inventory | ☐ |
| 4 | Karyawan aktivasi password | Karyawan | ☐ |
| 5 | Karyawan login ke aplikasi | Karyawan | ☐ |

---

## 12. FAQ & Troubleshooting

### ❓ Karyawan bilang tidak menerima email aktivasi.

**Penyebab kemungkinan:**
- Email masuk ke folder **Spam/Junk**.
- Konfigurasi SMTP belum benar.
- Email karyawan salah ketik saat input.

**Solusi:**
1. Minta karyawan cek folder Spam/Junk.
2. Periksa konfigurasi SMTP di file `.env` SSO Engine:
   ```ini
   email.protocol = smtp
   email.SMTPHost = "sandbox.smtp.mailtrap.io"
   email.SMTPUser = "your_smtp_user"
   email.SMTPPass = "your_smtp_pass"
   email.SMTPPort = 2525
   ```
3. Jika email salah, hapus user dan buat ulang dengan email yang benar.

---

### ❓ Karyawan bisa login SSO tapi muncul "Anda belum memiliki akses ke aplikasi ini."

**Penyebab:** Admin SSO sudah membuat akun (Lapis 1) tetapi **belum memberikan akses ke aplikasi** yang dituju (Lapis 2).

**Solusi:** Buka Dashboard SSO → Kelola Akses user tersebut → Berikan akses ke aplikasi yang dimaksud.

---

### ❓ Karyawan sudah punya akses aplikasi, tapi setelah login muncul error di sisi aplikasi.

**Penyebab:** Untuk Inventory, Admin Inventory belum menentukan role karyawan di `pending_role_assignments` (Lapis 3).

**Solusi:**
- **Jika MyMember:** Seharusnya otomatis (JIT Provisioning). Cek log error di server MyMember.
- **Jika Inventory:** Admin Inventory harus menambahkan email karyawan dan role-nya di menu Kelola Pengguna Inventory.

---

### ❓ Setelah mencabut akses aplikasi, karyawan masih bisa menggunakan aplikasi.

**Penyebab:** Redis tidak berjalan, sehingga JTI blacklist tidak bisa diproses (SLO instan tidak bekerja).

**Solusi:**
1. Pastikan Redis server berjalan:
   ```bash
   redis-cli ping   # Harus menjawab "PONG"
   ```
2. Periksa konfigurasi Redis di `.env`:
   ```ini
   redis.host = 127.0.0.1
   redis.port = 6379
   ```
3. Jika Redis down, karyawan akan ter-logout secara natural saat **access token expired** (maksimal 15 menit).

---

### ❓ Link aktivasi/reset password sudah expired (muncul error saat diklik).

**Penyebab:** Link berlaku hanya **10 menit** sejak dikirim.

**Solusi:**
- Untuk **aktivasi akun baru**: Admin SSO perlu menghapus user dan menambahkan ulang untuk mengirim email aktivasi baru.
- Untuk **reset password**: Karyawan bisa mengirim ulang link reset melalui halaman "Lupa Password".

> 📸 **[SCREENSHOT: Halaman error "Link sudah kadaluarsa" saat aktivasi/reset]**

---

### ❓ Saya Admin SSO pertama, bagaimana saya login?

**Penyebab:** Admin SSO pertama harus dibuat melalui **database seeder** (bukan lewat dashboard).

**Solusi:** Jalankan migrasi dan seeder:
```bash
php spark migrate
php spark db:seed DatabaseSeeder
```

Seeder akan membuat akun Admin SSO pertama. Setelah itu, Anda bisa login dan menambah admin SSO lainnya melalui dashboard.

---

### ❓ Saya menggunakan Docker. URL apa yang harus digunakan?

| Aplikasi | URL (Docker) |
|----------|--------------|
| SSO Engine | `http://sso.localhost` |
| SSO Admin Dashboard | `http://sso.localhost/authorize-admin` |
| MyMember | `http://mymember.localhost` |
| Inventory | `http://inventory.localhost` |

> 💡 Pastikan Nginx reverse proxy berjalan (`docker compose up -d`).

---

## 13. Referensi Teknis (untuk Developer)

### Daftar Endpoint API SSO Engine

| Method | Endpoint | Tipe | Deskripsi |
|--------|----------|------|-----------|
| `GET` | `/authorize` | Web | Memulai alur login SSO |
| `POST` | `/login` | Web | Memproses kredensial login |
| `GET` | `/public-key` | API (Public) | Public Key PEM untuk verifikasi JWT |
| `POST` | `/refresh-token` | API (JSON) | Rotasi refresh token |
| `POST` | `/logout` | API (JSON) | Single Logout (revoke + blacklist) |
| `GET` | `/logout-web` | Web | Bersihkan sesi SSO browser |
| `GET` | `/forgot-password` | Web | Form lupa password |
| `POST` | `/forgot-password/process` | Web | Kirim email reset |
| `GET` | `/reset-password` | Web | Form buat password baru |
| `POST` | `/reset-password/process` | Web | Simpan password baru |
| `GET` | `/authorize-admin` | Web | Login Admin SSO |
| `GET` | `/admin/users` | Web (Protected) | Dashboard Kelola Pengguna |
| `POST` | `/admin/users` | Web (Protected) | Tambah user baru |
| `GET` | `/admin/users/{id}/access` | Web (Protected) | Kelola akses aplikasi per user |
| `POST` | `/admin/users/{id}/access` | Web (Protected) | Berikan akses aplikasi |
| `POST` | `/admin/users/{id}/access/{appId}/revoke` | Web (Protected) | Cabut akses aplikasi |
| `DELETE` | `/admin/users/{id}` | Web (Protected) | Hapus user |

### Database Schema SSO Engine

| Tabel | Fungsi |
|-------|--------|
| `users` | Data identitas karyawan (email, username, password hash) |
| `applications` | Daftar aplikasi terdaftar (client_id, redirect_uri) |
| `user_application_access` | Mapping user ↔ aplikasi yang diizinkan |
| `sso_admins` | Daftar admin SSO yang bisa mengakses dashboard |
| `refresh_tokens` | Refresh token aktif untuk setiap sesi |
| `password_resets` | Token reset/aktivasi password |

### Spesifikasi Keamanan Token

| Parameter | Nilai |
|-----------|-------|
| **Algoritma JWT** | RS256 (asymmetric) |
| **Access Token TTL** | 15 menit |
| **Refresh Token TTL** | 7 hari |
| **Key Size** | RSA 2048-bit |
| **Blacklist** | Redis (TTL 15 menit per JTI) |
| **Token Rotation** | Refresh token diganti setiap kali digunakan |

---

<p align="center">
  <strong>— Akhir Guide Book SSO Engine —</strong><br/>
  <sub>Dokumen ini disusun untuk membantu Admin SSO Pusat dan karyawan memahami sistem autentikasi terpusat SSO Engine.</sub><br/>
  <sub>© 2026 SSO Engine. All rights reserved.</sub>
</p>
