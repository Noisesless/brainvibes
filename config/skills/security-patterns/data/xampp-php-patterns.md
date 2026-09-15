
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

[SP-PHP-004] Tiered Rate Limiter (Session-Based, Tanpa Redis)
Stack    : PHP Native (XAMPP Windows & Linux)
Kategori : Auth / Security

Tier Table (WAJIB disesuaikan per endpoint):
| Tier      | Limit | Window  | Key / Scope            | Contoh Endpoint                  |
|-----------|-------|---------|------------------------|----------------------------------|
| CRITICAL  | 5     | 15 min  | Login, Reset Password  | POST /login.php, forgot-password |
| SENSITIVE | 10    | 15 min  | Register, Verify OTP   | POST /register.php, verify-otp   |
| API_WRITE | 30    | 1 min   | Mutations (CUD)        | POST/PUT/DELETE /api/items.php   |
| API_READ  | 60    | 1 min   | Data Queries           | GET /api/search.php              |
| GENERAL   | 120   | 1 min   | Static / Public pages  | /index.php, /about.php           |

Pattern Aman:
  ```php
  function rateLimitCheck(string $tier = 'GENERAL'): array {
      if (session_status() === PHP_SESSION_NONE) {
          session_start();
      }

      $tiers = [
          'CRITICAL'  => ['limit' => 5,   'window' => 900], // 5 req / 15 min (brute-force defense)
          'SENSITIVE' => ['limit' => 10,  'window' => 900], // 10 req / 15 min (registration, OTP)
          'API_WRITE' => ['limit' => 30,  'window' => 60],  // 30 req / 1 min (mutations)
          'API_READ'  => ['limit' => 60,  'window' => 60],  // 60 req / 1 min (reads/searches)
          'GENERAL'   => ['limit' => 120, 'window' => 60],  // 120 req / 1 min (general pages)
      ];

      $config = $tiers[$tier] ?? $tiers['GENERAL'];
      $now = time();

      if (!isset($_SESSION['rate_limits'][$tier])) {
          $_SESSION['rate_limits'][$tier] = [
              'count'    => 0,
              'reset_at' => $now + $config['window']
          ];
      }

      $record = &$_SESSION['rate_limits'][$tier];

      // Reset counter jika window waktu telah kedaluwarsa
      if ($now >= $record['reset_at']) {
          $record['count'] = 0;
          $record['reset_at'] = $now + $config['window'];
      }

      if ($record['count'] >= $config['limit']) {
          $retryAfter = $record['reset_at'] - $now;
          http_response_code(429);
          header('Retry-After: ' . $retryAfter);
          header('X-RateLimit-Limit: ' . $config['limit']);
          header('X-RateLimit-Remaining: 0');
          header('Content-Type: application/json');
          echo json_encode([
              'error' => 'Too many requests on ' . $tier . ' tier. Please try again later.',
              'retry_after_seconds' => $retryAfter,
              'tier' => $tier
          ]);
          exit;
      }

      $record['count']++;
      $remaining = $config['limit'] - $record['count'];

      header('X-RateLimit-Limit: ' . $config['limit']);
      header('X-RateLimit-Remaining: ' . $remaining);

      return ['success' => true, 'remaining' => $remaining];
  }

  // Contoh Penggunaan di Endpoint Login:
  // rateLimitCheck('CRITICAL');
  // Lanjutkan autentikasi...
  ```

---

[SP-PHP-005] Tiered Rate Limiter (File/DB-Based, Multi-User / Anti-Session-Reset)
Stack    : PHP Native (XAMPP Windows & Linux / Cachy OS)
Kategori : Security / Anti-Brute-Force

Justifikasi: Attacker dapat dengan mudah mereset cookie/session untuk melewati rate limit session-based. SP-PHP-005 melacak percobaan berdasarkan Client IP (+ identifier email pada tier CRITICAL) menggunakan atomic file lock atau database, tahan terhadap manipulasi session klien.

