# Retrospektif Proyek: Sistem Informasi Manajemen (PHP Native + MySQL + XAMPP)
# Dibuat: 2026-07-13 | Versi bootstrap untuk Knowledge Priming Brainvibes v3.1.0
# Tujuan: Memberikan AI insight dari proyek nyata saat 'awal baru' dipanggil

---

## Ringkasan Proyek
- Stack: PHP Native, MySQL, XAMPP Apache, Bootstrap 5, vanilla JS
- Durasi: ~3 minggu
- Halaman: 12 halaman (login, dashboard, CRUD users, laporan, settings)

---

## Pelajaran Utama — XAMPP & PHP Setup

### P1 — Path Folder Tidak Boleh Mengandung Spasi
**Masalah:** Apache crash / 500 error jika path proyek `C:\xampp\htdocs\my project\`
**Solusi:** Selalu gunakan nama tanpa spasi: `C:\xampp\htdocs\myproject\` atau `my-project`
**Dampak:** Menyebabkan 2 jam debugging yang bisa dihindari

### P2 — Session PHP Expired Terlalu Cepat di XAMPP
**Masalah:** User sering ter-logout mendadak padahal baru 20 menit tidak aktif
**Solusi:** Edit `C:\xampp\php\php.ini`:
  session.gc_maxlifetime = 7200   (2 jam)
  session.cookie_lifetime = 7200
**Dampak:** UX jauh lebih baik setelah fix

### P3 — Upload File > 2MB Gagal Tanpa Error Jelas
**Masalah:** Form upload tidak mengembalikan error, file tidak tersimpan
**Solusi:** Edit `php.ini`:
  upload_max_filesize = 10M
  post_max_size = 12M
  max_execution_time = 60
**Catatan:** Restart Apache setelah edit php.ini (wajib)

### P4 — MySQL STRICT Mode Menyebabkan Error Insert
**Masalah:** Query INSERT gagal untuk kolom dengan DEFAULT value jika tidak di-set eksplisit
**Solusi:** Di `my.ini` XAMPP:
  sql_mode = "NO_ENGINE_SUBSTITUTION"
  (hapus STRICT_TRANS_TABLES dari sql_mode)
**Alternatif:** Selalu set semua kolom secara eksplisit di query INSERT

### P5 — .htaccess Tidak Aktif di XAMPP Default
**Masalah:** URL rewriting tidak jalan, mod_rewrite tidak aktif
**Solusi:** Edit `httpd.conf`:
  - Uncomment: LoadModule rewrite_module modules/mod_rewrite.so
  - Ganti: AllowOverride None → AllowOverride All (untuk direktori htdocs)
  - Restart Apache

---

## Pelajaran Utama — Database & Query

### P6 — N+1 Query Problem di Halaman List
**Masalah:** Halaman daftar user (100 rows) membuat 101 query (1 list + 100 untuk detail)
**Solusi:** Gunakan JOIN dari awal, bukan query dalam loop:
  ```sql
  SELECT u.*, r.name as role_name
  FROM users u LEFT JOIN roles r ON u.role_id = r.id
  ```

### P7 — Tidak Ada Index di Kolom yang Sering Difilter
**Masalah:** Query search lambat di tabel 10.000+ rows
**Solusi:** Tambah index pada kolom yang sering dipakai di WHERE/ORDER BY:
  ```sql
  ALTER TABLE users ADD INDEX idx_status (status);
  ALTER TABLE orders ADD INDEX idx_created_at (created_at);
  ```

---

## Pelajaran Utama — Frontend & UI

### P8 — CSS Tidak Ter-load Karena Path Relatif Salah
**Masalah:** Setelah dipindah sub-folder, semua path asset rusak
**Solusi:** Gunakan path absolut dari root proyek:
  ```php
  define('BASE_URL', '/myproject/'); // set sekali di config.php
  // Di HTML: <link href="<?= BASE_URL ?>assets/css/style.css">
  ```

### P9 — Form Tidak Reset Setelah Submit Sukses
**Masalah:** User bingung karena form masih berisi data lama setelah berhasil simpan
**Solusi:** Redirect setelah POST (Post/Redirect/Get pattern):
  ```php
  header('Location: ' . BASE_URL . 'users?success=1');
  exit;
  ```

---

## Pelajaran Utama — Deployment & Produksi

### P10 — .env File Ter-expose di Production
**Masalah:** File .env di dalam htdocs bisa diakses via browser di hosting shared
**Solusi:** Tambah ke .htaccess: `<FilesMatch "^\.env"> Deny from all </FilesMatch>`
  Atau simpan config di luar public_html

### P11 — Error PHP Tampil di Production
**Masalah:** Stack trace PHP terlihat user akhir — security risk + UX buruk
**Solusi:** Di `config.php` production:
  ```php
  ini_set('display_errors', 0);
  error_reporting(E_ALL);
  ini_set('log_errors', 1);
  ini_set('error_log', __DIR__ . '/logs/php-error.log');
  ```

---

## Pattern Kode yang Proven (Copy-Paste Safe)

### Config.php Minimal
```php
<?php
define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_NAME', getenv('DB_NAME') ?: 'mydb');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASS', getenv('DB_PASS') ?: '');
define('BASE_URL', '/myproject/');
define('UPLOAD_DIR', dirname(dirname(__FILE__)) . '/uploads/');

try {
    $pdo = new PDO(
        "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
        DB_USER, DB_PASS,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
         PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
    );
} catch (PDOException $e) {
    error_log($e->getMessage());
    die("Koneksi database gagal.");
}
```

---

## Estimasi Waktu Per Fase (Referensi Kalibrasi)

| Komponen | Estimasi Aktual |
|---|---|
| Setup XAMPP + config + DB schema | 2-4 jam |
| Halaman login + session | 3-5 jam |
| CRUD 1 modul (list + tambah + edit + hapus) | 4-8 jam |
| Dashboard dengan chart | 4-6 jam |
| Halaman laporan + export PDF | 6-10 jam |
| Testing + bug fixing | 20% dari total |
