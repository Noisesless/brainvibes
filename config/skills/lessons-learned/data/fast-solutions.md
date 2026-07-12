# Fast Solutions — Solusi Cepat untuk Masalah Berulang

*Solusi yang sudah terbukti bekerja — langsung pakai tanpa trial and error.*

---

## Format Entry

```
[FS-NNN] [Nama masalah]
Stack: [framework/OS]
Gejala: [error message atau behavior yang terlihat]
Solusi: [langkah konkret yang berhasil]
Waktu resolusi: [estimasi menit/jam]
Tanggal: [YYYY-MM-DD]
```

---

## Daftar Fast Solutions

[FS-001] Port sudah digunakan proses lain di Windows
Stack: Vite / Next.js / Laravel / Windows
Gejala: Error "EADDRINUSE: address already in use" atau "port is already in use"
Solusi: `netstat -ano | findstr :[PORT]` → `taskkill /PID [nomor] /F`. Jika Access Denied, increment port +1 dan update .env
Waktu resolusi: 2 menit
Tanggal: 2026-07-01

[FS-002] Widget Galeri Kosong Akibat Eager-Load API Terbatas
Stack: React / REST API Galeri
Gejala: Widget galeri di sidebar hanya menampilkan gambar fallback monokrom kosong karena sub-array `images` tidak di-load secara eager oleh API.
Solusi: Tambahkan logika fallback pembacaan properti `cover` folder galeri langsung dari database jika array `images` bernilai kosong atau tidak terdefinisi.
Waktu resolusi: 10 menit
Tanggal: 2026-07-04

[FS-003] CSS/JS tidak load di sub-folder XAMPP
Stack: PHP Native / XAMPP / Windows
Gejala: Halaman muncul tanpa styling. Console: 404 untuk CSS/JS files
Solusi: Ganti absolute path `/assets/` menjadi dynamic base URL via helper `baseUrl('assets/css/style.css')`. Lihat pattern PHP Native.
Waktu resolusi: 5 menit
Tanggal: 2026-07-01

[FS-004] Hydration Mismatch di Next.js karena localStorage
Stack: Next.js / React
Gejala: "Hydration failed because the initial UI does not match"
Solusi: Wrap komponen yang akses localStorage dalam `useEffect` + `mounted` state check. Render skeleton sampai mounted.
Waktu resolusi: 5 menit
Tanggal: 2026-07-02

[FS-005] CORS Error saat fetch API dari frontend ke backend lokal
Stack: React / PHP / Node.js
Gejala: "Access-Control-Allow-Origin" error di browser console
Solusi: PHP: tambah header CORS + handle OPTIONS preflight. Node: gunakan cors middleware. Next.js: API routes otomatis same-origin.
Waktu resolusi: 3 menit
Tanggal: 2026-07-02

[FS-006] Session hilang setelah login di PHP
Stack: PHP Native / XAMPP
Gejala: Login sukses tapi redirect balik ke login. Session tidak persist.
Solusi: Pastikan `session_start()` di baris paling atas SEBELUM output apapun. Cek `session.save_path` di php.ini mengarah ke folder writable.
Waktu resolusi: 5 menit
Tanggal: 2026-07-02

[FS-007] Gambar CDN (Unsplash) blocked / 403
Stack: Semua web / HTTP
Gejala: Gambar dari Unsplash/Picsum return 403 Forbidden atau blank
Solusi: Gunakan Stealth Fetch Engine headers (gemini.md §4G). Tambahkan onerror fallback ke placeholder lokal.
Waktu resolusi: 5 menit
Tanggal: 2026-07-03

[FS-008] "Module not found: Can't resolve 'fs'" di Next.js
Stack: Next.js / React
Gejala: Build error saat import Node.js module di client component
Solusi: Pindahkan kode `fs`/`path`/`crypto` ke Server Component, API Route, atau Server Action. FORBIDDEN di Client Component.
Waktu resolusi: 3 menit
Tanggal: 2026-07-03

[FS-009] Karakter Indonesia rusak (???) di database/halaman
Stack: PHP / MySQL / XAMPP
Gejala: Teks Indonesia muncul sebagai tanda tanya atau kotak
Solusi: Set charset UTF8MB4 di 3 tempat: koneksi DB (`set_charset('utf8mb4')`), HTML (`<meta charset="UTF-8">`), tabel MySQL (`CONVERT TO utf8mb4_unicode_ci`)
Waktu resolusi: 5 menit
Tanggal: 2026-07-03

[FS-010] oklch() warna tidak muncul di Safari lama
Stack: CSS / Safari < 15.4
Gejala: Background/text transparan di Safari versi lama
Solusi: Tambahkan fallback hex SEBELUM oklch(): `background: #1E293B; background: oklch(20% 0.03 250);`
Waktu resolusi: 2 menit
Tanggal: 2026-07-04

[FS-011] .htaccess tidak berfungsi di XAMPP
Stack: PHP / Apache / XAMPP
Gejala: URL rewriting tidak bekerja, direct access ke file.php required
Solusi: Uncomment `LoadModule rewrite_module` di httpd.conf + set `AllowOverride All` untuk directory htdocs
Waktu resolusi: 3 menit
Tanggal: 2026-07-04

[FS-012] Next.js Image component — hostname not configured
Stack: Next.js
Gejala: "Invalid src prop, hostname not configured under images in next.config"
Solusi: Tambahkan domain ke `images.remotePatterns` di `next.config.js` (protocol + hostname)
Waktu resolusi: 2 menit
Tanggal: 2026-07-04
