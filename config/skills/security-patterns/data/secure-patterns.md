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
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : Auth

Pattern Aman (PHP Native):
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

Pattern Aman (Laravel — Built-in):
  ```php
  {{-- Blade form — @csrf otomatis generate hidden input --}}
  <form method="POST" action="/transfer">
      @csrf
      <input name="amount" value="">
      <button>Transfer</button>
  </form>

  {{-- Middleware VerifyCsrfToken aktif secara default di web routes --}}
  {{-- Jika perlu exclude route tertentu (webhook): --}}
  ```

  ```php
  // app/Http/Middleware/VerifyCsrfToken.php (Laravel 10)
  protected $except = [
      'webhook/*', // Hanya route webhook yang di-exclude
  ];

  // Laravel 11+: bootstrap/app.php
  ->withMiddleware(function (Middleware $middleware) {
      $middleware->validateCsrfTokens(except: ['webhook/*']);
  })
  ```

Catatan Next.js:
  Next.js API routes bersifat stateless (token-based / JWT). CSRF tradisional
  tidak relevan. Proteksi dilakukan via:
  - `SameSite=Strict` pada cookie session (`next-auth` default)
  - Origin/Referer header validation di middleware
  - Tidak menggunakan cookie-based form submission

Anti-Pattern (FORBIDDEN):
  ```php
  // ❌ Form tanpa CSRF protection
  <form method="POST" action="/transfer">
      <input name="amount" value="1000000">
      <input name="to_account" value="attacker">
      <button>Transfer</button>
  </form>

  // ❌ Laravel: exclude semua route dari CSRF (membunuh proteksi)
  protected $except = ['*']; // NEVER DO THIS
  ```

Alasan: Tanpa CSRF token, attacker bisa buat halaman yang auto-submit form atas nama user yang sudah login.

---

[SP-011] Security Headers: PHP Native (.htaccess + header())
Stack    : PHP Native
Kategori : Headers

Pattern Aman (.htaccess — Clean & Deduplication Protected):
  ```apache
  <IfModule mod_headers.c>
      # 1. Unset header sebelumnya untuk mencegah duplikasi dari upstream/framework
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

      # 2. Pasang Security Headers Bersih & Hardened
      Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" env=HTTPS
      Header always set X-Content-Type-Options "nosniff"
      Header always set X-Frame-Options "SAMEORIGIN"
      Header always set Referrer-Policy "strict-origin-when-cross-origin"
      Header always set X-Permitted-Cross-Domain-Policies "none"
      Header always set Permissions-Policy "camera=(), microphone=(), geolocation=(self), payment=(), usb=()"
      Header always set Cross-Origin-Opener-Policy "same-origin"
      Header always set Cross-Origin-Resource-Policy "same-origin"
      Header always set X-XSS-Protection "0"

      # CSP Standar (Environment Production)
      Header always set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com data:; img-src 'self' data: https:; connect-src 'self'; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;"
  </IfModule>
  ```

Pattern Aman (PHP Header Fallback):
  ```php
  header("Strict-Transport-Security: max-age=31536000; includeSubDomains; preload");
  header("X-Content-Type-Options: nosniff");
  header("X-Frame-Options: SAMEORIGIN");
  header("Referrer-Policy: strict-origin-when-cross-origin");
  header("X-Permitted-Cross-Domain-Policies: none");
  header("X-XSS-Protection: 0");
  header("Permissions-Policy: camera=(), microphone=(), geolocation=(self), payment=(), usb=()");
  header("Cross-Origin-Opener-Policy: same-origin");
  header("Cross-Origin-Resource-Policy: same-origin");
  header("Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com data:; img-src 'self' data: https:; connect-src 'self'; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;");
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // NEVER DO THIS:
  // 1. Double header emission / duplikasi header di berbagai layer (proxy + webserver + app)
  // 2. Mengirim Referrer-Policy bertabrakan (misal strict-origin-when-cross-origin + same-origin)
  // 3. Membiarkan host localhost/ws di CSP connect-src production
  // 4. Menggunakan X-XSS-Protection: 1; mode=block (legacy / deprecated, bisa memicu XS-Leaks)
  ```

Alasan: Mencegah serangan XSS, Clickjacking, MIME-sniffing, info leakage via Referrer, Cross-Origin info leaks (Spectre), dan penyalahgunaan fitur browser (kamera/mic/lokasi).

---

[SP-012] Security Headers: Next.js (next.config.js + middleware nonce)
Stack    : Next.js / React
Kategori : Headers

