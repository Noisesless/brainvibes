# Error Solutions — PHP Native

*Solusi untuk error umum di proyek PHP Native (tanpa framework). Fokus pada pattern Vibes Coding Workflow.*

---

## [ES-PHP-001] "Headers already sent" — Output Sebelum header()

**Gejala:** `Warning: Cannot modify header information - headers already sent by (output started at ...)`
**Penyebab:** Ada output (echo, whitespace, BOM) sebelum `header()`, `session_start()`, atau `setcookie()`.
**Solusi:**
```php
<?php
// REQUIRED: session_start() dan header() WAJIB di baris paling atas
// SEBELUM ada output HTML/whitespace/echo apapun
session_start();
// Cek: file PHP TIDAK BOLEH ada spasi/newline sebelum <?php
// Cek: file yang di-include juga tidak boleh ada output
```
**Anti-pattern:** Jangan pernah mix HTML dan PHP logic di file yang sama jika ada header redirect.

---

## [ES-PHP-002] SQL Injection — Query Tanpa Prepared Statement

**Gejala:** Data bisa dimanipulasi via input form. Security scan L3 FAILED.
**Penyebab:** Query string concatenation langsung: `"SELECT * FROM users WHERE id = $id"`
**Solusi:**
```php
// ❌ FORBIDDEN:
$result = $conn->query("SELECT * FROM users WHERE id = $_GET[id]");

// ✅ REQUIRED: Prepared Statement
$stmt = $conn->prepare("SELECT * FROM users WHERE id = ?");
$stmt->bind_param("i", $_GET['id']);
$stmt->execute();
$result = $stmt->get_result();
```

---

## [ES-PHP-003] Password Tidak Aman — MD5/SHA1 Masih Dipakai

**Gejala:** Audit keamanan gagal. Password bisa di-crack dalam hitungan detik.
**Penyebab:** Masih pakai `md5()` atau `sha1()` untuk hash password.
**Solusi:**
```php
// ✅ REQUIRED: password_hash + password_verify
$hashed = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
// Verifikasi:
if (password_verify($inputPassword, $hashedFromDB)) { /* login sukses */ }
```

---

## [ES-PHP-004] File Upload — Nama File Asli Menyebabkan Path Traversal

**Gejala:** File bisa overwrite file sistem. Security violation.
**Penyebab:** Menggunakan `$_FILES['file']['name']` langsung sebagai nama file simpan.
**Solusi:**
```php
// ❌ FORBIDDEN:
move_uploaded_file($tmp, "uploads/" . $_FILES['file']['name']);

// ✅ REQUIRED (sesuai gemini.md §4E):
$appSlug = getenv('APP_SLUG') ?: 'app';
$uuid = substr(bin2hex(random_bytes(4)), 0, 8);
$filename = "{$appSlug}_avatar_{$uuid}_" . time() . ".webp";
move_uploaded_file($tmp, "uploads/{$filename}");
```

---

## [ES-PHP-005] Session Fixation / Session Hijacking

**Gejala:** User bisa mengambil alih session user lain.
**Penyebab:** Session ID tidak di-regenerate setelah login.
**Solusi:**
```php
// REQUIRED setelah login berhasil:
session_regenerate_id(true); // true = hapus session lama
$_SESSION['user_id'] = $user['id'];
$_SESSION['ip'] = $_SERVER['REMOTE_ADDR'];
$_SESSION['ua'] = $_SERVER['HTTP_USER_AGENT'];

// Validasi di setiap request protected:
if ($_SESSION['ip'] !== $_SERVER['REMOTE_ADDR'] ||
    $_SESSION['ua'] !== $_SERVER['HTTP_USER_AGENT']) {
    session_destroy();
    header('Location: login.php');
    exit;
}
```

---

## [ES-PHP-006] "Undefined index" / "Undefined variable" Warnings

**Gejala:** Warning spam di halaman, terutama saat form belum disubmit.
**Penyebab:** Akses `$_POST['field']` atau `$_GET['id']` tanpa cek existensi.
**Solusi:**
```php
// ✅ REQUIRED: Null coalescing operator
$name = $_POST['name'] ?? '';
$page = $_GET['page'] ?? 1;
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT) ?: 0;
```

---

## [ES-PHP-007] Encoding Error — Karakter Indonesia Rusak (Tanda Tanya / Kotak)

**Gejala:** Karakter Indonesia seperti "ñ", "é" atau emoji muncul sebagai `???` atau kotak.
**Penyebab:** Charset tidak konsisten antara PHP, HTML, dan database.
**Solusi:**
```php
// 1. Di koneksi database:
$conn = new mysqli($host, $user, $pass, $db);
$conn->set_charset("utf8mb4");

// 2. Di HTML <head>:
// <meta charset="UTF-8">

// 3. Di tabel MySQL:
// ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## [ES-PHP-008] CSRF — Form Submit Tanpa Token Proteksi

**Gejala:** Form bisa di-submit dari domain lain. Security scan L4 FAILED.
**Penyebab:** Tidak ada CSRF token validation.
**Solusi:**
```php
// Generate token (di halaman form):
$_SESSION['csrf_token'] = bin2hex(random_bytes(32));

// Di form HTML:
// <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">

// Validasi di handler:
if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'] ?? '')) {
    http_response_code(403);
    die('Invalid CSRF token');
}
```

---

## [ES-PHP-009] JSON API Response — Header Content-Type Salah

**Gejala:** Frontend fetch mendapat HTML error page, bukan JSON.
**Penyebab:** Tidak set Content-Type header untuk API endpoint.
**Solusi:**
```php
// REQUIRED di awal setiap file API:
header('Content-Type: application/json; charset=utf-8');

// Response format standar:
echo json_encode([
    'success' => true,
    'data' => $result,
    'message' => 'Data berhasil dimuat'
]);
exit;
```

---

## [ES-PHP-010] Relative Path Rusak di Sub-folder XAMPP

**Gejala:** CSS/JS/gambar tidak load saat proyek di `localhost/namaproyek/`.
**Penyebab:** Path absolute `/assets/css/style.css` mengarah ke `localhost/assets/` bukan `localhost/namaproyek/assets/`.
**Solusi:**
```php
// REQUIRED: Dynamic base URL helper
function baseUrl($path = '') {
    $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'];
    $scriptDir = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/\\');
    return "{$protocol}://{$host}{$scriptDir}/{$path}";
}
// Penggunaan: <link href="<?= baseUrl('assets/css/style.css') ?>">
```
