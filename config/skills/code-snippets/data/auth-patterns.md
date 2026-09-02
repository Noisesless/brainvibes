# Auth Patterns — Snippet Library

*Pattern autentikasi siap pakai per stack.*

---

### [CS-030] PHP Native Auth Handler (Session + CSRF + Captcha)
Stack: PHP Native
Kompleksitas: Medium
Referensi: vibes-stack-patterns/php-native-patterns.md Pattern 1

> Lihat Knowledge Item `vibes-stack-patterns/artifacts/php-native-patterns.md` Pattern 1 untuk implementasi lengkap (Login Handler + Auth Middleware).

Ringkasan quick-ref:
```php
// Login: session_regenerate_id(true) + password_verify() + CSRF check + captcha case-insensitive
// Guard: requireAuth($role) di awal setiap halaman protected
// Logout: session_destroy() + redirect ke login
```

---

### [CS-031] Next.js App Router Auth (Middleware + Server Action)
Stack: Next.js 14+ App Router
Kompleksitas: Medium
Referensi: vibes-stack-patterns/nextjs-patterns.md Pattern 2 & 7

> Lihat Knowledge Item `vibes-stack-patterns/artifacts/nextjs-patterns.md` Pattern 2 (Middleware) dan Pattern 7 (Server Action) untuk implementasi lengkap.

Ringkasan quick-ref:
```typescript
// Middleware: cek cookie auth_token di setiap request → redirect ke /login jika tidak ada
// Server Action: loginAction(formData) → set httpOnly cookie → return redirect path
// Role guard: cek user_role cookie di middleware untuk /admin/* paths
```

---

### [CS-032] Role-Based Access Control (RBAC) Matrix
Stack: Universal (Concept)
Kompleksitas: Simple

```
Zona Akses (sesuai gemini.md §4B):
┌─────────────────────────────────────────────────┐
│ ZONA 1 (Public)  : Landing, Login, Register     │
│ ZONA 2 (Member)  : Dashboard, Profil, Settings  │
│ ZONA 3 (Admin)   : User Management, CMS, Logs   │
└─────────────────────────────────────────────────┘

Credential Seeder Default:
Admin  : admin@[domain].com / Adm![AppSlug]@[4digit]
Member : member@[domain].com / Mem![AppSlug]@[4digit]
```

---

### [CS-033] Rate Limiter Middleware Boilerplate (Brute Force Protection)
Stack: PHP Native / Next.js / Laravel
Kompleksitas: Medium
Referensi: secure-patterns.md SP-014, SP-015, SP-PHP-004

```php
// PHP Native Session Rate Limiter (login / register / reset password)
function checkRateLimit($endpoint_key = 'login', $max_attempts = 5, $decay_seconds = 900) {
    if (session_status() === PHP_SESSION_NONE) session_start();
    $attempts_key = 'rate_limit_' . $endpoint_key . '_attempts';
    $time_key = 'rate_limit_' . $endpoint_key . '_time';

    $now = time();
    $attempts = $_SESSION[$attempts_key] ?? 0;
    $first_attempt = $_SESSION[$time_key] ?? $now;

    if ($now - $first_attempt > $decay_seconds) {
        $_SESSION[$attempts_key] = 1;
        $_SESSION[$time_key] = $now;
        return true;
    }

    if ($attempts >= $max_attempts) {
        http_response_code(429);
        header('Retry-After: ' . ($decay_seconds - ($now - $first_attempt)));
        echo json_encode(['error' => 'Too many requests. Please try again later.']);
        exit;
    }

    $_SESSION[$attempts_key] = $attempts + 1;
    return true;
}
```

---

### [CS-034] Unified Security Headers Middleware (Clean & Hardened)
Stack: PHP Native
Kompleksitas: Medium
Referensi: secure-patterns.md SP-011, SP-023

```php
<?php
// includes/security_headers.php — Proteksi 8 Header Modern + Anti-Duplikasi + HTTPS-Only CSP
function applySecurityHeaders(): void {
    if (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
        header("Strict-Transport-Security: max-age=31536000; includeSubDomains; preload");
    }
    header("X-Content-Type-Options: nosniff");
    header("X-Frame-Options: SAMEORIGIN");
    header("Referrer-Policy: strict-origin-when-cross-origin");
    header("X-Permitted-Cross-Domain-Policies: none");
    header("X-XSS-Protection: 0");
    header("Cross-Origin-Opener-Policy: same-origin");
    header("Cross-Origin-Resource-Policy: same-origin");
    header("Permissions-Policy: camera=(), microphone=(), geolocation=(self), payment=(), usb=()");

    $isDev = (getenv('APP_ENV') === 'development' || in_array($_SERVER['HTTP_HOST'] ?? '', ['localhost', '127.0.0.1']));
    $connectSrc = "'self'" . ($isDev ? " http://localhost:* ws://localhost:*" : "");

    header("Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com data:; img-src 'self' data: https:; connect-src {$connectSrc}; frame-ancestors 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;");
}
```


