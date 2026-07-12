# Anti-Patterns — Pattern yang TERBUKTI GAGAL

*Jangan coba pendekatan ini lagi. Diisi dari /learn history dan retrospectives.*

---

## Format Entry

```
[AP-NNN] [Deskripsi pendekatan yang gagal]
Stack: [framework/OS yang terdampak]
Gejala: [apa yang terjadi saat mencobanya]
Solusi benar: [apa yang seharusnya dilakukan]
Tanggal: [YYYY-MM-DD]
```

---

## Daftar Anti-Patterns

[AP-001] Menggunakan `migrate:fresh` saat debug database di proyek aktif
Stack: Laravel / PHP
Gejala: Seluruh data production/development terhapus tanpa bisa dikembalikan
Solusi benar: Gunakan `migrate --force` atau buat migration baru inkremental
Tanggal: 2026-07-01

[AP-002] Hardcode warna hex langsung di komponen HTML/JSX
Stack: Semua stack
Gejala: Warna tidak konsisten antar halaman, tidak ikut dark mode, sulit maintenance
Solusi benar: Selalu gunakan CSS variable `var(--vibe-*)` dari token system
Tanggal: 2026-07-01

[AP-003] Menggunakan `git add .` tanpa cek .gitignore terlebih dahulu
Stack: Semua stack / Git
Gejala: File .env, database.sqlite, handover.md, prd.md masuk ke commit → credential leak
Solusi benar: Ikuti 5 Tahap Commit Protocol (gemini.md §6A) — pastikan .gitignore ada dulu
Tanggal: 2026-07-01

[AP-004] Menyimpan file upload dengan nama asli user
Stack: PHP / Node.js / Semua backend
Gejala: Path traversal attack, file overwrite, nama file spesial merusak filesystem
Solusi benar: UUID + APP_SLUG + timestamp (gemini.md §4E Tahap 2)
Tanggal: 2026-07-02

[AP-005] Menggunakan `eval()`, `innerHTML =`, atau `dangerouslySetInnerHTML` tanpa sanitasi
Stack: JavaScript / React / PHP
Gejala: XSS vulnerability — attacker bisa inject script via input form
Solusi benar: Gunakan textContent, DOM API, atau DOMPurify library
Tanggal: 2026-07-02

[AP-006] Debug dengan menambahkan file test.js / dump.sql di folder src/ atau app/
Stack: Semua stack
Gejala: File debug masuk ke production build, mengotori codebase
Solusi benar: SELALU gunakan folder /.scratchpad/ untuk file debug (gemini.md §5A)
Tanggal: 2026-07-02

[AP-007] Mencoba fix error yang sama lebih dari 3x dengan pendekatan identik
Stack: Semua stack
Gejala: Loop tak berujung, waktu terbuang, frustasi — error tetap ada
Solusi benar: Setelah 3x gagal → rollback git, catat di issues.md, coba pendekatan berbeda
Tanggal: 2026-07-02

[AP-008] Menggunakan `alert()` untuk notifikasi user di web app
Stack: JavaScript / Semua frontend
Gejala: UX buruk, blocking execution, tidak bisa dikustomisasi, terlihat amatir
Solusi benar: Toast notification component dengan auto-dismiss 3 detik
Tanggal: 2026-07-03

[AP-009] Menggunakan `font-family` default browser tanpa deklarasi eksplisit
Stack: CSS / Semua web
Gejala: Tampilan berbeda di tiap browser/OS — Times New Roman di beberapa browser
Solusi benar: Inject Google Fonts CDN + deklarasi CSS global font-family dengan fallback stack
Tanggal: 2026-07-03

[AP-010] Menjalankan dev server di port 3000 atau 8000
Stack: Next.js / Laravel / Node.js
Gejala: Port conflict dengan service production yang sudah berjalan di mesin lokal
Solusi benar: Next.js = 3100, Laravel = 8080, Vite = 5173 (gemini.md §1 Dev Port Blacklist)
Tanggal: 2026-07-03

[AP-011] Update semua dependencies (`npm update` / `composer update`) saat debug
Stack: Node.js / PHP / Semua
Gejala: Breaking changes di library lain yang tidak terkait bug — 1 bug jadi 10 bug
Solusi benar: Hanya update library yang SPESIFIK terkait bug (Anti-Blind Dependency)
Tanggal: 2026-07-04

[AP-012] Menggunakan dynamic class concatenation di Tailwind CSS
Stack: Tailwind CSS / React / Next.js
Gejala: Class `bg-${color}-500` tidak ter-generate di production build (purge/JIT tidak detect)
Solusi benar: Tulis full class strings: `isActive ? 'bg-green-500' : 'bg-red-500'`
Tanggal: 2026-07-04

[AP-013] Hanya melindungi sebagian endpoint dalam 1 controller (partial authMiddleware)
Stack: Hono / Bun / Node.js API
Gejala: Beberapa endpoint (misalnya /settings, /analisis-wilayah) dilindungi authMiddleware,
        tapi endpoint lain di file yang SAMA (/analisis-keuangan, /analisis-demografi-makro)
        dibiarkan publik — mengekspos data internal sensitif (APBDes, demografi warga)
Solusi benar: Selalu terapkan authMiddleware per-endpoint SECARA EKSPLISIT dengan
              app.use('/endpoint-name', authMiddleware), atau gunakan app.use('*', authMiddleware)
              untuk melindungi seluruh router sekaligus. Jangan asumsikan "endpoint di bawahnya
              otomatis terlindungi" hanya karena endpoint lain di atasnya sudah diproteksi.
Tanggal: 2026-07-06

[AP-014] Mengandalkan parent-level protection tanpa explicit authMiddleware di handler
Stack: Hono / Express / semua API framework
Gejala: Komentar "protected by admin authMiddleware at parent level" ternyata tidak diverifikasi
        secara kode — jika routing berubah atau endpoint dipindah, proteksi hilang secara
        diam-diam (silent regression)
Solusi benar: Defense-in-depth — SELALU tambahkan authMiddleware langsung di handler atau
              router-level yang bersangkutan. Jangan bergantung pada perlindungan dari level
              routing yang berbeda yang tidak tampak di file yang sama.
Tanggal: 2026-07-06

[AP-015] Validasi file upload hanya dari ekstensi nama file (file extension spoofing)
Stack: Node.js / Bun / Hono — semua upload endpoint
Gejala: Penyerang mengganti nama file berbahaya (shell.php → shell.jpg), lolos validasi
        ekstensi, berpotensi dieksekusi di server (Remote Code Execution / file upload attack)
Solusi benar: WAJIB cek magic bytes (binary signature) dari buffer biner file — BUKAN dari
              nama file, ekstensi, atau header Content-Type yang bisa dipalsukan klien.
              Ekstrak ke shared utility (validateImageMagicBytes) dan terapkan di SEMUA
              titik upload: CMS artikel, foto penduduk, pengaduan, lapak, gallery, dll.
              Referensi pattern: api-v4/src/core/utils/validate-image-magic.ts (DIGITARA)
Tanggal: 2026-07-06
