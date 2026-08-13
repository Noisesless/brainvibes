# Secure Coding Patterns — Per Stack

*Pattern coding aman yang WAJIB digunakan AI. Diisi dari fix vulnerability + best practices.*
*AI SILENT READ saat menulis kode auth/input/db/upload/api.*

---

## PHP Native

[SP-001] Parameterized Query (MySQLi)
Stack    : PHP Native
Kategori : Database

Pattern Aman:
  ```php
  $stmt = $conn->prepare("SELECT * FROM users WHERE email = ? AND status = ?");
  $stmt->bind_param("si", $email, $status);
  $stmt->execute();
  $result = $stmt->get_result();
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — SQL Injection vector
  $result = $conn->query("SELECT * FROM users WHERE email = '$email'");
  ```

Alasan: String concatenation memungkinkan attacker inject SQL via input field.

---

[SP-002] Output Escaping (XSS Prevention)
Stack    : PHP Native
Kategori : Input

Pattern Aman:
  ```php
  <p><?= htmlspecialchars($user['name'], ENT_QUOTES, 'UTF-8') ?></p>
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — XSS vector
  <p><?= $user['name'] ?></p>
  ```

Alasan: Raw output memungkinkan attacker inject JavaScript via stored/reflected input.

---

[SP-003] File Upload Validation
Stack    : PHP Native
Kategori : Upload

Pattern Aman:
  ```php
  $allowed_types = ['image/jpeg', 'image/png', 'image/webp'];
  $allowed_exts = ['jpg', 'jpeg', 'png', 'webp'];
  $max_size = 2 * 1024 * 1024; // 2MB

  $finfo = finfo_open(FILEINFO_MIME_TYPE);
  $mime = finfo_file($finfo, $_FILES['avatar']['tmp_name']);
  $ext = strtolower(pathinfo($_FILES['avatar']['name'], PATHINFO_EXTENSION));

  if (!in_array($mime, $allowed_types) || !in_array($ext, $allowed_exts)) {
      die('Invalid file type');
  }
  if ($_FILES['avatar']['size'] > $max_size) {
      die('File too large');
  }

  // UUID filename, simpan DI LUAR webroot
  $filename = bin2hex(random_bytes(16)) . '.' . $ext;
  $upload_dir = __DIR__ . '/../storage/uploads/'; // BUKAN public/
  move_uploaded_file($_FILES['avatar']['tmp_name'], $upload_dir . $filename);
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — path traversal + arbitrary file upload
  move_uploaded_file($_FILES['file']['tmp_name'], 'uploads/' . $_FILES['file']['name']);
  ```

Alasan: Nama file asli bisa berisi path traversal (../../), ekstensi berbahaya (.php), atau overwrite file existing.

---

[SP-004] Password Hashing
Stack    : PHP Native
Kategori : Auth

Pattern Aman:
  ```php
  // Simpan password
  $hash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);

  // Verifikasi password
  if (password_verify($input_password, $stored_hash)) {
      // Login berhasil
      session_regenerate_id(true); // SECURITY FIX: prevent session fixation
  }
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS
  $hash = md5($password);           // Weak hash
  $hash = sha1($password);          // Weak hash
  if ($password === $stored_password) // Plain text comparison
  ```

Alasan: MD5/SHA1 bisa di-crack dalam hitungan detik. Plain text = catastrophic breach.

---

## Laravel

[SP-005] Mass Assignment Protection
Stack    : Laravel
Kategori : Auth

Pattern Aman:
  ```php
  // Di Model — SELALU definisikan $fillable
  class User extends Model {
      protected $fillable = ['name', 'email', 'password'];
      // BUKAN $guarded = []; yang membuka semua field
  }

  // Di Controller — gunakan validated() bukan all()
  $validated = $request->validated();
  User::create($validated);
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — mass assignment vulnerability
  protected $guarded = []; // Semua field bisa diisi dari request
  User::create($request->all()); // Termasuk is_admin, role, dll
  ```

Alasan: Attacker bisa kirim field tambahan (is_admin=1) via request body.

---

## Next.js / React

[SP-006] API Route Authentication
Stack    : Next.js
Kategori : Auth