Pattern Aman (next.config.js headers):
  ```javascript
  const securityHeaders = [
    { key: 'Strict-Transport-Security', value: 'max-age=31536000; includeSubDomains; preload' },
    { key: 'X-Frame-Options', value: 'SAMEORIGIN' },
    { key: 'X-Content-Type-Options', value: 'nosniff' },
    { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
    { key: 'X-Permitted-Cross-Domain-Policies', value: 'none' },
    { key: 'X-XSS-Protection', value: '0' },
    { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=(self), payment=(), usb=()' },
    { key: 'Cross-Origin-Opener-Policy', value: 'same-origin' },
    { key: 'Cross-Origin-Resource-Policy', value: 'same-origin' },
    { key: 'Content-Security-Policy', value: "default-src 'self'; script-src 'self' 'unsafe-eval' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; img-src 'self' data: https: blob:; font-src 'self' https://fonts.gstatic.com data:; connect-src 'self'; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;" }
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
      img-src 'self' blob: data: https:;
      font-src 'self' data:;
      object-src 'none';
      base-uri 'self';
      form-action 'self';
      frame-ancestors 'none';
      upgrade-insecure-requests;
    `.replace(/\s{2,}/g, ' ').trim();

    const requestHeaders = new Headers(request.headers);
    requestHeaders.set('x-nonce', nonce);
    requestHeaders.set('Content-Security-Policy', cspHeader);

    const response = NextResponse.next({ request: { headers: requestHeaders } });
    response.headers.set('Content-Security-Policy', cspHeader);
    response.headers.set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
    response.headers.set('X-Content-Type-Options', 'nosniff');
    response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
    response.headers.set('X-Permitted-Cross-Domain-Policies', 'none');
    response.headers.set('X-XSS-Protection', '0');
    response.headers.set('Cross-Origin-Opener-Policy', 'same-origin');
    response.headers.set('Cross-Origin-Resource-Policy', 'same-origin');
    response.headers.set('Permissions-Policy', 'camera=(), microphone=(), geolocation=(), payment=()');
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
          $response->headers->set('Content-Security-Policy', "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com data:; connect-src 'self'; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;");
          if ($request->secure()) {
              $response->headers->set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
          }
          $response->headers->set('X-Frame-Options', 'SAMEORIGIN');
          $response->headers->set('X-Content-Type-Options', 'nosniff');
          $response->headers->set('Referrer-Policy', 'strict-origin-when-cross-origin');
          $response->headers->set('X-Permitted-Cross-Domain-Policies', 'none');
          $response->headers->set('X-XSS-Protection', '0');
          $response->headers->set('Cross-Origin-Opener-Policy', 'same-origin');
          $response->headers->set('Cross-Origin-Resource-Policy', 'same-origin');
          $response->headers->set('Permissions-Policy', 'camera=(), microphone=(), geolocation=(self), payment=(), usb=()');
          return $response;
      }
  }
  ```

---

[SP-014] Tiered Rate Limiting: Next.js (API Route + In-Memory / Redis)
Stack    : Next.js / Node.js
Kategori : Auth / Security

Tier Table (WAJIB disesuaikan per endpoint):
| Tier      | Limit | Window  | Key Strategy               | Contoh Endpoint                  |
|-----------|-------|---------|----------------------------|----------------------------------|
| CRITICAL  | 5     | 15 min  | IP + identifier (email)    | POST /api/auth/login, reset-pw   |
| SENSITIVE | 10    | 15 min  | IP                         | POST /api/auth/register, verify  |
| API_WRITE | 30    | 1 min   | IP atau API Key            | POST/PUT/DELETE /api/*           |
| API_READ  | 60    | 1 min   | IP atau API Key            | GET /api/*                       |
| GENERAL   | 120   | 1 min   | IP                         | Halaman publik, health check     |

Pattern Aman (Tiered Rate Limiter TypeScript):
  ```typescript
  // lib/rate-limit.ts
  export type RateLimitTier = 'CRITICAL' | 'SENSITIVE' | 'API_WRITE' | 'API_READ' | 'GENERAL';

  interface TierConfig {
    limit: number;
    windowMs: number;
  }

  export const RATE_LIMIT_TIERS: Record<RateLimitTier, TierConfig> = {
    CRITICAL:  { limit: 5,   windowMs: 15 * 60 * 1000 }, // 5 req / 15 min (brute-force defense)
    SENSITIVE: { limit: 10,  windowMs: 15 * 60 * 1000 }, // 10 req / 15 min (registration, OTP)
    API_WRITE: { limit: 30,  windowMs: 60 * 1000 },      // 30 req / 1 min (CRUD write ops)
    API_READ:  { limit: 60,  windowMs: 60 * 1000 },      // 60 req / 1 min (data query/search)
    GENERAL:   { limit: 120, windowMs: 60 * 1000 },      // 120 req / 1 min (static/public)
  };

  const tracker = new Map<string, { count: number; expiresAt: number }>();

  // Cleanup expired entries periodically
  setInterval(() => {
    const now = Date.now();
    for (const [key, record] of tracker.entries()) {
      if (record.expiresAt < now) tracker.delete(key);
    }
  }, 60 * 1000);

  export function rateLimitCheck(identifier: string, tier: RateLimitTier = 'GENERAL') {
    const config = RATE_LIMIT_TIERS[tier];
    const now = Date.now();
    const key = `${tier}:${identifier}`;
    const record = tracker.get(key);

    if (!record || record.expiresAt < now) {
      tracker.set(key, { count: 1, expiresAt: now + config.windowMs });
      return {
        success: true,
        limit: config.limit,
        remaining: config.limit - 1,
        retryAfterSec: 0,
      };
    }

    if (record.count >= config.limit) {
      const retryAfterSec = Math.ceil((record.expiresAt - now) / 1000);
      return {
        success: false,
        limit: config.limit,
        remaining: 0,
        retryAfterSec,
      };
    }

    record.count += 1;
    return {
      success: true,
      limit: config.limit,
      remaining: config.limit - record.count,
      retryAfterSec: 0,
    };
  }

  // Contoh Penggunaan di Route Handler (Next.js App Router):
  // app/api/auth/login/route.ts
  export async function POST(req: Request) {
    const ip = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() || '127.0.0.1';
    const body = await req.json().catch(() => ({}));
    const key = `${ip}:${body.email || 'anon'}`;

    const { success, limit, remaining, retryAfterSec } = rateLimitCheck(key, 'CRITICAL');
    if (!success) {
      return new Response(JSON.stringify({ error: 'Too many attempts. Please try again later.' }), {
        status: 429,
        headers: {
          'Content-Type': 'application/json',
          'Retry-After': String(retryAfterSec),
          'X-RateLimit-Limit': String(limit),
          'X-RateLimit-Remaining': '0',
        },
      });
    }

    // Lanjutkan logic auth...
  }
  ```

Catatan Keamanan (Context Poisoning & Spoofing Guard):
  Rujuk lessons-learned SG-016! PERINGATAN: `req.headers['x-forwarded-for']` dapat di-spoof jika tidak berada di belakang trusted reverse proxy (Nginx/Cloudflare). Selalu gunakan IP paling kiri hanya bila reverse proxy dikonfigurasi untuk menimpa header tersebut, atau gunakan socket connection IP.

---

[SP-015] Tiered Rate Limiting: Laravel (Built-in Throttle)
Stack    : Laravel
Kategori : Auth / Security

Tier Table (WAJIB disesuaikan per endpoint):
| Tier      | Limit | Window  | Key Strategy               | Contoh Endpoint                  |
|-----------|-------|---------|----------------------------|----------------------------------|
| CRITICAL  | 5     | 15 min  | IP + identifier (email)    | POST /login, POST /password/reset|
| SENSITIVE | 10    | 15 min  | IP                         | POST /register, POST /verify-otp |
| API_WRITE | 30    | 1 min   | User ID atau IP            | POST/PUT/DELETE /api/*           |
| API_READ  | 60    | 1 min   | User ID atau IP            | GET /api/*                       |
| GENERAL   | 120   | 1 min   | IP                         | Halaman publik                   |

Pattern Aman (AppServiceProvider / RouteServiceProvider):
  ```php
  use Illuminate\Cache\RateLimiting\Limit;
  use Illuminate\Support\Facades\RateLimiter;
  use Illuminate\Http\Request;

  // Di AppServiceProvider / RateLimiter Configuration:
  public function boot(): void
  {
      // Tier 1: CRITICAL (Login, Password Reset)
      RateLimiter::for('throttle-critical', function (Request $request) {
          $identifier = (string) ($request->input('email') ?? $request->input('username') ?? 'anon');
          return Limit::perMinutes(15, 5)
              ->by($request->ip() . '|' . strtolower($identifier))
              ->response(function () {
                  return response()->json([
                      'message' => 'Too many attempts on critical endpoint. Please try again in 15 minutes.'
                  ], 429);
              });
      });

      // Tier 2: SENSITIVE (Registration, OTP verification)
      RateLimiter::for('throttle-sensitive', function (Request $request) {
          return Limit::perMinutes(15, 10)->by($request->ip())
              ->response(function () {
                  return response()->json(['message' => 'Too many sensitive requests. Please wait 15 minutes.'], 429);
              });
      });

      // Tier 3: API_WRITE (POST/PUT/DELETE CRUD mutations)
      RateLimiter::for('throttle-api-write', function (Request $request) {
          $key = $request->user()?->id ?: $request->ip();
          return Limit::perMinute(30)->by('write:' . $key);
      });

      // Tier 4: API_READ (GET data queries)
      RateLimiter::for('throttle-api-read', function (Request $request) {
          $key = $request->user()?->id ?: $request->ip();
          return Limit::perMinute(60)->by('read:' . $key);
      });

      // Tier 5: GENERAL (Public endpoints / web browsing)
      RateLimiter::for('throttle-general', function (Request $request) {
          return Limit::perMinute(120)->by($request->ip());
      });
  }

  // Binding di routes/api.php & routes/web.php:
  Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:throttle-critical');
  Route::post('/password/reset', [ResetController::class, 'reset'])->middleware('throttle:throttle-critical');
  Route::post('/register', [RegisterController::class, 'register'])->middleware('throttle:throttle-sensitive');

  Route::middleware(['auth:sanctum', 'throttle:throttle-api-write'])->group(function () {
      Route::post('/items', [ItemController::class, 'store']);
      Route::put('/items/{id}', [ItemController::class, 'update']);
      Route::delete('/items/{id}', [ItemController::class, 'destroy']);
  });

  Route::middleware(['throttle:throttle-api-read'])->group(function () {
      Route::get('/items', [ItemController::class, 'index']);
      Route::get('/items/{id}', [ItemController::class, 'show']);
  });
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

---

[SP-019] Error & Exception Handling (OWASP A10:2025)
Stack    : Universal (PHP Native, Next.js, Laravel)
Kategori : Exception Handling

Pattern Aman (PHP Native):
  ```php
  // Di awal bootstrap / index.php
  ini_set('display_errors', '0');
  ini_set('log_errors', '1');
  ini_set('error_log', '/var/log/php/app-error.log'); // DI LUAR webroot

  set_error_handler(function ($severity, $message, $file, $line) {
      throw new ErrorException($message, 0, $severity, $file, $line);
  });

  set_exception_handler(function (Throwable $e) {
      error_log("[UNCAUGHT] {$e->getMessage()} in {$e->getFile()}:{$e->getLine()}");
      http_response_code(500);
      include __DIR__ . '/views/error-500.php'; // Halaman error generik
      exit;
  });
  ```

Pattern Aman (Next.js):
  ```typescript
  // app/error.tsx — automatic error boundary per route segment
  'use client';
  export default function Error({ error, reset }: { error: Error; reset: () => void }) {
    // FORBIDDEN: jangan tampilkan error.message ke user di production
    console.error('[App Error]', error); // server log only
    return (
      <div>
        <h2>Terjadi kesalahan</h2>
        <button onClick={reset}>Coba lagi</button>
      </div>
    );
  }

  // app/global-error.tsx — root layout fallback
  'use client';
  export default function GlobalError({ error, reset }: { error: Error; reset: () => void }) {
    return (
      <html><body>
        <h2>Sistem error</h2>
        <button onClick={reset}>Reload</button>
      </body></html>
    );
  }
  ```

