# Vibes Stack Patterns — PHP Native

*Pattern kode yang sudah terbukti bekerja di proyek PHP Native dengan Vibes Coding Workflow. Langsung pakai tanpa reinventing.*

---

## Pattern 1: Auth System (Session-Based + Captcha)

### Login Handler
```php
<?php
session_start();
require_once 'includes/db.php';
require_once 'includes/functions.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: login.php');
    exit;
}

// Validasi CSRF
if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
    setToast('error', 'Sesi tidak valid. Silakan coba lagi.');
    header('Location: login.php');
    exit;
}

// Validasi Captcha (Case-Insensitive sesuai gemini.md §4B)
if (strtolower($_SESSION['captcha_code'] ?? '') !== strtolower($_POST['captcha'] ?? '')) {
    // Destroy captcha lama, generate baru (State Destruction on Failure)
    unset($_SESSION['captcha_code']);
    setToast('error', 'Kode captcha salah.');
    header('Location: login.php');
    exit;
}

// Dual Input: email ATAU username
$identity = trim($_POST['identity'] ?? '');
$password = $_POST['password'] ?? '';

$stmt = $conn->prepare("SELECT * FROM users WHERE (email = ? OR username = ?) AND status = 'active' LIMIT 1");
$stmt->bind_param("ss", $identity, $identity);
$stmt->execute();
$user = $stmt->get_result()->fetch_assoc();

if ($user && password_verify($password, $user['password'])) {
    session_regenerate_id(true); // Anti session fixation
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['user_role'] = $user['role'];
    $_SESSION['user_name'] = $user['name'];
    $_SESSION['user_avatar'] = $user['avatar_urls'] ? json_decode($user['avatar_urls'], true) : null;

    unset($_SESSION['captcha_code']); // Cleanup
    header('Location: ' . ($user['role'] === 'admin' ? 'admin/dashboard.php' : 'dashboard.php'));
} else {
    unset($_SESSION['captcha_code']); // Generate baru
    setToast('error', 'Email/username atau password salah.');
    header('Location: login.php');
}
exit;
```

### Auth Middleware (Route Guard)
```php
<?php
// includes/auth.php — include di awal setiap halaman protected
session_start();

function requireAuth($requiredRole = null) {
    if (!isset($_SESSION['user_id'])) {
        header('Location: ' . baseUrl('login.php'));
        exit;
    }
    if ($requiredRole && ($_SESSION['user_role'] ?? '') !== $requiredRole) {
        http_response_code(403);
        include 'views/errors/403.php';
        exit;
    }
}

function isLoggedIn(): bool {
    return isset($_SESSION['user_id']);
}

function isAdmin(): bool {
    return ($_SESSION['user_role'] ?? '') === 'admin';
}
```

---

## Pattern 2: Dynamic Base URL (Anti-Broken Path)

```php
<?php
// includes/functions.php

function baseUrl(string $path = ''): string {
    $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'];
    // Deteksi sub-folder otomatis dari SCRIPT_NAME
    $basePath = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/\\');
    $url = "{$protocol}://{$host}{$basePath}";
    return $path ? rtrim($url, '/') . '/' . ltrim($path, '/') : $url . '/';
}

function asset(string $path): string {
    return baseUrl("assets/{$path}");
}

// Penggunaan di HTML:
// <link href="<?= asset('css/style.css') ?>?v=1.0.0" rel="stylesheet">
// <img src="<?= asset('img/hero.webp') ?>" alt="Hero">
// <a href="<?= baseUrl('dashboard.php') ?>">Dashboard</a>
```

---

## Pattern 3: Database Connection (Singleton + UTF8MB4)

```php
<?php
// includes/db.php
$host = getenv('DB_HOST') ?: 'localhost';
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASS') ?: '';
$name = getenv('DB_NAME') ?: 'myapp';

$conn = new mysqli($host, $user, $pass, $name);

if ($conn->connect_error) {
    error_log("DB Connection Failed: " . $conn->connect_error);
    http_response_code(500);
    die(json_encode(['error' => 'Koneksi database gagal.']));
}

$conn->set_charset("utf8mb4");

// ACID Transaction wrapper:
function dbTransaction(mysqli $conn, callable $callback) {
    $conn->begin_transaction();
    try {
        $result = $callback($conn);
        $conn->commit();
        return $result;
    } catch (Exception $e) {
        $conn->rollback();
        throw $e;
    }
}
```

---

## Pattern 4: Secure Upload Pipeline (5 Tahap)

```php
<?php
// includes/upload.php — Sesuai gemini.md §4E

function processUpload(array $file, string $context = 'content', string $targetDir = 'assets/images/'): array {
    $allowedMimes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    $maxSize = 10 * 1024 * 1024; // 10MB

    // Tahap 1: Validasi
    if ($file['error'] !== UPLOAD_ERR_OK) throw new Exception('Upload gagal.');
    if ($file['size'] > $maxSize) throw new Exception('File terlalu besar. Maks 10MB.');

    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mime = $finfo->file($file['tmp_name']);
    if (!in_array($mime, $allowedMimes)) throw new Exception('Format tidak diizinkan.');

    // Tahap 2: Nama aman (APP_SLUG + UUID)
    $appSlug = getenv('APP_SLUG') ?: 'app';
    $uuid = substr(bin2hex(random_bytes(4)), 0, 8);
    $filename = "{$appSlug}_{$context}_{$uuid}_" . time() . ".webp";

    // Tahap 3 & 4: Kompresi WebP (via GD Library)
    $image = match($mime) {
        'image/jpeg' => imagecreatefromjpeg($file['tmp_name']),
        'image/png'  => imagecreatefrompng($file['tmp_name']),
        'image/webp' => imagecreatefromwebp($file['tmp_name']),
        'image/gif'  => imagecreatefromgif($file['tmp_name']),
    };

    $fullPath = $targetDir . $filename;
    imagewebp($image, $fullPath, 80); // Quality 80
    imagedestroy($image);

    return ['filename' => $filename, 'path' => $fullPath, 'url' => baseUrl($fullPath)];
}
```