Cross-Platform Storage Strategy:
  - Gunakan `sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'app_rate_limits'` atau relative storage path `__DIR__ . '/../storage/rate_limits/'`.
  - FORBIDDEN hardcode drive letter `C:\xampp\` atau root Unix `/tmp/` langsung di kode.
  - Berikan izin direktori aman (`@chmod($storageDir, 0700)`).

Pattern Aman (Atomic File-Based Rate Limiter):
  ```php
  function fileRateLimitCheck(string $identifier, string $tier = 'GENERAL'): array {
      $tiers = [
          'CRITICAL'  => ['limit' => 5,   'window' => 900], // 5 req / 15 min
          'SENSITIVE' => ['limit' => 10,  'window' => 900], // 10 req / 15 min
          'API_WRITE' => ['limit' => 30,  'window' => 60],  // 30 req / 1 min
          'API_READ'  => ['limit' => 60,  'window' => 60],  // 60 req / 1 min
          'GENERAL'   => ['limit' => 120, 'window' => 60],  // 120 req / 1 min
      ];

      $config = $tiers[$tier] ?? $tiers['GENERAL'];
      $now = time();

      // Path OS-agnostic: sys_get_temp_dir() otomatis resolve ke C:\xampp\tmp di Windows atau /tmp di Linux
      $storageDir = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'app_rate_limits';
      if (!is_dir($storageDir)) {
          @mkdir($storageDir, 0700, true);
      }

      $key = hash('sha256', $tier . ':' . $identifier);
      $filePath = $storageDir . DIRECTORY_SEPARATOR . $key . '.json';

      $fp = fopen($filePath, 'c+');
      if (!$fp) {
          // Fallback anggap aman jika file storage terkunci
          return ['success' => true, 'remaining' => $config['limit']];
      }

      // Lock eksklusif untuk mencegah race conditions
      flock($fp, LOCK_EX);

      $content = stream_get_contents($fp);
      $data = $content ? json_decode($content, true) : null;

      if (!$data || $now >= $data['reset_at']) {
          $data = ['count' => 0, 'reset_at' => $now + $config['window']];
      }

      if ($data['count'] >= $config['limit']) {
          $retryAfter = $data['reset_at'] - $now;
          flock($fp, LOCK_UN);
          fclose($fp);

          http_response_code(429);
          header('Retry-After: ' . $retryAfter);
          header('X-RateLimit-Limit: ' . $config['limit']);
          header('X-RateLimit-Remaining: 0');
          header('Content-Type: application/json');
          echo json_encode([
              'error' => 'Rate limit exceeded on ' . $tier . '. Try again later.',
              'retry_after' => $retryAfter
          ]);
          exit;
      }

      $data['count']++;
      $remaining = $config['limit'] - $data['count'];

      // Tulis kembali counter yang diperbarui
      ftruncate($fp, 0);
      rewind($fp);
      fwrite($fp, json_encode($data));
      fflush($fp);
      flock($fp, LOCK_UN);
      fclose($fp);

      header('X-RateLimit-Limit: ' . $config['limit']);
      header('X-RateLimit-Remaining: ' . $remaining);

      return ['success' => true, 'remaining' => $remaining];
  }

  // Contoh Penggunaan:
  // $clientIp = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
  // $targetEmail = strtolower(trim($_POST['email'] ?? ''));
  // fileRateLimitCheck($clientIp . '|' . $targetEmail, 'CRITICAL');
  ```

---

[SP-HTACCESS-001] .htaccess Keamanan Dasar XAMPP (Hardened & Clean)
Stack    : PHP Native + XAMPP Apache
Kategori : Config

Minimal .htaccess per proyek XAMPP:
  ```apache
  Options -Indexes
  ServerSignature Off

  <FilesMatch "^\.env|composer\.json|package\.json|\.git">
      Order allow,deny
      Deny from all
  </FilesMatch>

  <IfModule mod_headers.c>
      # Unset untuk mencegah duplikasi jika di-set juga oleh PHP/upstream
      Header always unset Strict-Transport-Security
      Header always unset Content-Security-Policy
      Header always unset Permissions-Policy
      Header always unset X-Content-Type-Options
      Header always unset X-Frame-Options
      Header always unset Referrer-Policy
      Header always unset X-Permitted-Cross-Domain-Policies
      Header always unset X-XSS-Protection
      Header always unset Cross-Origin-Opener-Policy
      Header always unset Cross-Origin-Resource-Policy

      # Security Headers
      Header always set X-Content-Type-Options "nosniff"
      Header always set X-Frame-Options "SAMEORIGIN"
      Header always set Referrer-Policy "strict-origin-when-cross-origin"
      Header always set X-Permitted-Cross-Domain-Policies "none"
      Header always set X-XSS-Protection "0"
      Header always set Permissions-Policy "camera=(), microphone=(), geolocation=(self), payment=(), usb=()"
      Header always set Cross-Origin-Opener-Policy "same-origin"
      Header always set Cross-Origin-Resource-Policy "same-origin"
      Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" env=HTTPS
      Header always set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com data:; connect-src 'self'; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;"
  </IfModule>
  ```