Pattern Aman (Laravel):
  ```php
  // app/Exceptions/Handler.php (Laravel 10) atau bootstrap/app.php (Laravel 11+)
  // report() → log ke file/service, render() → tampilkan halaman error generik
  public function report(Throwable $e): void {
      // Log detail ke server — BUKAN ke browser
      Log::error($e->getMessage(), ['trace' => $e->getTraceAsString()]);
      parent::report($e);
  }

  public function render($request, Throwable $e): Response {
      if ($e instanceof ModelNotFoundException) {
          return response()->view('errors.404', [], 404);
      }
      // FORBIDDEN: return response()->json(['error' => $e->getMessage()]) di production
      return parent::render($request, $e);
  }
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // ❌ Stack trace ke browser
  ini_set('display_errors', 1); // PRODUCTION = selalu 0

  // ❌ Generic catch kosong — error hilang tanpa jejak
  try { riskyOperation(); } catch (Exception $e) { /* diam-diam */ }

  // ❌ Error message langsung ke response
  return response()->json(['error' => $e->getMessage()]); // leaks internal info
  ```

  ```typescript
  // ❌ Throw tanpa catch — crash seluruh app
  // ❌ console.log(error.stack) di client-side — leaks source code structure
  ```

Awareness Note — Prototype Pollution (Node.js/Next.js):
  Tren CVE 2025-2026 menunjukkan kenaikan Prototype Pollution di environment Node.js.
  Mitigasi ringan: gunakan `Object.create(null)` untuk dictionary objects, hindari
  deep merge library yang tidak aman (lodash.merge < v4.6.2), dan pertimbangkan
  `--frozen-intrinsics` flag di Node.js v22+. Supply chain audit (SP-016) juga
  mendeteksi dependency yang rentan terhadap serangan ini.

Grep Indicators (untuk `cek komponen`):
  - PHP: `display_errors` = `0`, `set_error_handler`, `set_exception_handler`, error view file exists
  - Next.js: `error.tsx` atau `global-error.tsx` exists di `app/`, no `error.stack` in client code
  - Laravel: `Handler.php` atau `bootstrap/app.php` exception config, `APP_DEBUG=false` di `.env`
  - Grep FORBIDDEN: `display_errors.*1` di production, empty `catch` block, `$e->getMessage()` in response

Alasan: Tanpa penanganan error yang proper, stack trace bocor ke browser = information disclosure. Empty catch blocks = bug tersembunyi yang sulit di-debug. A10:2025 menjadikan ini kategori OWASP tersendiri.

---

[SP-020] SSRF Prevention (OWASP A01:2025)
Stack    : Universal (PHP Native, Next.js, Laravel)
Kategori : Access Control / Network

Pattern Aman (PHP Native):
  ```php
  function validateUrl(string $url): bool {
      $parsed = parse_url($url);
      if (!$parsed || !isset($parsed['host'])) return false;

      // Hanya izinkan scheme http/https
      if (!in_array($parsed['scheme'] ?? '', ['http', 'https'])) return false;

      // Block private IP ranges
      $ip = gethostbyname($parsed['host']);
      $privateRanges = [
          '127.0.0.0/8', '10.0.0.0/8', '172.16.0.0/12',
          '192.168.0.0/16', '169.254.0.0/16', '0.0.0.0/8',
      ];
      foreach ($privateRanges as $range) {
          [$subnet, $mask] = explode('/', $range);
          if ((ip2long($ip) & ~((1 << (32 - $mask)) - 1)) === ip2long($subnet)) {
              return false; // Private IP — BLOCKED
          }
      }

      // Allowlist domain (opsional — untuk use case spesifik)
      // $allowedDomains = ['api.example.com', 'cdn.example.com'];
      // if (!in_array($parsed['host'], $allowedDomains)) return false;

      return true;
  }

  // Penggunaan
  $userUrl = $_POST['url'];
  if (!validateUrl($userUrl)) {
      http_response_code(400);
      die('URL tidak diizinkan');
  }
  $content = file_get_contents($userUrl, false, stream_context_create([
      'http' => ['timeout' => 5, 'follow_location' => 0] // Jangan ikuti redirect
  ]));
  ```

Pattern Aman (Next.js):
  ```typescript
  // lib/url-validator.ts
  const BLOCKED_IP_PREFIXES = ['127.', '10.', '0.', '169.254.'];
  const BLOCKED_IP_RANGES = [
    { start: '172.16.0.0', end: '172.31.255.255' },
    { start: '192.168.0.0', end: '192.168.255.255' },
  ];

  export function isUrlSafe(url: string): boolean {
    try {
      const parsed = new URL(url);
      if (!['http:', 'https:'].includes(parsed.protocol)) return false;
      if (parsed.hostname === 'localhost') return false;
      if (BLOCKED_IP_PREFIXES.some(p => parsed.hostname.startsWith(p))) return false;
      // DNS rebinding: resolve hostname dan cek ulang IP sebelum fetch
      return true;
    } catch {
      return false;
    }
  }

  // API route usage
  export async function POST(req: Request) {
    const { url } = await req.json();
    if (!isUrlSafe(url)) {
      return Response.json({ error: 'URL blocked' }, { status: 400 });
    }
    const res = await fetch(url, { redirect: 'error', signal: AbortSignal.timeout(5000) });
    // ... process response
  }
  ```

Pattern Aman (Laravel):
  ```php
  // app/Services/UrlValidator.php
  use Illuminate\Support\Facades\Http;

  class UrlValidator {
      private const BLOCKED_CIDRS = [
          '127.0.0.0/8', '10.0.0.0/8', '172.16.0.0/12',
          '192.168.0.0/16', '169.254.0.0/16',
      ];

      public static function isSafe(string $url): bool {
          $parsed = parse_url($url);
          if (!$parsed || !in_array($parsed['scheme'] ?? '', ['http', 'https'])) return false;
          $ip = gethostbyname($parsed['host']);
          foreach (self::BLOCKED_CIDRS as $cidr) {
              if (self::ipInRange($ip, $cidr)) return false;
          }
          return true;
      }
  }

  // Controller usage
  if (!UrlValidator::isSafe($request->input('url'))) {
      abort(400, 'URL not allowed');
  }
  $response = Http::timeout(5)->withoutRedirecting()->get($request->input('url'));
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // ❌ Fetch URL user tanpa validasi apapun
  $content = file_get_contents($_GET['url']);

  // ❌ cURL tanpa cek IP tujuan
  curl_setopt($ch, CURLOPT_URL, $userInput);
  curl_exec($ch);
  ```

  ```typescript
  // ❌ Fetch langsung dari user input
  const data = await fetch(req.body.url); // SSRF vector

  // ❌ Redirect follow tanpa batas
  const res = await fetch(url, { redirect: 'follow' }); // bisa redirect ke internal
  ```

Grep Indicators (untuk `cek komponen`):
  - Cari `file_get_contents(` / `curl_setopt(` / `Http::get(` / `fetch(` yang menerima variabel user
  - Cek apakah ada fungsi `validateUrl` / `isUrlSafe` / `UrlValidator`
  - Cek apakah private IP blocking diimplementasikan (127.0, 10.0, 172.16, 192.168)
  - Grep FORBIDDEN: `file_get_contents($` + variabel dari `$_GET`/`$_POST`/`$request->input`

Alasan: SSRF naik 68% di 2025-2026 karena AI features yang fetch URL eksternal. Tanpa validasi, attacker bisa mengakses internal services (metadata endpoint, database, admin panel) melalui server-side request.

---

[SP-021] IDOR Prevention / Ownership Validation (OWASP A01:2025)
Stack    : Universal (PHP Native, Next.js, Laravel)
Kategori : Access Control / Authorization

Pattern Aman (PHP Native):
  ```php
  // SELALU tambahkan ownership check — jangan query by ID saja
  $stmt = $conn->prepare("SELECT * FROM orders WHERE id = ? AND user_id = ?");
  $stmt->bind_param("ii", $orderId, $_SESSION['user_id']);
  $stmt->execute();
  $order = $stmt->get_result()->fetch_assoc();

  if (!$order) {
      http_response_code(403);
      die('Akses ditolak');
  }
  ```

Pattern Aman (Next.js):
  ```typescript
  // app/api/orders/[id]/route.ts
  import { getServerSession } from 'next-auth';

  export async function GET(req: Request, { params }: { params: { id: string } }) {
    const session = await getServerSession(authOptions);
    if (!session) return Response.json({ error: 'Unauthorized' }, { status: 401 });

    const order = await prisma.order.findFirst({
      where: {
        id: params.id,
        userId: session.user.id, // OWNERSHIP CHECK — wajib
      },
    });

    if (!order) return Response.json({ error: 'Not found' }, { status: 404 });
    return Response.json(order);
  }
  ```