Pattern Aman:
  ```typescript
  // app/api/users/route.ts
  import { getServerSession } from 'next-auth';
  import { authOptions } from '@/lib/auth';

  export async function GET(req: Request) {
      const session = await getServerSession(authOptions);
      if (!session) {
          return Response.json({ error: 'Unauthorized' }, { status: 401 });
      }
      // Lanjut proses...
  }
  ```

Anti-Pattern (FORBIDDEN):
  ```typescript
  // NEVER DO THIS — unprotected API route
  export async function GET(req: Request) {
      const users = await db.user.findMany(); // Siapapun bisa akses
      return Response.json(users);
  }
  ```

Alasan: API route tanpa auth check = data exposure untuk semua visitor.

---

[SP-007] Environment Variable Protection
Stack    : Next.js / React
Kategori : Config

Pattern Aman:
  ```typescript
  // Hanya variabel dengan prefix NEXT_PUBLIC_ yang terekspos ke client
  // .env.local
  DATABASE_URL=postgresql://...        // Server-only ✅
  NEXT_PUBLIC_APP_NAME=MyApp           // Client-visible ✅
  SECRET_KEY=abc123                    // Server-only ✅

  // FORBIDDEN di client-side code:
  // process.env.DATABASE_URL → undefined (aman)
  // process.env.SECRET_KEY → undefined (aman)
  ```

Anti-Pattern (FORBIDDEN):
  ```typescript
  // NEVER DO THIS — credential exposure ke browser
  NEXT_PUBLIC_DATABASE_URL=postgresql://user:password@host/db
  NEXT_PUBLIC_SECRET_KEY=abc123
  ```

Alasan: NEXT_PUBLIC_ variabel di-bundle ke JavaScript client → siapapun bisa baca via browser DevTools.

---

## Universal (Semua Stack)

[SP-008] CORS Configuration
Stack    : Semua
Kategori : Headers

Pattern Aman:
  ```
  Access-Control-Allow-Origin: https://yourdomain.com
  Access-Control-Allow-Methods: GET, POST, PUT, DELETE
  Access-Control-Allow-Headers: Content-Type, Authorization
  Access-Control-Allow-Credentials: true
  ```

Anti-Pattern (FORBIDDEN):
  ```
  Access-Control-Allow-Origin: *
  Access-Control-Allow-Credentials: true
  // Kombinasi wildcard + credentials = INVALID dan BERBAHAYA
  ```

Alasan: Wildcard CORS memungkinkan website manapun membuat request ke API Anda.

---

[SP-009] Hardcoded Credentials Prevention
Stack    : Semua
Kategori : Config

Pattern Aman:
  ```
  // Simpan di .env (BUKAN di kode)
  DB_HOST=localhost
  DB_USER=myapp
  DB_PASS=strongpassword123

  // Baca di kode
  $host = getenv('DB_HOST');
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — credential di source code
  $conn = new mysqli('localhost', 'root', 'password123', 'mydb');
  ```

Alasan: Source code bisa commit ke Git → credential tersebar.

---

[SP-010] CSRF Token Implementation
Stack    : PHP Native
Kategori : Auth

Pattern Aman:
  ```php
  // Generate token di session
  if (empty($_SESSION['csrf_token'])) {
      $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
  }

  // Include di form
  <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">

  // Validate di handler
  if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'] ?? '')) {
      http_response_code(403);
      die('Invalid CSRF token');
  }
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — form tanpa CSRF protection
  <form method="POST" action="/transfer">
      <input name="amount" value="1000000">
      <input name="to_account" value="attacker">
      <button>Transfer</button>
  </form>
  ```

Alasan: Tanpa CSRF token, attacker bisa buat halaman yang auto-submit form atas nama user yang sudah login.

---

[SP-011] Security Headers: PHP Native (.htaccess + header())
Stack    : PHP Native
Kategori : Headers

Pattern Aman (.htaccess):
  ```apache
  Header set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com; connect-src 'self';"
  Header set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" env=HTTPS
  Header set X-Frame-Options "SAMEORIGIN"
  Header set X-Content-Type-Options "nosniff"
  Header set Referrer-Policy "strict-origin-when-cross-origin"
  Header set Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()"
  ```

