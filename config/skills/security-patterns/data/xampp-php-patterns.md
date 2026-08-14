
---

## PHP Native + XAMPP Specific Patterns (v3.1.0)

[SP-PHP-001] CSRF Token Implementation (Tanpa Framework)
Stack    : PHP Native
Kategori : Auth

Pattern Aman:
  Generate token: bin2hex(random_bytes(32)) → simpan ke $_SESSION['csrf_token']
  Verifikasi: hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'] ?? '')
  Di form: <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">
  WAJIB gunakan hash_equals() bukan == (timing attack safe)

---

[SP-PHP-002] Session & Cookie Hardening
Stack    : Universal (PHP Native + XAMPP, Next.js, Laravel)
Kategori : Auth

Pattern Aman (PHP Native — jalankan sebelum session_start()):
  ini_set('session.cookie_httponly', 1)    - Blokir JS akses cookie
  ini_set('session.cookie_samesite', 'Strict') - Blokir CSRF cross-site
  ini_set('session.use_strict_mode', 1)   - Tolak session ID eksternal
  ini_set('session.gc_maxlifetime', 7200) - Hindari timeout terlalu cepat (2 jam)
  session_regenerate_id(true) - WAJIB dipanggil setelah login berhasil

Pattern Aman (Next.js — next-auth / cookies):
  ```typescript
  // next-auth: authOptions cookies config
  cookies: {
    sessionToken: {
      name: '__Secure-next-auth.session-token',
      options: {
        httpOnly: true,
        sameSite: 'strict',
        path: '/',
        secure: process.env.NODE_ENV === 'production',
      },
    },
  },
  // Manual cookie: gunakan flags yang sama
  cookies().set('token', value, {
    httpOnly: true, sameSite: 'strict', secure: true, maxAge: 7200,
  });
  ```

Pattern Aman (Laravel — config/session.php):
  ```php
  'http_only' => true,          // Blokir JS akses cookie
  'same_site' => 'strict',      // Blokir CSRF cross-site
  'secure' => env('SESSION_SECURE_COOKIE', true), // HTTPS only di production
  'lifetime' => 120,            // 2 jam
  // Setelah login: $request->session()->regenerate();
  ```

Anti-Pattern (FORBIDDEN):
  cookie tanpa httpOnly flag, SameSite=None tanpa justifikasi, session tanpa regenerate setelah login

---

[SP-PHP-003] File Upload Aman (PHP + XAMPP)
Stack    : PHP Native + XAMPP
Kategori : Upload

Checklist wajib:
  1. Cek $file['error'] === UPLOAD_ERR_OK
  2. Cek ukuran: $file['size'] <= 5 * 1024 * 1024
  3. Cek MIME sebenarnya: $finfo = new finfo(FILEINFO_MIME_TYPE); $mime = $finfo->file($file['tmp_name'])
  4. Allowlist MIME: ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
  5. UUID filename: bin2hex(random_bytes(16)) . '.' . $ext
  6. Simpan di LUAR webroot (bukan di htdocs)
  7. Folder upload: php_flag engine off (blokir eksekusi PHP)

---

[SP-PHP-004] Rate Limiter Login (Session-Based, Tanpa Redis)
Stack    : PHP Native + XAMPP
Kategori : Auth

Pattern Aman:
  $_SESSION['login_attempts'] - counter percobaan
  $_SESSION['last_attempt_time'] - timestamp percobaan terakhir
  Batas: 5 percobaan dalam 900 detik (15 menit)
  Reset counter jika time() - last_attempt_time > 900
  Jika melebihi batas: http_response_code(429) + pesan error

---

[SP-HTACCESS-001] .htaccess Keamanan Dasar XAMPP
Stack    : PHP Native + XAMPP Apache
Kategori : Config

Minimal .htaccess per proyek XAMPP:
  Options -Indexes                          (blokir directory listing)
  FilesMatch .env|composer.json - Deny from all (blokir file sensitif)
  Header set X-Content-Type-Options nosniff
  Header set X-Frame-Options SAMEORIGIN
  Header set Referrer-Policy strict-origin-when-cross-origin
  Header set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com;"
  Header set Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()"
  # Header set Strict-Transport-Security "max-age=31536000; includeSubDomains" env=HTTPS
  ServerSignature Off                       (sembunyikan versi Apache)