Pattern Aman (Laravel):
  ```php
  // Opsi 1: Query scope — langsung filter by user
  $order = Order::where('id', $id)
      ->where('user_id', auth()->id()) // OWNERSHIP CHECK
      ->firstOrFail();

  // Opsi 2: Policy Gate — reusable authorization logic
  // app/Policies/OrderPolicy.php
  public function view(User $user, Order $order): bool {
      return $user->id === $order->user_id;
  }

  // Controller
  $order = Order::findOrFail($id);
  $this->authorize('view', $order); // throws 403 if not owner
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // ❌ Query by ID tanpa ownership check — IDOR vulnerability
  $order = Order::find($request->id); // siapa saja bisa akses order orang lain
  return response()->json($order);

  // ❌ Cek role tapi tidak cek ownership
  if (auth()->user()->role === 'member') {
      $order = Order::find($id); // member bisa lihat order member lain!
  }
  ```

  ```typescript
  // ❌ Fetch by ID tanpa session check
  const order = await prisma.order.findUnique({ where: { id: params.id } });
  // attacker: GET /api/orders/other-user-order-id → data bocor
  ```

Grep Indicators (untuk `cek komponen`):
  - Cari semua query `findFirst`/`findUnique`/`find(`/`SELECT.*WHERE id =` yang TIDAK punya `user_id`/`userId` filter
  - Cek apakah ada Policy/Gate di Laravel (`authorize(`, `$this->authorize`)
  - Cek Next.js API routes: apakah `getServerSession` ada + ownership comparison
  - Grep FORBIDDEN: `::find($request->` atau `findUnique({ where: { id:` tanpa userId filter

Alasan: IDOR/BOLA memiliki prevalensi hampir 100% di assessments 2025-2026, terutama di kode yang di-generate AI karena AI sering tidak menambahkan authorization context. Setiap akses resource WAJIB divalidasi bahwa requester = owner.

---

[SP-022] Open Redirect Prevention (OWASP A01:2025)
Stack    : Universal (PHP Native, Next.js, Laravel)
Kategori : Access Control / Redirect

Pattern Aman (PHP Native):
  ```php
  // Allowlist-based redirect — HANYA izinkan path internal
  function safeRedirect(string $url, string $default = '/'): void {
      $parsed = parse_url($url);

      // Block: absolute URL ke domain lain
      if (isset($parsed['host']) || isset($parsed['scheme'])) {
          $url = $default; // Fallback ke default
      }

      // Block: protocol-relative URL (//evil.com)
      if (str_starts_with($url, '//')) {
          $url = $default;
      }

      // Hanya izinkan path yang dimulai dengan /
      if (!str_starts_with($url, '/')) {
          $url = $default;
      }

      header("Location: $url");
      exit;
  }

  // Penggunaan setelah login
  $redirect = $_GET['redirect'] ?? '/dashboard';
  safeRedirect($redirect, '/dashboard');
  ```

Pattern Aman (Next.js):
  ```typescript
  // lib/safe-redirect.ts
  const ALLOWED_HOSTS = [process.env.NEXT_PUBLIC_APP_URL];

  export function getSafeRedirectUrl(url: string, fallback = '/'): string {
    try {
      const parsed = new URL(url, process.env.NEXT_PUBLIC_APP_URL);
      // Hanya izinkan redirect ke domain sendiri
      if (!ALLOWED_HOSTS.includes(parsed.origin)) return fallback;
      return parsed.pathname + parsed.search; // Strip domain, ambil path saja
    } catch {
      // URL invalid → fallback
      return fallback;
    }
  }

  // API route / server action usage
  const redirectTo = getSafeRedirectUrl(searchParams.get('callbackUrl') ?? '/', '/dashboard');
  redirect(redirectTo);
  ```

Pattern Aman (Laravel):
  ```php
  // Gunakan built-in url()->previous() atau validasi manual
  use Illuminate\Support\Str;

  function safeRedirect(string $url, string $default = '/dashboard'): RedirectResponse {
      // Hanya izinkan URL yang dimulai dengan app URL sendiri
      if (!Str::startsWith($url, config('app.url'))) {
          $url = $default;
      }
      return redirect($url);
  }

  // Atau: gunakan intended() setelah login (built-in Laravel)
  return redirect()->intended('/dashboard');
  // intended() otomatis validasi URL yang disimpan di session — AMAN
  ```

Anti-Pattern (FORBIDDEN):
  ```php
  // ❌ Redirect langsung dari user input tanpa validasi
  header("Location: " . $_GET['redirect']);

  // ❌ Redirect ke URL apapun yang diberikan user
  return redirect($request->input('next'));

  // ❌ Cek domain tapi bisa di-bypass
  if (strpos($url, 'example.com') !== false) {
      header("Location: $url"); // attacker: evil.com?example.com
  }
  ```

  ```typescript
  // ❌ Next.js: redirect tanpa validasi
  redirect(searchParams.get('callbackUrl')!); // bisa ke domain lain

  // ❌ String matching yang bisa di-bypass
  if (url.includes('mysite.com')) redirect(url); // evil-mysite.com lolos
  ```

Grep Indicators (untuk `cek komponen`):
  - Cari `header("Location:` / `redirect(` / `redirect()` yang menerima variabel dari user input
  - Cek apakah ada fungsi `safeRedirect` / `getSafeRedirectUrl` / `intended()`
  - Cari parameter `?redirect=` / `?next=` / `?callbackUrl=` / `?return_url=` di routes
  - Grep FORBIDDEN: `header("Location: " . $_GET[` atau `redirect($request->input(` tanpa validasi

Alasan: Open Redirect sering dieksploitasi untuk phishing — attacker mengirim link login yang legitimate (misal `yoursite.com/login?redirect=evil.com`) sehingga korban percaya dan memasukkan kredensial di situs palsu setelah redirect. Umum ditemukan di bug bounty programs.

---

[SP-023] Security Headers Hygiene, Conflict Prevention & Origin Isolation (OWASP A02:2025)
Stack    : Universal (Semua Stack)
Kategori : Headers / Misconfiguration

Checklist Wajib:
  1. Single Layer Emission: Konfigurasikan security headers HANYA di satu layer utama (Web Server ATAU App Middleware) untuk mencegah duplikasi (Double/Triple Header Emission).
  2. Conflict Prevention: Pastikan tidak ada nilai bertentangan untuk header yang sama (misal `Referrer-Policy: strict-origin-when-cross-origin` vs `same-origin`).
  3. Strict Origin Isolation: Pasang `Cross-Origin-Opener-Policy: same-origin` (COOP) dan `Cross-Origin-Resource-Policy: same-origin` (CORP).
  4. Modern Policy Hardening: Pasang `X-Permitted-Cross-Domain-Policies: none`, nonaktifkan `X-XSS-Protection: 0` (deprecated), dan pasang `Permissions-Policy`.
  5. Clean Production CSP: Jangan pernah memasukkan `localhost` atau `ws://` di directive `connect-src` pada environment production. Pastikan directive `upgrade-insecure-requests;` aktif jika HTTPS.

Pattern Aman (Apache mod_headers with Unset Guard):
  ```apache
  <IfModule mod_headers.c>
      # Bersihkan potensi duplikasi dari layer upstream/aplikasi
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

      # Pasang header tunggal & presisi
      Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" env=HTTPS
      Header always set X-Content-Type-Options "nosniff"
      Header always set X-Frame-Options "SAMEORIGIN"
      Header always set Referrer-Policy "strict-origin-when-cross-origin"
      Header always set X-Permitted-Cross-Domain-Policies "none"
      Header always set Permissions-Policy "camera=(), microphone=(), geolocation=(self), payment=(), usb=()"
      Header always set Cross-Origin-Opener-Policy "same-origin"
      Header always set Cross-Origin-Resource-Policy "same-origin"
      Header always set X-XSS-Protection "0"
      Header always set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com data:; img-src 'self' data: https:; connect-src 'self'; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;"
  </IfModule>
  ```

Pattern Aman (Nginx):
  ```nginx
  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
  add_header X-Content-Type-Options "nosniff" always;
  add_header X-Frame-Options "SAMEORIGIN" always;
  add_header Referrer-Policy "strict-origin-when-cross-origin" always;
  add_header X-Permitted-Cross-Domain-Policies "none" always;
  add_header X-XSS-Protection "0" always;
  add_header Permissions-Policy "camera=(), microphone=(), geolocation=(self), payment=(), usb=()" always;
  add_header Cross-Origin-Opener-Policy "same-origin" always;
  add_header Cross-Origin-Resource-Policy "same-origin" always;
  add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com data:; img-src 'self' data: https:; connect-src 'self'; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;" always;
  ```