Pattern Aman (PHP Header Fallback):
  ```php
  header("Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com; connect-src 'self';");
  if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') {
      header("Strict-Transport-Security: max-age=31536000; includeSubDomains; preload");
  }
  header("X-Frame-Options: SAMEORIGIN");
  header("X-Content-Type-Options: nosniff");
  header("Referrer-Policy: strict-origin-when-cross-origin");
  header("Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=()");
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — Response tanpa HTTP security headers
  // Mengandalkan konfigurasi server default tanpa mempertegas di kode/htaccess
  ```

Alasan: Mencegah serangan XSS, Clickjacking, MIME-sniffing, info leakage via Referrer, dan penyalahgunaan fitur browser (kamera/mic/lokasi).

---

[SP-012] Security Headers: Next.js (next.config.js + middleware nonce)
Stack    : Next.js / React
Kategori : Headers

Pattern Aman (next.config.js headers):
  ```javascript
  const securityHeaders = [
    { key: 'Content-Security-Policy', value: "default-src 'self'; script-src 'self' 'unsafe-eval' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com; connect-src 'self';" },
    { key: 'Strict-Transport-Security', value: 'max-age=31536000; includeSubDomains; preload' },
    { key: 'X-Frame-Options', value: 'SAMEORIGIN' },
    { key: 'X-Content-Type-Options', value: 'nosniff' },
    { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
    { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=(), payment=()' }
  ];

  module.exports = {
    async headers() {
      return [{ source: '/:path*', headers: securityHeaders }];
    }
  };
  ```

Pattern Aman (Middleware Nonce-based CSP for strict XSS protection):
  ```typescript
  // middleware.ts
  import { NextResponse } from 'next/server';
  import type { NextRequest } from 'next/server';

  export function middleware(request: NextRequest) {
    const nonce = Buffer.from(crypto.randomUUID()).toString('base64');
    const cspHeader = `
      default-src 'self';
      script-src 'self' 'nonce-${nonce}' 'strict-dynamic';
      style-src 'self' 'nonce-${nonce}';
      img-src 'self' blob: data:;
      font-src 'self';
      object-src 'none';
      base-uri 'self';
      form-action 'self';
      frame-ancestors 'none';
    `.replace(/\s{2,}/g, ' ').trim();

    const requestHeaders = new Headers(request.headers);
    requestHeaders.set('x-nonce', nonce);
    requestHeaders.set('Content-Security-Policy', cspHeader);

    const response = NextResponse.next({ request: { headers: requestHeaders } });
    response.headers.set('Content-Security-Policy', cspHeader);
    response.headers.set('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
    return response;
  }
  ```

Anti-Pattern (FORBIDDEN):
  ```javascript
  // NEVER DO THIS — Tidak ada security headers di next.config.js atau middleware
  ```

---

[SP-013] Security Headers: Laravel (Middleware)
Stack    : Laravel
Kategori : Headers

Pattern Aman (app/Http/Middleware/SecurityHeaders.php):
  ```php
  namespace App\Http\Middleware;

  use Closure;
  use Illuminate\Http\Request;

  class SecurityHeaders
  {
      public function handle(Request $request, Closure $next)
      {
          $response = $next($request);
          $response->headers->set('Content-Security-Policy', "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com; connect-src 'self';");
          if ($request->secure()) {
              $response->headers->set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
          }
          $response->headers->set('X-Frame-Options', 'SAMEORIGIN');
          $response->headers->set('X-Content-Type-Options', 'nosniff');
          $response->headers->set('Referrer-Policy', 'strict-origin-when-cross-origin');
          $response->headers->set('Permissions-Policy', 'camera=(), microphone=(), geolocation=(), payment=()');
          return $response;
      }
  }
  ```

---

[SP-014] Rate Limiting: Next.js (API Route + In-Memory / Redis)
Stack    : Next.js / Node.js
Kategori : Auth / Security