---

## Pattern 5: Toast Notification System

```php
<?php
// includes/functions.php
function setToast(string $type, string $message): void {
    $_SESSION['toast'] = ['type' => $type, 'message' => $message];
}

function renderToast(): string {
    if (!isset($_SESSION['toast'])) return '';
    $toast = $_SESSION['toast'];
    unset($_SESSION['toast']);
    $colors = ['success' => 'var(--vibe-success)', 'error' => 'var(--vibe-error)', 'warning' => 'var(--vibe-warning)'];
    $bg = $colors[$toast['type']] ?? $colors['success'];
    return "<div class='toast' style='background:{$bg}' data-duration='3000'>{$toast['message']}</div>";
}
```

```javascript
// assets/js/toast.js
document.addEventListener('DOMContentLoaded', () => {
  const toast = document.querySelector('.toast');
  if (!toast) return;
  toast.classList.add('toast--visible');
  setTimeout(() => {
    toast.classList.remove('toast--visible');
    setTimeout(() => toast.remove(), 300);
  }, parseInt(toast.dataset.duration) || 3000);
});
```

---

## Pattern 6: Captcha Generator (High-Contrast + Refresh)

```php
<?php
// api/captcha.php
session_start();
header('Content-Type: image/png');
header('Cache-Control: no-cache, no-store, must-revalidate');

$code = substr(str_shuffle('ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789'), 0, 5);
$_SESSION['captcha_code'] = $code;

$img = imagecreatetruecolor(150, 50);
$bg = imagecolorallocate($img, 20, 20, 40);      // Dark background
$textColor = imagecolorallocate($img, 255, 107, 0); // High-contrast orange (accent)
imagefill($img, 0, 0, $bg);

// Noise lines untuk anti-OCR
for ($i = 0; $i < 5; $i++) {
    $lineColor = imagecolorallocate($img, rand(50,100), rand(50,100), rand(50,100));
    imageline($img, rand(0,150), rand(0,50), rand(0,150), rand(0,50), $lineColor);
}

imagestring($img, 5, 35, 15, $code, $textColor);
imagepng($img);
imagedestroy($img);
```

---

## Pattern 7: Dynamic App Settings (dari Database)

```php
<?php
// includes/settings.php
function getSettings(mysqli $conn): array {
    static $cache = null;
    if ($cache !== null) return $cache;

    $result = $conn->query("SELECT setting_key, setting_value FROM settings");
    $settings = [];
    while ($row = $result->fetch_assoc()) {
        $settings[$row['setting_key']] = $row['setting_value'];
    }
    $cache = $settings;
    return $settings;
}

function getSetting(mysqli $conn, string $key, string $default = ''): string {
    $settings = getSettings($conn);
    return $settings[$key] ?? $default;
}

// Penggunaan (Dynamic Identity — FORBIDDEN hardcode):
// <title><?= getSetting($conn, 'app_name', 'My App') ?></title>
// <img src="<?= getSetting($conn, 'app_logo', asset('img/logo-default.svg')) ?>">
```

---

## Pattern 8: Unified Security Headers Middleware (Clean & Hardened)

```php
<?php
// includes/security_headers.php — Include di baris paling awal bootstrap / index.php sebelum output HTML

function setSecurityHeaders(array $customCsp = []): void {
    // 1. HSTS (Hanya jika HTTPS aktif)
    if (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
        header("Strict-Transport-Security: max-age=31536000; includeSubDomains; preload");
    }

    // 2. MIME & Clickjacking
    header("X-Content-Type-Options: nosniff");
    header("X-Frame-Options: SAMEORIGIN");

    // 3. Referrer & Cross-Domain Policy
    header("Referrer-Policy: strict-origin-when-cross-origin");
    header("X-Permitted-Cross-Domain-Policies: none");

    // 4. Legacy XSS Filter Deprecation (Modern standard: disable legacy auditor to prevent XS-Leaks)
    header("X-XSS-Protection: 0");

    // 5. Origin Isolation (Spectre & Cross-Window manipulation guard)
    header("Cross-Origin-Opener-Policy: same-origin");
    header("Cross-Origin-Resource-Policy: same-origin");

    // 6. Device & API Permissions
    header("Permissions-Policy: camera=(), microphone=(), geolocation=(self), payment=(), usb=()");

    // 7. Environment-Aware CSP (No HTTP sources in production, automatic HTTPS upgrade)
    $isDev = (getenv('APP_ENV') === 'development' || in_array($_SERVER['HTTP_HOST'] ?? '', ['localhost', '127.0.0.1']));
    
    $connectSrc = "'self'";
    if ($isDev) {
        $connectSrc .= " http://localhost:* ws://localhost:*";
    }

    $defaultDirectives = [
        "default-src 'self'",
        "script-src 'self'",
        "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
        "font-src 'self' https://fonts.gstatic.com data:",
        "img-src 'self' data: https:",
        "connect-src {$connectSrc}",
        "frame-ancestors 'self'",
        "object-src 'none'",
        "base-uri 'self'",
        "form-action 'self'",
        "upgrade-insecure-requests"
    ];

    $mergedDirectives = array_merge($defaultDirectives, $customCsp);
    header("Content-Security-Policy: " . implode('; ', $mergedDirectives) . ";");
}

// Panggil di awal bootstrap:
// setSecurityHeaders();
```