Anti-Pattern (FORBIDDEN):
  - Mengirim header berulang kali dengan directive `Header add` atau `add_header` tanpa evaluasi multi-tier.
  - Konflik `Referrer-Policy` (misal 2 policy berbeda dikirim bersamaan).
  - Membiarkan `localhost` di CSP connect-src pada production.

Grep Indicators (untuk `cek komponen`):
  - Cek `Cross-Origin-Opener-Policy` dan `Cross-Origin-Resource-Policy` ada di config server / middleware
  - Cek `X-Permitted-Cross-Domain-Policies` bernilai `none`
  - Cek tidak ada `Header add` ganda atau policy yang saling bertentangan

Alasan: Mencegah cross-origin data leaks, Spectre side-channel attacks, parser confusion pada browser akibat header bertabrakan, serta eksploitasi fitur internal via dev-mode leakage.

---

[SP-024] Role-Based Access Control (RBAC) & Admin Isolation (OWASP A01:2025)
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : Access Control / Authorization

Checklist Wajib:
  1. Server-Side Enforcement: Validasi role WAJIB dieksekusi di backend/server handler. FORBIDDEN mengandalkan penyembunyian menu/tombol di UI/frontend saja.
  2. Strict Role Enum: Definisikan role secara eksplisit ('admin', 'member', 'guest') — cegah nilai role arbitrer.
  3. Anti-Privilege-Escalation: Larang pengguna memperbarui role mereka sendiri. Saat update profile user, whitelist field yang diizinkan (name, email, avatar). Kolom `role` HANYA boleh diubah oleh superadmin melalui endpoint dedicated admin.
  4. Admin Route Isolation: Seluruh route/file `/admin/*` WAJIB dilindungi guard/middleware terpisah sebelum controller/view dieksekusi.
  5. Session/Token Re-verification: Jangan percayai role yang dikirim dari request body/client payload. Ambil role dari session terverifikasi atau database.

Pattern Aman (PHP Native):
  ```php
  // includes/auth_guard.php
  function requireRole(string $requiredRole): void {
      if (session_status() === PHP_SESSION_NONE) {
          session_start();
      }
      
      if (!isset($_SESSION['user_id']) || !isset($_SESSION['role'])) {
          http_response_code(401);
          header('Location: /login.php');
          exit;
      }

      $userRole = $_SESSION['role'];
      if ($userRole !== $requiredRole && $userRole !== 'superadmin') {
          http_response_code(403);
          echo json_encode(['error' => 'Forbidden: Insufficient privileges']);
          exit;
      }
  }

  // Pencegahan Privilege Escalation pada Update Profile:
  // FORBIDDEN: UPDATE users SET name = ?, role = ? WHERE id = ?
  // WAJIB whitelist field tanpa menyertakan 'role':
  function updateUserProfile(PDO $pdo, int $userId, string $name, string $email): bool {
      $stmt = $pdo->prepare("UPDATE users SET name = ?, email = ? WHERE id = ?");
      return $stmt->execute([$name, $email, $userId]);
  }
  ```

Pattern Aman (Next.js App Router / Middleware):
  ```typescript
  // middleware.ts atau lib/auth-guard.ts
  import { NextResponse } from 'next/server';
  import type { NextRequest } from 'next/server';

  export async function adminGuard(req: NextRequest, sessionUser: { id: string; role: string } | null) {
    if (!sessionUser) {
      return NextResponse.redirect(new URL('/login', req.url));
    }

    if (sessionUser.role !== 'admin' && sessionUser.role !== 'superadmin') {
      return new NextResponse(JSON.stringify({ error: 'Forbidden: Admin access required' }), {
        status: 403,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    return null; // Authorization passed
  }
  ```

Pattern Aman (Laravel Middleware):
  ```php
  // app/Http/Middleware/EnsureUserHasRole.php
  namespace App\Http\Middleware;

  use Closure;
  use Illuminate\Http\Request;
  use Symfony\Component\HttpFoundation\Response;

  class EnsureUserHasRole
  {
      public function handle(Request $request, Closure $next, string $role): Response
      {
          if (!$request->user() || !$request->user()->hasRole($role)) {
              abort(403, 'Unauthorized action.');
          }

          return $next($request);
      }
  }

  // routes/web.php
  Route::middleware(['auth', 'role:admin'])->prefix('admin')->group(function () {
      Route::get('/dashboard', [AdminController::class, 'index']);
      Route::patch('/users/{user}/role', [AdminController::class, 'updateRole']);
  });
  ```

Anti-Pattern (FORBIDDEN):
  - Memeriksa role hanya di UI (contoh: `{user.role === 'admin' && <AdminButton />}`) tanpa guard di server/API endpoint.
  - Membaca role langsung dari request parameter (contoh: `if ($req->input('role') === 'admin')`).
  - Mass assignment saat registrasi atau edit profil yang mengizinkan atribut `role` (contoh: `User::create($request->all())` tanpa guarded `$fillable`).

Grep Indicators (untuk `cek komponen`):
  - Cek implementasi `requireRole`, `is_admin`, `role_guard`, `authorize`, `ROLE_ADMIN`
  - Cek proteksi route `/admin` menggunakan middleware / guard
  - Cek apakah update profile user mem-blacklist/menghilangkan field `role` dari input user

Alasan: Mencegah Broken Access Control (OWASP A01) di mana attacker memodifikasi parameter role atau mengakses URL admin secara langsung untuk mengambil alih kontrol seluruh aplikasi.

---

[SP-025] Response Serialization & Secret Sanitization (OWASP A04:2025)
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : Data Exposure / Cryptographic Failures

Checklist Wajib:
  1. Response DTO / Whitelist: Kembalikan HANYA atribut yang dibutuhkan klien. FORBIDDEN mengembalikan raw database record (`SELECT * FROM users`) langsung ke output JSON.
  2. Blacklist Sensitive Fields: Pastikan field sensitif (`password`, `password_hash`, `api_token`, `reset_token`, `remember_token`, `secret_key`, `access_token`, `totp_secret`) selalu di-unset/dikeluarkan sebelum serialization.
  3. Masking Sensitif untuk Log & Audit: Jika token atau secret harus dicatat di log audit, lakukan masking (contoh: `sk_live_****a1b2`).
  4. Error Response Neutrality: Jangan pernah melampirkan exception trace atau internal database object di error response production.

Pattern Aman (PHP Native):
  ```php
  // includes/serializer.php
  function serializeUser(array $user): array {
      $forbiddenKeys = [
          'password', 'password_hash', 'api_token', 'reset_token', 
          'remember_token', 'secret_key', 'totp_secret', 'auth_token'
      ];
      
      foreach ($forbiddenKeys as $key) {
          unset($user[$key]);
      }
      
      return $user;
  }

  // Masking fungsi untuk audit log:
  function maskSecret(string $secret, int $visibleSuffix = 4): string {
      $len = strlen($secret);
      if ($len <= $visibleSuffix) {
          return str_repeat('*', $len);
      }
      return substr($secret, 0, min(8, $len - $visibleSuffix)) . '****' . substr($secret, -$visibleSuffix);
  }

  // Contoh Output Endpoint API:
  $stmt = $pdo->prepare("SELECT id, name, email, password_hash, role, created_at FROM users WHERE id = ?");
  $stmt->execute([$userId]);
  $rawUser = $stmt->fetch(PDO::FETCH_ASSOC);

  if ($rawUser) {
      $safeUser = serializeUser($rawUser);
      header('Content-Type: application/json');
      echo json_encode(['data' => $safeUser]);
  }
  ```

Pattern Aman (Next.js / Prisma / TypeScript):
  ```typescript
  // lib/serializers/user.ts
  export interface SafeUser {
    id: string;
    name: string;
    email: string;
    role: string;
    createdAt: Date;
  }

  // Gunakan explicit Prisma select alih-alih findMany default:
  export const safeUserSelect = {
    id: true,
    name: true,
    email: true,
    role: true,
    createdAt: true,
    // passwordHash, apiToken ditiadakan secara eksplisit
  } as const;

  export function sanitizeUser<T extends Record<string, any>>(user: T): Omit<T, 'passwordHash' | 'apiToken' | 'resetToken'> {
    const { passwordHash, apiToken, resetToken, ...safe } = user;
    return safe;
  }
  ```