Pattern Aman (Simple Rate Limiter with Map):
  ```typescript
  // lib/rate-limit.ts
  const tracker = new Map<string, { count: number; expiresAt: number }>();

  export function rateLimit(ip: string, limit = 5, windowMs = 15 * 60 * 1000) {
    const now = Date.now();
    const record = tracker.get(ip);

    if (!record || record.expiresAt < now) {
      tracker.set(ip, { count: 1, expiresAt: now + windowMs });
      return { success: true, remaining: limit - 1 };
    }

    if (record.count >= limit) {
      return { success: false, remaining: 0 };
    }

    record.count += 1;
    return { success: true, remaining: limit - record.count };
  }
  ```

Catatan Keamanan (Context Poisoning & Spoofing Guard):
  Rujuk lessons-learned SG-016! PERINGATAN: `req.headers['x-forwarded-for']` dapat di-spoof jika tidak berada di belakang trusted reverse proxy (Nginx/Cloudflare). Gunakan IP dari socket connection atau pastikan Nginx mereplace header `X-Forwarded-For` secara rigid.

---

[SP-015] Rate Limiting: Laravel (Built-in Throttle)
Stack    : Laravel
Kategori : Auth / Security

Pattern Aman (AppServiceProvider / Route):
  ```php
  use Illuminate\Cache\RateLimiting\Limit;
  use Illuminate\Support\Facades\RateLimiter;
  use Illuminate\Http\Request;

  // Di AppServiceProvider / RouteServiceProvider:
  RateLimiter::for('login', function (Request $request) {
      return Limit::perMinute(5)->by($request->ip() . '|' . $request->input('email'))
          ->response(function () {
              return response()->json(['message' => 'Too many login attempts. Please try again later.'], 429);
          });
  });

  // Di routes/api.php:
  Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:login');
  ```

---

[SP-016] Supply Chain Security (OWASP A03:2025)
Stack    : Semua
Kategori : Dependencies

Checklist Wajib:
  1. Lockfile WAJIB ada dan committed: `package-lock.json` (npm) / `composer.lock` (PHP) / `pnpm-lock.yaml`
  2. FORBIDDEN menggunakan wildcard version (`*`, `latest`) di `package.json` / `composer.json`
  3. Pin versi exact atau range ketat (e.g. `^3.2.0`, bukan `>=3.0.0`)
  4. Gunakan `npm ci` (bukan `npm install`) di production/CI untuk menjamin reproducibility
  5. Jalankan `npm audit` / `composer audit` secara periodik — zero CRITICAL/HIGH di production

Pattern Aman (package.json):
  ```json
  {
    "dependencies": {
      "next": "^14.2.0",
      "react": "^18.3.1"
    },
    "overrides": {}
  }
  ```

Anti-Pattern (FORBIDDEN):
  ```json
  {
    "dependencies": {
      "next": "*",
      "some-package": ">=1.0.0"
    }
  }
  ```

Grep Indicators (untuk `cek komponen`):
  - File `package-lock.json` atau `composer.lock` harus ada
  - Grep `"*"` atau `"latest"` di dependencies — FORBIDDEN
  - Grep `npm ci` di CI/CD config (Dockerfile, .github/workflows)

Alasan: Dependency berbahaya atau version drift dapat menyisipkan malicious code ke build pipeline (supply chain attack).

---

[SP-017] Software & Data Integrity Verification (OWASP A08:2025)
Stack    : Semua (fokus frontend)
Kategori : Integrity

Checklist Wajib:
  1. Script/CSS dari CDN eksternal WAJIB punya atribut `integrity` (Subresource Integrity / SRI)
  2. Jika tidak ada CDN eksternal (semua self-hosted), tandai checklist ini ✅ N/A
  3. CI/CD pipeline: gunakan `npm ci` bukan `npm install`
  4. Pastikan build artifact tidak di-commit ke Git (tambahkan `dist/`, `build/`, `.next/` ke `.gitignore`)

Pattern Aman (SRI untuk CDN):
  ```html
  <script src="https://cdn.example.com/lib.js"
    integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8w"
    crossorigin="anonymous"></script>
  ```

Anti-Pattern (FORBIDDEN):
  ```html
  <!-- NEVER DO THIS — CDN tanpa integrity check -->
  <script src="https://cdn.example.com/lib.js"></script>
  ```

