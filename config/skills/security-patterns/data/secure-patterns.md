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