Pattern Aman (Laravel Eloquent):
  ```php
  // app/Models/User.php
  class User extends Authenticatable
  {
      // Wajib deklarasikan $hidden agar tidak bocor saat toArray() / toJson():
      protected $hidden = [
          'password',
          'password_hash',
          'remember_token',
          'reset_token',
          'two_factor_secret',
          'two_factor_recovery_codes',
      ];
  }
  ```

Anti-Pattern (FORBIDDEN):
  - Mengirimkan record `SELECT * FROM users` langsung melalui `json_encode($user)` atau `res.json(user)`.
  - Mengembalikan objek credential user dalam response registrasi/login.
  - Mencetak token autentikasi atau API key mentah ke console/file log tanpa masking.

Grep Indicators (untuk `cek komponen`):
  - Cek keberadaan `$hidden` di model user (Laravel)
  - Cek sanitasi `unset($user['password'])` / `serializeUser` (PHP Native)
  - Cek pattern `safeUserSelect` / `exclude` (Prisma/TypeScript)
  - Grep FORBIDDEN: `echo json_encode($stmt->fetch())` tanpa filtering field

Alasan: Mencegah kebocoran credential dan token autentikasi (OWASP A04) kepada pihak ketiga, browser inspector, atau crawler yang dapat memfasilitasi account takeover massal.

---

[SP-026] Universal Input Validation & Schema Enforcement (OWASP A05:2025)
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : Input / Validation / Anti-Injection

Checklist Wajib:
  1. Strict Whitelist Schema: Validasi seluruh payload input berdasarkan tipe data, panjang string (min/max), format pola (regex), dan whitelist enum.
  2. Pre-Write Sanitization: Bersihkan null-byte injection (`\0`), whitespace berlebih, dan karakter berbahaya sebelum data diproses atau disimpan ke database.
  3. Rich-Text HTML Sanitization: Jika aplikasi menerima HTML input (WYSIWYG/blog), WAJIB menggunakan HTMLPurifier (PHP) atau DOMPurify (JavaScript) dengan allowlist tag & atribut yang ketat.
  4. Plain-Text Handling: Untuk input non-HTML, gunakan `strip_tags()` atau simpan teks apa adanya dan lakukan escaping saat render via `htmlspecialchars($val, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8')`.
  5. Server-Side Primacy: Validasi HTML5 di browser (`required`, `type="email"`) hanyalah UX helper — backend WAJIB melakukan validasi independen.

Pattern Aman (PHP Native):
  ```php
  // includes/Validator.php
  class Validator {
      public static function sanitizeString(string $input, int $maxLength = 255): string {
          // Buang null-bytes
          $clean = str_replace("\0", "", $input);
          $clean = trim($clean);
          if (mb_strlen($clean) > $maxLength) {
              $clean = mb_substr($clean, 0, $maxLength);
          }
          return $clean;
      }

      public static function validateEmail(string $email): ?string {
          $clean = self::sanitizeString($email, 254);
          if (!filter_var($clean, FILTER_VALIDATE_EMAIL)) {
              return null;
          }
          return strtolower($clean);
      }

      public static function validateEnum(string $value, array $allowed): bool {
          return in_array($value, $allowed, true);
      }
  }

  // Penggunaan di controller/endpoint:
  $rawName  = $_POST['name'] ?? '';
  $rawEmail = $_POST['email'] ?? '';
  $rawRole  = $_POST['role'] ?? 'member';

  $cleanName = Validator::sanitizeString($rawName, 100);
  $cleanEmail = Validator::validateEmail($rawEmail);
  $isRoleValid = Validator::validateEnum($rawRole, ['member', 'guest']);

  if (empty($cleanName) || !$cleanEmail || !$isRoleValid) {
      http_response_code(422);
      echo json_encode(['error' => 'Unprocessable Entity: Input validation failed']);
      exit;
  }
  ```

Pattern Aman (Next.js / TypeScript with Zod):
  ```typescript
  // lib/validations/user.ts
  import { z } from 'zod';

  export const UserRegistrationSchema = z.object({
    name: z.string().trim().min(2).max(100),
    email: z.string().trim().email().max(254).toLowerCase(),
    password: z.string().min(8).max(72), // 72 char limit untuk bcrypt
    role: z.enum(['member', 'guest']).default('member'),
  });

  export type UserRegistrationInput = z.infer<typeof UserRegistrationSchema>;

  // Di API Route:
  const result = UserRegistrationSchema.safeParse(body);
  if (!result.success) {
    return new Response(JSON.stringify({ errors: result.error.flatten() }), { status: 422 });
  }
  const cleanData = result.data;
  ```

Pattern Aman (Laravel FormRequest):
  ```php
  // app/Http/Requests/StoreUserRequest.php
  public function rules(): array
  {
      return [
          'name'     => ['required', 'string', 'min:2', 'max:100'],
          'email'    => ['required', 'email:rfc,dns', 'max:254', 'unique:users,email'],
          'password' => ['required', 'string', 'min:8', 'max:72'],
          'role'     => ['sometimes', 'in:member,guest'],
      ];
  }
  ```

Anti-Pattern (FORBIDDEN):
  - Menggunakan parameter request mentah (`$_POST['email']`, `req.body.name`) tanpa pemeriksaan tipe dan panjang karakter.
  - Blacklist regex parsing sederhana untuk mencegah injection (attacker selalu menemukan bypass).
  - Mempercayai validasi sisi klien tanpa server-side verification.

Grep Indicators (untuk `cek komponen`):
  - Cek pemanggilan `filter_var`, `Validator::`, `z.object`, `safeParse`, `FormRequest`
  - Cek sanitasi HTML dengan `HTMLPurifier` atau `DOMPurify` pada rich-text inputs
  - Cek proteksi null-byte `str_replace("\0"` pada file upload / raw text

Alasan: Validasi input yang tidak memadai adalah akar dari berbagai jenis injection (SQLi, XSS, Path Traversal, Null Byte Poisoning — OWASP A05).

---

[SP-027] Secure Password Reset & Token Lifecycle (OWASP A07:2025)
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : Auth / Cryptography / Token Lifecycle

Checklist Wajib:
  1. Cryptographic Randomness: Buat token reset menggunakan CSPRNG (`random_bytes(32) → bin2hex`).
  2. Token Hashing in Storage: JANGAN PERNAH menyimpan token reset dalam format plaintext di database. Simpan HASH SHA-256 dari token (`hash('sha256', $plainToken)`).
  3. Short Expiry Window: Token reset wajib kedaluwarsa dalam 15 hingga 30 menit (`expires_at`).
  4. Single-Use Invalidation: Hapus atau tandai token sebagai terpakai segera setelah password berhasil diubah (`DELETE FROM password_resets WHERE email = ?`).
  5. Invalidate Active Sessions: Setelah reset password berhasil, ubah `session_id` atau reset `remember_token` user untuk memaksa logout dari semua device lain.
  6. Anti-Email-Enumeration: Response endpoint permintaan reset password WAJIB generik ("If your email exists in our system, a password reset link has been sent"), terlepas dari apakah email terdaftar atau tidak.

Database Schema Wajib:
  ```sql
  CREATE TABLE password_reset_tokens (
      email VARCHAR(255) NOT NULL,
      token_hash VARCHAR(64) NOT NULL,
      expires_at DATETIME NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (email),
      INDEX idx_token_hash (token_hash)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
  ```