Pattern Aman (CI/CD):
  ```yaml
  # .github/workflows/deploy.yml
  steps:
    - run: npm ci        # ✅ Reproducible install dari lockfile
    - run: npm run build
  ```

Anti-Pattern (FORBIDDEN):
  ```yaml
  steps:
    - run: npm install   # ❌ Bisa install versi berbeda dari lockfile
    - run: npm run build
  ```

Grep Indicators (untuk `cek komponen`):
  - Grep `<script src="http` di HTML files — jika ada CDN, cek `integrity=` attribute
  - Grep `npm ci` di `.github/workflows/` atau `Dockerfile`
  - Cek `.gitignore` mengandung `dist/`, `build/`, `.next/`

Alasan: Script CDN tanpa SRI rentan terhadap CDN compromise. Build artifact di Git memungkinkan code injection.

---

[SP-018] Security Logging & Sensitive Data Exclusion (OWASP A09:2025)
Stack    : Semua
Kategori : Logging

Checklist Wajib:
  1. Error logging WAJIB aktif di production (bukan ke browser/console)
  2. FORBIDDEN melog data sensitif: password, token, credit card, PII
  3. Log WAJIB mencatat: timestamp, IP, user ID, action, success/failure
  4. Log file WAJIB di LUAR webroot (bukan di `public/` atau `htdocs/`)
  5. Failed login attempts WAJIB dilog (untuk deteksi brute force)

Pattern Aman (PHP Native):
  ```php
  // Konfigurasi error logging (di awal bootstrap atau config.php)
  ini_set('display_errors', 0);        // FORBIDDEN tampilkan error ke browser
  ini_set('log_errors', 1);            // Aktifkan logging ke file
  ini_set('error_log', __DIR__ . '/../logs/app_error.log'); // Di LUAR webroot

  // Fungsi log audit (login, aksi kritis)
  function logAudit(string $action, string $status, ?int $userId = null): void {
      $entry = sprintf(
          "[%s] IP:%s | User:%s | Action:%s | Status:%s\n",
          date('Y-m-d H:i:s'),
          $_SERVER['REMOTE_ADDR'] ?? 'unknown',
          $userId ?? 'guest',
          $action,
          $status
      );
      error_log($entry, 3, __DIR__ . '/../logs/audit.log');
  }

  // Contoh penggunaan
  logAudit('login', 'SUCCESS', $userId);
  logAudit('login', 'FAILED:wrong_password');
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS — password di log
  error_log("Login attempt: user=$email, password=$password");

  // NEVER DO THIS — error detail ke browser di production
  ini_set('display_errors', 1);

  // NEVER DO THIS — log di dalam webroot (bisa diakses publik)
  error_log($msg, 3, 'public/logs/error.log');
  ```

Pattern Aman (Next.js):
  ```typescript
  // lib/logger.ts — server-side only
  export function logAudit(action: string, status: string, userId?: string) {
    const entry = {
      timestamp: new Date().toISOString(),
      action,
      status,
      userId: userId ?? 'anonymous',
      // FORBIDDEN: jangan log password, token, atau PII
    };
    console.log(JSON.stringify(entry)); // Di production: kirim ke logging service
  }
  ```

Pattern Aman (Laravel):
  ```php
  // Gunakan built-in logging
  use Illuminate\Support\Facades\Log;

  Log::channel('audit')->info('Login success', [
      'user_id' => $user->id,
      'ip' => $request->ip(),
      // FORBIDDEN: 'password' => $request->input('password')
  ]);
  ```

Grep Indicators (untuk `cek komponen`):
  - PHP: `display_errors` set ke `0`, `log_errors` set ke `1`, `error_log` path di luar webroot
  - Next.js: logging function exists, no `password` in log statements
  - Laravel: `Log::` usage, `config/logging.php` configured
  - Grep FORBIDDEN: `password` or `token` or `secret` di dalam `error_log(` / `Log::` / `console.log(`

Alasan: Tanpa logging, brute force dan intrusion tidak terdeteksi. Log yang mengandung password/token = data breach jika log bocor.


