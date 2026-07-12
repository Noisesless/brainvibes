# Stack Gotchas — Jebakan Spesifik per Stack

*Hal-hal yang tidak obvious tapi sering bikin stuck. Diisi dari pengalaman nyata.*

---

## Format Entry

```
[SG-NNN] [Deskripsi jebakan]
Stack: [framework/OS/versi]
Kapan terjadi: [kondisi yang memicu]
Workaround: [cara menghindari atau mengatasinya]
Referensi: [link docs atau issue jika ada]
Tanggal: [YYYY-MM-DD]
```

---

## XAMPP + Windows

[SG-001] Windows Defender / Antivirus memblokir Apache atau MySQL
Stack: XAMPP / Windows 10-11
Kapan terjadi: Instalasi baru XAMPP atau setelah update Windows
Workaround: Tambahkan exception di Windows Defender untuk folder `C:\xampp\`. Settings → Virus & threat → Exclusions → Add folder.
Tanggal: 2026-07-01

[SG-002] php.ini yang diedit BUKAN yang active — XAMPP punya 2 file
Stack: XAMPP / PHP
Kapan terjadi: Ubah php.ini tapi perubahan tidak efek
Workaround: XAMPP pakai `C:\xampp\php\php.ini` (BUKAN `C:\xampp\apache\bin\php.ini`). Cek via `phpinfo()` → "Loaded Configuration File".
Tanggal: 2026-07-01

[SG-003] Path separator Windows backslash vs Linux forward slash
Stack: PHP / Windows → Linux deploy
Kapan terjadi: Deploy dari Windows ke Linux hosting — path `\` gagal
Workaround: Selalu gunakan `DIRECTORY_SEPARATOR` atau forward slash `/` yang bekerja di keduanya. PHP `__DIR__ . '/includes/file.php'` (bukan `\\`)
Tanggal: 2026-07-02

---

## PHP Native

[SG-004] `header('Location: ...')` gagal redirect — "headers already sent"
Stack: PHP Native
Kapan terjadi: Ada whitespace/BOM sebelum `<?php` atau echo sebelum header()
Workaround: Pastikan `<?php` di baris 1 TANPA spasi sebelumnya. Gunakan `ob_start()` di awal jika terpaksa ada output.
Tanggal: 2026-07-01

[SG-005] `password_verify()` selalu return false meski password benar
Stack: PHP 8+
Kapan terjadi: Hash disimpan di kolom VARCHAR yang terlalu pendek (< 60 karakter)
Workaround: Kolom password di DB WAJIB minimal `VARCHAR(255)`. Bcrypt hash = 60 chars, Argon2 = lebih panjang.
Tanggal: 2026-07-02

[SG-006] `json_encode()` return false untuk data dengan karakter khusus Indonesia
Stack: PHP / MySQL
Kapan terjadi: Data dari database mengandung karakter non-UTF8
Workaround: Set koneksi DB ke `utf8mb4` + tambah flag `JSON_UNESCAPED_UNICODE` di `json_encode($data, JSON_UNESCAPED_UNICODE)`
Tanggal: 2026-07-02

---

## Laravel

[SG-007] `php artisan` commands gagal setelah pull — "class not found"
Stack: Laravel 10+
Kapan terjadi: Setelah pull/merge yang menambah package atau model baru
Workaround: Jalankan `composer dump-autoload` → `php artisan config:clear` → `php artisan cache:clear`
Tanggal: 2026-07-03

[SG-008] Mass assignment exception — "Add [field] to fillable property"
Stack: Laravel / Eloquent
Kapan terjadi: Insert/update data tanpa whitelist di model
Workaround: Tambah properti `protected $fillable = ['name', 'email', ...]` di model. JANGAN gunakan `$guarded = []` di production.
Tanggal: 2026-07-03

[SG-009] `php artisan serve` pakai port 8000 — conflict dengan service lain
Stack: Laravel / Windows
Kapan terjadi: Port 8000 sudah dipakai service production lokal
Workaround: Selalu gunakan `php artisan serve --port=8080` (gemini.md Dev Port Blacklist). Tambahkan alias di composer.json scripts.
Tanggal: 2026-07-03

---

## Next.js / React

[SG-002] CORS Blocked & Pemuatan Lambat API Cuaca di Localhost
Stack: React / Vite / Open-Meteo API
Kapan terjadi: Memanggil API cuaca eksternal secara langsung dari dev server localhost di peramban web klien.
Workaround: Gunakan deteksi hostname `window.location.hostname === 'localhost'` atau `'127.0.0.1'`. Jika bernilai benar, bypass pemanggilan fetch jaringan dan langsung gunakan data cuaca fallback lokal secara instan (0 ms) agar konsol F12 bebas dari error CORS merah.
Tanggal: 2026-07-04

[SG-003] Error 404 pada Pemanggilan Gambar Statis /desa/upload/
Stack: React Theme Engine / OpenSID
Kapan terjadi: Merujuk berkas upload statis (seperti gambar artikel, galeri) menggunakan konstanta API_URL (menghasilkan path /api/desa/upload/...).
Workaround: Wajib gunakan konstanta BASE_URL (dari helper `getBaseUrl()`) karena berkas statis diunggah dilayani langsung di bawah root web server Apache tanpa sub-path `/api`.
Tanggal: 2026-07-04

[SG-010] `redirect()` di Next.js throw error saat dalam try-catch
Stack: Next.js 14+ App Router
Kapan terjadi: Memanggil `redirect()` dari `next/navigation` di dalam blok try-catch
Workaround: Pindahkan `redirect()` ke LUAR try-catch. Gunakan variabel flag `let success = false` → set true dalam try → redirect setelah catch block.
Tanggal: 2026-07-04

[SG-011] Server Component tidak bisa pakai onClick, useState, atau useEffect
Stack: Next.js 14+ App Router
Kapan terjadi: Menambahkan interaktivitas di file yang defaultnya Server Component
Workaround: Tambahkan `'use client'` di baris pertama file. Atau ekstrak bagian interaktif ke Client Component terpisah.
Tanggal: 2026-07-04

---

## CSS oklch()

[SG-012] oklch() tidak didukung Safari versi < 15.4
Stack: CSS / Safari
Kapan terjadi: User buka di Safari lama, warna tidak muncul (transparan)
Workaround: Tambahkan fallback hex di atas oklch(): `color: #1a1a2e; color: oklch(0.15 0.02 240);`
Referensi: https://caniuse.com/css-oklch
Tanggal: 2026-07-01