Pattern Aman (PHP Native):
  ```php
  // request_reset.php
  function createPasswordReset(PDO $pdo, string $email): void {
      // 1. Generate token kriptografi
      $plainToken = bin2hex(random_bytes(32));
      $tokenHash  = hash('sha256', $plainToken);
      $expiresAt  = date('Y-m-d H:i:s', time() + (15 * 60)); // 15 menit

      // 2. Simpan hash token di DB (replace jika sudah ada request sebelumnya)
      $stmt = $pdo->prepare("
          INSERT INTO password_reset_tokens (email, token_hash, expires_at)
          VALUES (?, ?, ?)
          ON DUPLICATE KEY UPDATE token_hash = VALUES(token_hash), expires_at = VALUES(expires_at)
      ");
      $stmt->execute([$email, $tokenHash, $expiresAt]);

      // 3. Kirim link via email HANYA jika email user valid di sistem
      // (Jalankan pengiriman email secara asinkron atau terisolasi)
      // URL: https://app.example.com/reset-password.php?token=" . $plainToken . "&email=" . urlencode($email)

      // 4. Response generik anti-enumeration
      echo json_encode([
          'message' => 'If your email exists in our system, a password reset link has been sent.'
      ]);
  }

  // verify_and_reset.php
  function processPasswordReset(PDO $pdo, string $email, string $plainToken, string $newPassword): bool {
      $tokenHash = hash('sha256', $plainToken);

      // Cari record reset yang valid dan belum expired
      $stmt = $pdo->prepare("
          SELECT email FROM password_reset_tokens 
          WHERE email = ? AND token_hash = ? AND expires_at > NOW()
      ");
      $stmt->execute([$email, $tokenHash]);
      if (!$stmt->fetch()) {
          return false; // Token invalid atau sudah expired
      }

      // Hash password baru dengan bcrypt / argon2id
      $newHash = password_hash($newPassword, PASSWORD_BCRYPT, ['cost' => 12]);

      $pdo->beginTransaction();
      try {
          // Update password user
          $updateStmt = $pdo->prepare("UPDATE users SET password_hash = ? WHERE email = ?");
          $updateStmt->execute([$newHash, $email]);

          // Single-use: Hapus token reset seketika
          $delStmt = $pdo->prepare("DELETE FROM password_reset_tokens WHERE email = ?");
          $delStmt->execute([$email]);

          $pdo->commit();
          return true;
      } catch (Exception $e) {
          $pdo->rollBack();
          return false;
      }
  }
  ```

Anti-Pattern (FORBIDDEN):
  - Menyimpan token reset dalam plaintext di database (kebocoran DB langsung membocorkan link reset aktif).
  - Masa berlaku token berjam-jam atau berhari-hari (>30 menit).
  - Mengizinkan token dipakai lebih dari sekali (reusable reset token).
  - Memberitahu klien: "Email tidak terdaftar" pada halaman forgot password (membuka enumerasi user).

Grep Indicators (untuk `cek komponen`):
  - Cek tabel `password_resets` atau `password_reset_tokens`
  - Cek pemanggilan `hash('sha256'` pada penyimpanan token reset
  - Cek masa kedaluwarsa token (`expires_at` < 30 menit)
  - Cek query `DELETE FROM password_reset_tokens` setelah update password

Alasan: Reset password adalah target utama pengambilalihan akun (Account Takeover). Token plaintext atau masa berlaku lama memungkinkan attacker meretas akun tanpa mengetahui password lama.

---

[SP-028] API Key Hashing & Lifecycle Management (OWASP A04:2025)
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : API Security / Authentication

Checklist Wajib:
  1. Full Key Single Exposure: Buat API key acak kriptografi (`sk_live_` + 64 karakter hex). Tampilkan plaintext key kepada user HANYA SEKALI saat generate.
  2. SHA-256 Hashing at Rest: Simpan HANYA hash SHA-256 dari API key di database (`hash('sha256', $rawKey)`). JANGAN PERNAH menyimpan raw key di tabel database.
  3. Key Identification Hint: Simpan prefix atau 8 karakter pertama untuk keperluan referensi UI (contoh: `sk_live_a1b2c3d4...`).
  4. Timing-Safe Comparison: Saat memverifikasi incoming request via header `X-API-Key`, hash input key dan verifikasi menggunakan `hash_equals()`.
  5. Scopes & Soft Revocation: Dukung permissions/scopes (`read`, `write`, `admin`) dan flag `is_active` / `revoked_at`.
  6. Audit Usage: Catat timestamp `last_used_at` dan `last_used_ip` setiap key digunakan.

Database Schema Wajib:
  ```sql
  CREATE TABLE api_keys (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT NOT NULL,
      name VARCHAR(100) NOT NULL,
      key_prefix VARCHAR(16) NOT NULL,
      key_hash VARCHAR(64) NOT NULL UNIQUE,
      scopes JSON DEFAULT NULL,
      is_active TINYINT(1) DEFAULT 1,
      last_used_at DATETIME DEFAULT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_key_hash (key_hash),
      INDEX idx_user_id (user_id)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
  ```

Pattern Aman (PHP Native):
  ```php
  // generate_api_key.php
  function generateApiKey(PDO $pdo, int $userId, string $keyName, array $scopes = ['read']): array {
      $randomBytes = random_bytes(32);
      $rawKey = 'sk_live_' . bin2hex($randomBytes);
      $keyPrefix = substr($rawKey, 0, 16);
      $keyHash = hash('sha256', $rawKey);

      $stmt = $pdo->prepare("
          INSERT INTO api_keys (user_id, name, key_prefix, key_hash, scopes, is_active)
          VALUES (?, ?, ?, ?, ?, 1)
      ");
      $stmt->execute([$userId, $keyName, $keyPrefix, $keyHash, json_encode($scopes)]);

      // Kembalikan $rawKey HANYA SATU KALI ini ke client
      return [
          'name'       => $keyName,
          'api_key'    => $rawKey, // User wajib menyalin sekarang!
          'key_prefix' => $keyPrefix,
          'scopes'     => $scopes
      ];
  }

  // middleware / verify_api_key.php
  function authenticateApiKey(PDO $pdo): ?array {
      $headers = getallheaders();
      $rawKey = $headers['X-API-Key'] ?? $headers['x-api-key'] ?? null;

      if (!$rawKey || !str_starts_with($rawKey, 'sk_live_')) {
          return null;
      }

      $incomingHash = hash('sha256', $rawKey);
      $stmt = $pdo->prepare("
          SELECT id, user_id, scopes, is_active FROM api_keys 
          WHERE key_hash = ? AND is_active = 1
      ");
      $stmt->execute([$incomingHash]);
      $keyRecord = $stmt->fetch(PDO::FETCH_ASSOC);

      if (!$keyRecord) {
          return null;
      }

      // Update usage stats (non-blocking)
      $update = $pdo->prepare("UPDATE api_keys SET last_used_at = NOW() WHERE id = ?");
      $update->execute([$keyRecord['id']]);

      return $keyRecord;
  }
  ```

Anti-Pattern (FORBIDDEN):
  - Menyimpan API Key mentah di database.
  - Membandingkan API Key menggunakan operator string biasa `==` (rentan timing attacks; gunakan hash matching atau `hash_equals()`).
  - Tidak menyediakan mekanisme revoke API key saat key bocor.

Grep Indicators (untuk `cek komponen`):
  - Cek tabel `api_keys` dan kolom `key_hash`
  - Cek query `WHERE key_hash = ?`
  - Cek pembacaan header `X-API-Key`
  - Cek hashing `hash('sha256', $rawKey)` pada pembuatan dan validasi key

Alasan: Jika database bocor, API key yang di-hash dengan SHA-256 tidak dapat langsung dipakai oleh penyerang, persis seperti password hashing.

---

[SP-029] Database Network Isolation & Least Privilege (OWASP A02:2025)
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : Database / Infrastructure Hardening

Checklist Wajib:
  1. Localhost Binding: Database server HANYA boleh mendengarkan koneksi loopback lokal (`127.0.0.1`). FORBIDDEN membuka binding ke seluruh interface (`0.0.0.0`) kecuali arsitektur dedicated DB cluster dengan private VPC.
  2. Non-Root Dedicated User: Aplikasi WAJIB terhubung menggunakan database user khusus aplikasi (misal `app_user`), bukan user `root` atau `postgres`.
  3. Strict DML Least-Privilege: User database aplikasi HANYA boleh memiliki izin Data Manipulation Language (`SELECT`, `INSERT`, `UPDATE`, `DELETE`). FORBIDDEN memberikan `GRANT ALL`, `DROP`, `ALTER`, `GRANT OPTION`, atau `SUPER`.
  4. Port Firewall Rule: Port database (3306 MySQL / 5432 PostgreSQL) wajib diblokir dari koneksi publik oleh firewall OS.

SQL Hardening Snippet (MySQL / MariaDB):
  ```sql
  -- 1. Buat user aplikasi khusus dengan akses HANYA dari localhost:
  CREATE USER 'brainvibes_app'@'127.0.0.1' IDENTIFIED BY 'StrongRandomPassword_123!';

  -- 2. Berikan HANYA hak DML pada database aplikasi:
  GRANT SELECT, INSERT, UPDATE, DELETE ON brainvibes_db.* TO 'brainvibes_app'@'127.0.0.1';

  -- 3. Terapkan perubahan hak akses:
  FLUSH PRIVILEGES;

  -- 4. Pastikan user root lokal memiliki password kuat dan tidak bisa login remote:
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'SuperSecureRootPassword_456!';
  DELETE FROM mysql.user WHERE Host NOT IN ('localhost', '127.0.0.1', '::1');
  FLUSH PRIVILEGES;
  ```

