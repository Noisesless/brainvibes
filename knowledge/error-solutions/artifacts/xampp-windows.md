# Error Solutions — XAMPP + Windows

*Solusi untuk error yang sering terjadi di environment XAMPP pada Windows. Divalidasi dari pengalaman proyek nyata.*

---

## [ES-XW-001] Apache Tidak Bisa Start — Port 80 Sudah Dipakai

**Gejala:** Klik "Start" Apache di XAMPP Control Panel → gagal. Log: `Port 80 in use by "PID X"`
**Penyebab:** Windows IIS / Skype / World Wide Web Publishing Service menguasai port 80.
**Solusi:**
```powershell
# Cari siapa yang pakai port 80
netstat -ano | findstr :80
# Kill process atau matikan IIS:
net stop W3SVC
net stop WAS
# Atau ubah port Apache di httpd.conf:
# Listen 80 → Listen 8081
# ServerName localhost:80 → ServerName localhost:8081
```
**Pencegahan:** Di XAMPP Config > httpd.conf, ubah default port ke 8081.

---

## [ES-XW-002] MySQL Error: "Can't connect to MySQL server" / Port 3306 Conflict

**Gejala:** MySQL gagal start di XAMPP. Error: `Can't connect to MySQL server on 'localhost'`
**Penyebab:** MySQL Server versi standalone sudah terinstall dan menguasai port 3306.
**Solusi:**
```powershell
# Cari MySQL standalone:
Get-Service | Where-Object { $_.DisplayName -like "*MySQL*" }
# Stop service:
Stop-Service MySQL80
# Atau ubah port XAMPP MySQL di my.ini:
# port=3306 → port=3307
```

---

## [ES-XW-003] PHP Fatal Error: "Allowed memory size exhausted"

**Gejala:** Halaman PHP crash: `Allowed memory size of 134217728 bytes exhausted`
**Penyebab:** Default PHP memory_limit di XAMPP = 128M, tidak cukup untuk operasi besar.
**Solusi:**
```ini
; Di php.ini (XAMPP: C:\xampp\php\php.ini)
memory_limit = 512M
; Juga naikkan:
max_execution_time = 300
post_max_size = 64M
upload_max_filesize = 64M
```
**Wajib restart Apache setelah ubah php.ini.**

---

## [ES-XW-004] "Access denied for user 'root'@'localhost'" Setelah Update XAMPP

**Gejala:** Koneksi database gagal setelah update XAMPP meskipun password benar.
**Penyebab:** XAMPP reset password root MySQL ke kosong saat update.
**Solusi:**
```sql
-- Akses via shell: C:\xampp\mysql\bin\mysql.exe -u root
ALTER USER 'root'@'localhost' IDENTIFIED BY '';
FLUSH PRIVILEGES;
-- Atau set password baru:
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password_baru';
```

---

## [ES-XW-005] .htaccess Tidak Berfungsi (mod_rewrite Mati)

**Gejala:** URL rewriting/routing tidak bekerja, semua request ke index.php gagal.
**Penyebab:** `mod_rewrite` tidak diaktifkan di httpd.conf XAMPP default.
**Solusi:**
```apache
# Di httpd.conf, uncomment baris:
LoadModule rewrite_module modules/mod_rewrite.so

# Dan pastikan AllowOverride = All:
<Directory "C:/xampp/htdocs">
    AllowOverride All
    Require all granted
</Directory>
```

---

## [ES-XW-006] Session Tidak Persist / Login Gagal Menyimpan Session

**Gejala:** User login sukses tapi langsung redirect ke login lagi. Session hilang.
**Penyebab:** `session.save_path` di php.ini mengarah ke folder yang tidak writable.
**Solusi:**
```ini
; Di php.ini:
session.save_path = "C:\xampp\tmp"
; Pastikan folder C:\xampp\tmp exists dan writable
```

---

## [ES-XW-007] File Upload Gagal — "The uploaded file exceeds the upload_max_filesize"

**Gejala:** Upload gambar/file gagal dengan error size limit.
**Penyebab:** Default XAMPP PHP: `upload_max_filesize = 2M`
**Solusi:**
```ini
; Di php.ini — ubah KEDUANYA:
upload_max_filesize = 64M
post_max_size = 64M
; Jangan lupa restart Apache
```

---

## [ES-XW-008] "Class not found" atau "require_once failed" — Path Case-Sensitivity

**Gejala:** Kode jalan di Windows tapi error di Linux hosting.
**Penyebab:** Windows case-insensitive, Linux case-sensitive. `require 'Config.php'` gagal jika file = `config.php`.
**Solusi:** SELALU gunakan lowercase untuk nama file dan folder. Verifikasi case di `require`/`include` cocok 100% dengan nama file fisik di disk.

---

## [ES-XW-009] CORS Error Saat Fetch API dari Frontend ke localhost

**Gejala:** `Access-Control-Allow-Origin` error di browser console.
**Penyebab:** PHP backend tidak mengirim CORS headers.
**Solusi:**
```php
<?php
// Di awal file PHP API atau di includes/cors.php:
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}
```

---

## [ES-XW-010] SSL/HTTPS Error di Localhost — cURL Certificate Problem

**Gejala:** `cURL error 60: SSL certificate problem: unable to get local issuer certificate`
**Penyebab:** PHP cURL tidak punya CA bundle.
**Solusi:**
1. Download `cacert.pem` dari https://curl.se/ca/cacert.pem
2. Simpan di `C:\xampp\php\extras\ssl\cacert.pem`
3. Di php.ini tambahkan:
```ini
curl.cainfo = "C:\xampp\php\extras\ssl\cacert.pem"
openssl.cafile = "C:\xampp\php\extras\ssl\cacert.pem"
```