[SG-013] @property CSS custom property tidak animatable di Firefox < 128
Stack: CSS / Firefox
Kapan terjadi: Animasi CSS variable menggunakan `@property` tidak bekerja di Firefox lama
Workaround: Gunakan `transition: background 0.3s` (property standar) sebagai fallback, bukan `transition: --vibe-primary 0.3s`
Tanggal: 2026-07-02

[SG-014] color-mix() dan light-dark() belum widely supported
Stack: CSS 2026
Kapan terjadi: Fitur CSS modern terlalu baru untuk browser target audience
Workaround: Pre-compute warna di CSS variable. Gunakan `data-theme` attribute approach dari design-system.md §2 alih-alih `light-dark()`. Gunakan `filter: brightness()` alih-alih `color-mix()`.
Tanggal: 2026-07-03

[SG-015] api-v4/.gitignore lokal tidak melindungi .env — bisa ikut commit dari subfolder
Stack: Git / Bun / Node.js
Kapan terjadi: Developer menjalankan `git add .` dari DALAM folder api-v4/. File .env
               hanya ada di root .gitignore (sebagai *.env*), tapi tidak di api-v4/.gitignore
               sendiri — Git dari subfolder tidak membaca root .gitignore dengan cara yang sama
Workaround: SELALU isi api-v4/.gitignore secara EKSPLISIT dengan:
              .env
              .env.*
              *.local
              *.db
              *.sqlite
              dist/
            Jangan hanya mengandalkan root .gitignore saja untuk file rahasia di subfolder.
Tanggal: 2026-07-06

[SG-016] Rate limiter X-Forwarded-For bisa di-spoof jika tidak ada trusted reverse proxy
Stack: Hono / Bun rate limiter
Kapan terjadi: Aplikasi Bun diakses langsung ke port (misal 3000) tanpa Nginx/CloudPanel
               di depannya. Header X-Forwarded-For bisa diisi bebas oleh klien nakal untuk
               bypass rate limiting (brute force login, spam AI chat).
Workaround: Pastikan deployment production SELALU di belakang Nginx (CloudPanel).
            Dokumentasikan asumsi ini di komentar middleware agar tidak ada yang deploy
            langsung. Untuk environment lokal XAMPP, rate limiting bersifat advisory saja
            dan tidak menjadi garis pertahanan utama.
Tanggal: 2026-07-06