Cross-Platform Reference Table (Windows XAMPP vs Linux Native Arch/Cachy/Debian):

| Komponen | Windows (XAMPP) | Linux (Arch / Cachy OS) | Linux (Debian / Ubuntu) |
|---|---|---|---|
| **MySQL Config** | `C:\xampp\mysql\bin\my.ini` | `/etc/my.cnf.d/server.cnf` | `/etc/mysql/mysql.conf.d/mysqld.cnf` |
| **PostgreSQL Config** | `C:\Program Files\PostgreSQL\16\data\postgresql.conf` | `/var/lib/postgres/data/postgresql.conf` | `/etc/postgresql/16/main/postgresql.conf` |
| **Directive Bind** | `bind-address = 127.0.0.1` | `bind-address = 127.0.0.1` | `bind-address = 127.0.0.1` |
| **Restart Service** | XAMPP Control Panel → MySQL Stop/Start | `sudo systemctl restart mariadb` | `sudo systemctl restart mysql` |
| **Firewall Rule** | `netsh advfirewall firewall add rule name="Block MySQL" dir=in action=block protocol=TCP localport=3306` | `sudo iptables -A INPUT -p tcp --dport 3306 ! -s 127.0.0.1 -j DROP` | `sudo ufw deny 3306/tcp` |

Anti-Pattern (FORBIDDEN):
  - Menghubungkan aplikasi dengan user `root` tanpa password atau dengan password default.
  - Mengonfigurasi `bind-address = 0.0.0.0` pada server yang terhubung langsung ke internet publik.
  - Memberikan izin `GRANT ALL PRIVILEGES ON *.*` kepada user runtime aplikasi.

Grep Indicators (untuk `cek komponen`):
  - Cek konfigurasi `bind-address` di `my.ini` / `mysqld.cnf`
  - Cek kredensial database di `.env`: pastikan `DB_USERNAME` bukan `root` pada production
  - Cek hak akses user di database: `SHOW GRANTS FOR 'user'@'localhost'`

Alasan: Mencegah attacker mengekspos dan mengunduh database secara langsung melalui internet terbuka, serta membatasi dampak SQL Injection (tidak dapat mengeksekusi `DROP TABLE` atau membaca tabel sistem `mysql.user`).

---

[SP-030] File Upload Malware Scanning & SVG Sanitization (OWASP A05:2025)
Stack    : Universal (PHP Native, Laravel, Next.js)
Kategori : Upload / Malware Defense / SVG Sanitization

Checklist Wajib:
  1. Deep Binary Magic-Byte Verification: Periksa magic bytes file binary (JPEG: `\xFF\xD8\xFF`, PNG: `\x89PNG\r\n\x1a\n`, PDF: `%PDF-`), jangan percaya pada ekstensi file atau header `Content-Type` klien.
  2. SVG Sanitization Guard: File SVG adalah dokumen XML yang dapat menyisipkan JavaScript (`<script>`, `<a href="javascript:...">`, event handler `onload=`). Sanitasi WAJIB dilakukan sebelum file SVG disimpan atau ditampilkan.
  3. Malware Scanner (ClamAV Daemon / VirusTotal API): Jalankan pemindaian malware pada file temporer upload sebelum dipindahkan ke folder penyimpanan permanen.
  4. Isolated Storage Outside Webroot: Simpan file hasil upload di direktori di luar web root (akses via streaming controller) dan nonaktifkan eksekusi skrip (`php_flag engine off`).

Pattern Aman (ClamAV Daemon Scanning via Socket/TCP — PHP):
  ```php
  // includes/MalwareScanner.php
  class MalwareScanner {
      private string $socketPath;
      private bool $isTcp;

      public function __construct() {
          // Cross-platform socket detection:
          // Linux (Cachy OS / Debian): Unix socket /var/run/clamav/clamd.ctl
          // Windows: TCP socket 127.0.0.1:3310
          if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
              $this->socketPath = 'tcp://127.0.0.1:3310';
              $this->isTcp = true;
          } else {
              $this->socketPath = 'unix:///var/run/clamav/clamd.ctl';
              $this->isTcp = false;
          }
      }

      public function scanFile(string $filePath): array {
          if (!file_exists($filePath)) {
              return ['clean' => false, 'error' => 'File not found'];
          }

          $socket = @stream_socket_client($this->socketPath, $errno, $errstr, 2);
          if (!$socket) {
              // Fallback / Log: ClamAV daemon tidak aktif
              error_log("ClamAV daemon unreachable: $errstr ($errno)");
              return ['clean' => true, 'warning' => 'Scanner offline, passed with strict MIME verification'];
          }

          // Kirim perintah SCAN ke ClamAV daemon
          fwrite($socket, "SCAN " . realpath($filePath) . "\n");
          $response = trim(fgets($socket));
          fclose($socket);

          // Response format: "/path/to/file: OK" atau "/path/to/file: VirusFound FOUND"
          if (str_ends_with($response, 'OK')) {
              return ['clean' => true];
          }

          return ['clean' => false, 'threat' => $response];
      }
  }
  ```

Pattern Aman (SVG XML Sanitization — PHP Native):
  ```php
  // includes/SvgSanitizer.php
  function sanitizeSvgContent(string $svgXml): ?string {
      // 1. Blokir External Entity (XXE)
      $previousEntityLoader = libxml_disable_entity_loader(true);
      
      $dom = new DOMDocument();
      // Suppress XML parsing warnings
      libxml_use_internal_errors(true);
      if (!$dom->loadXML($svgXml, LIBXML_NONET | LIBXML_NOBLANKS)) {
          libxml_clear_errors();
          return null; // Invalid XML
      }
      libxml_clear_errors();

      // 2. Daftar tag dan atribut berbahaya
      $dangerousTags = ['script', 'use', 'foreignobject', 'iframe', 'embed', 'object'];
      $xpath = new DOMXPath($dom);

      foreach ($dangerousTags as $tag) {
          $elements = $xpath->query("//*[local-name()='$tag']");
          foreach ($elements as $element) {
              $element->parentNode->removeChild($element);
          }
      }

      // 3. Bersihkan inline event handler (onload, onclick, dll) dan href berbahaya
      $nodes = $xpath->query('//*[@*]');
      foreach ($nodes as $node) {
          foreach (iterator_to_array($node->attributes) as $attr) {
              $attrName = strtolower($attr->name);
              $attrVal = strtolower(trim($attr->value));
              if (str_starts_with($attrName, 'on') || str_contains($attrVal, 'javascript:') || str_contains($attrVal, 'data:text/html')) {
                  $node->removeAttribute($attr->name);
              }
          }
      }

      return $dom->saveXML();
  }
  ```

Cross-Platform Deployment Guide (ClamAV):

| Platform | Instalasi | Konfigurasi Socket | Service Command |
|---|---|---|---|
| **Arch / Cachy OS** | `sudo pacman -S clamav` | `/etc/clamav/clamd.conf` → `LocalSocket /var/run/clamav/clamd.ctl` | `sudo freshclam && sudo systemctl enable --now clamav-daemon` |
| **Debian / Ubuntu** | `sudo apt install clamav clamav-daemon` | `/etc/clamav/clamd.conf` → `LocalSocket /var/run/clamav/clamd.ctl` | `sudo freshclam && sudo systemctl enable --now clamav-daemon` |
| **Windows** | Download installer dari clamav.net atau `choco install clamav` | `clamd.conf` → `TCPSocket 3310` & `TCPAddr 127.0.0.1` | `freshclam.exe` → jalankan `clamd.exe` |

Anti-Pattern (FORBIDDEN):
  - Mengizinkan upload SVG langsung tanpa parsing XML dan pembersihan tag `<script>` (Stored XSS).
  - Menyimpan file upload di dalam direktori `public/` atau `htdocs/` dengan permission eksekusi.
  - Memverifikasi jenis file hanya dari `$_FILES['file']['type']` yang dikirim browser.

Grep Indicators (untuk `cek komponen`):
  - Cek scanner file: `MalwareScanner`, `clamdscan`, `stream_socket_client`, `clamav`
  - Cek sanitasi SVG: `sanitizeSvg`, `DOMDocument`, `LIBXML_NONET`, `foreignObject`
  - Cek verifikasi magic-bytes: `finfo`, `FILEINFO_MIME_TYPE`

Alasan: Mencegah eksekusi webshell, serangan Stored XSS via SVG vektor, distribusi malware ransomware melalui server aplikasi, dan eksploitasi XML External Entity (XXE).
