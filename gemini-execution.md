# AI CODING AGENT — DETAILED EXECUTION INSTRUCTIONS (VIBES CODING WORKFLOW V4.0)
*[Split Architecture: gemini-execution.md — dimuat AI via view_file saat eksekusi koding aktif]*

---

## §3. ATURAN INTERAKSI & KECERDASAN (BEHAVIOR V2)

### A. Validasi Instruksi & Sinkronisasi Otomatis (Context-Awareness)

-1. **User Preferences Load (HIGHEST PRIORITY — Silent — Setiap Sesi):**
    SEBELUM apapun, AI REQUIRED baca `%USERPROFILE%\.gemini\user-prefs.md` secara senyap:
    - Ambil `[DEVELOPMENT]` → gunakan sebagai default port, package manager, db engine
    - Ambil `[DESIGN_DEFAULTS]` → gunakan sebagai fallback jika user tidak memilih font/palet/geometry
    - Ambil `[AI_BEHAVIOR].context7_whitelist` → aktifkan auto-trigger context7 untuk library ini
    - Ambil `[AI_BEHAVIOR].taste_skill_auto` → jika `true`, aktifkan taste-skill-bridge auto-trigger
    - Ambil `[AI_BEHAVIOR].uupm_auto_run` → jika `true`, jalankan UUPM Step 1 saat awal baru & redesign
    - Ambil `[SESSION_PROTOCOL].handover_trigger` → gunakan sebagai threshold handover update
    File ini FORBIDDEN dimodifikasi AI tanpa instruksi eksplisit user.

0.  **Auto Workspace Verification (Silent — Setiap Sesi Baru):**
    Setelah user-prefs.md dibaca, scan working directory:
    - `app-context.md` ADA → gunakan sebagai primary context, proyek aktif terdeteksi
    - `app-context.md` TIDAK ADA tapi `prd.md` ADA → proyek aktif tanpa snapshot, fallback normal
    - `prd.md` TIDAK ADA dan tidak ada saklar `awal baru` → STOP dan lapor:
      `[WORKSPACE] Tidak ditemukan prd.md di direktori ini. Apakah ini proyek baru (ketik 'awal baru') atau Anda ingin pindah direktori?`
    - **Auto-Ignore Legacy Folder:** AI **REQUIRED** secara otomatis mengecualikan dan mengabaikan folder `/.legacy/` dari pemindaian filesystem global (seperti `search_files`, `grep_search`, atau `list_dir`) untuk menghemat token dan mencegah lag pembacaan, kecuali diinstruksikan secara eksplisit oleh user.
    FORBIDDEN berasumsi konteks proyek dari memori training AI.

1.  **Deteksi Konflik:** Setiap kali user memberikan instruksi baru (misal: "tambah halaman baru"), AI WAJIB membandingkannya dengan `prd.md` dan `todo.md` yang ada.
2.  **Gerbang Konfirmasi Cerdas:** Jika instruksi tersebut adalah fitur baru atau bertentangan dengan rencana, AI tidak boleh langsung eksekusi. AI harus bertanya:
    > *"Instruksi Anda untuk membuat halaman 'X' merupakan fitur baru yang belum ada di `prd.md`. Apakah Anda ingin saya memperbarui `prd.md` dan `todo.md` untuk memasukkan tugas ini secara resmi?"*
3.  **Sinkronisasi Wajib:** Setelah user setuju, AI WAJIB memperbarui `prd.md` dan/atau `todo.md` **sebelum** atau **dalam giliran yang sama** saat menulis kode fitur tersebut. Ini memastikan dokumentasi selalu sinkron dengan kenyataan.

### B. Protokol Eksekusi & Uji Coba (Fail-Fast Workflow)
1.  **Verifikasi Pre-Task:** Sebelum mengerjakan tugas di `todo.md`, baca ulang spesifikasi relevan di `prd.md`.
2.  **Pre-flight Check:** Sebelum menjalankan proses `build` penuh yang lambat, AI WAJIB menjalankan perintah cepat:
    *   **Linter & Formatter Check** (`eslint`, `prettier --check`, `pint`, dll.)
    *   **Type Checker** (`tsc --noEmit`, dll.)
    AI harus memperbaiki error dari *pre-flight check* ini terlebih dahulu.
3.  **Build Penuh & 6 Lapisan Scan:** Hanya jika *pre-flight check* lolos, AI menjalankan `build` penuh dan 6 lapisan scan keamanan.
4.  **Gerbang Kelulusan Taktis (Fail-Fast):** Jika ada error di tahap manapun, proses dihentikan, checkbox `todo.md` tidak dicentang, dan AI langsung masuk mode perbaikan.
5.  **Self-Reflection Gate (Sebelum Serah ke User):**
    Sebelum menyatakan task selesai, AI REQUIRED melakukan self-check cepat:
    - Apakah semua file yang disebut task sudah dibuat/diubah di disk?
    - Apakah ada `href="#"` atau link mati yang baru dibuat? (Fix sesuai §4A Active Link Policy)
    - Apakah token warna dipakai dari CSS variable, bukan hex hardcode? (Refactor ke `var(--vibe-*)`)
    - Apakah ada kode terpotong atau disingkat `// ... rest`? (Tulis lengkap sesuai §1 No-Truncation Law)
    - Apakah `app-context.md` sudah diupdate jika ini task ke-5/6?
    Format output (COMPACT): `[SELF-CHECK] ✅ Files: N | ✅ Links: OK | ✅ Tokens: CSS var`
    Jika ada item FAILED: perbaiki dulu SEBELUM menyatakan selesai.

### C. Definisi 6 Lapisan Scan Kelayakan Keamanan (Security Gate Protocol)
AI REQUIRED mengeksekusi keenam lapisan berikut secara berurutan. Lapisan tidak boleh dilewati. Jika satu lapisan gagal, proses dihentikan.

| Lapisan | Nama | Perintah Konkret | Lulus Jika |
|---|---|---|---|
| **L1** | Linter & Formatter | `npx eslint . --max-warnings=0` / `npx prettier --check .` / `./vendor/bin/pint --test` | Zero warnings, zero errors |
| **L2** | Type Safety | `npx tsc --noEmit` / `npx tsc --noEmit --strict` | Zero type errors |
| **L3** | SAST (Static Analysis) | Audit celah keamanan. Jika AST linter terinstall (e.g. `eslint-plugin-security` / `phpstan`), prioritaskan verifikasi via linter tersebut. Fallback: grep manual untuk pola berbahaya: `eval(`, `innerHTML =`, `dangerouslySetInnerHTML`, `exec(`, `system(`, query tanpa prepared statement | Zero pola berbahaya / scan clean |
| **L4** | Form Input Validation Guard | Baca setiap file form/endpoint — pastikan ada: validasi panjang input, sanitasi string, rate-limiting pada endpoint login | Semua form & endpoint tervalidasi |
| **L5** | Auth Integrity Verification | Cek setiap protected route — pastikan middleware/guard aktif, token/session diperiksa, tidak ada bypass `if(true)` | Semua route terproteksi |
| **L6** | Security Headers Check | Cek middleware/response header handler — pastikan minimal ada: `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `X-Frame-Options: SAMEORIGIN`, `Referrer-Policy`. Untuk HTTPS: `Strict-Transport-Security` | Semua 4 header wajib ada |

**Output Wajib Setelah Scan:**
```
Status 6 Lapisan Scan:
  L1 Linter         : PASSED / FAILED ([jumlah error])
  L2 Type Safety    : PASSED / FAILED ([jumlah error])
  L3 SAST           : CLEAN / RISK ([pola berbahaya yang ditemukan])
  L4 Input Guard    : SECURED / EXPOSED ([form yang belum tervalidasi])
  L5 Auth           : VERIFIED / BROKEN ([route yang bypass])
  L6 Sec Headers    : COMPLETE / MISSING ([header yang tidak ada])
```

---

## §4. ATURAN PENULISAN KODE, ARSITEKTUR, & ACTIVE LINK POLICY

### A. Arsitektur Kode, ACID Transaksi, & Kebijakan Tautan Aktif (Structural Integrity)
- **Anti-Spaghetti & Strict Layer Separation:** AI REQUIRED memecah kode secara modular. Pisahkan secara ketat antara Presentation Layer (UI Components / Views), Business Logic Layer (Controllers / Hooks), dan Data Access Layer (Models / Queries).
- **Database Transaction Guarding (ACID Compliance):** Untuk mutasi data sensitif (stok, saldo, poin) dan mutasi data multi-tabel, AI **REQUIRED** membungkus rangkaian eksekusi query tersebut di dalam blok transaksi terisolasi secara rigid. Wajib menggunakan perintah `DB::beginTransaction();`, `DB::commit();`, dan `DB::rollBack();` di dalam `catch` block.
- **Active Navigation & Zero-Dead-End Link Policy:** AI FORBIDDEN membuat tautan mati (`href="#"` atau `href="javascript:void(0)"`). Semua menu, link sidebar, dan tombol navigasi REQUIRED memiliki file fisik halaman penampung yang aktif terhubung ke routing. Jika belum dibangun, arahkan ke halaman temporary dengan "Under Construction Card".
- **Dynamic Authentication State & Avatar Navbar Layout:** Komponen Navbar/Sidebar tidak boleh bersifat statis:
  1. *Guest State (Belum Login):* Hanya memunculkan tombol "Login" atau "Mulai". Menyembunyikan Admin/Member panel.
  2. *Logged In State:* Tombol login bertukar menjadi komponen **Avatar Lingkaran Foto Profil / Gambar User** (`rounded-full`). Klik avatar memicu dropdown menu berisi tautan Profil, Settings, dan Logout.
  3. *Admin State:* Muncul menu tambahan "Admin Panel" / "User Management" di dropdown avatar atau navigasi.
- **Dynamic Application Identity:** AI FORBIDDEN menuliskan nama aplikasi, copyright footer, dan logo secara statis (*hardcode*). Tarik secara dinamis dari config atau DB settings.

### B. Regulasi Keamanan Captcha Anti-Bot & Form Publik
Untuk Formulir Login, Registrasi, atau Formulir Input Publik:
1. *Visual High-Contrast Engine:* Angka/huruf Captcha REQUIRED di-render dengan warna tegas bersaturasi tinggi di atas latar belakang kontras. FORBIDDEN warna buram, grey layer, atau hitam-putih.
2. *Alphanumeric Case-Insensitive Logic:* Kombinasi dinamis angka, huruf besar, dan huruf kecil (e.g. `pG4mQ`). Backend validation REQUIRED bersifat **Case-Insensitive** (`strtolower()` / `.toLowerCase()`).
3. *Mandatory Refresh Control:* Sediakan tombol/ikon refresh interaktif untuk menghasilkan captcha baru tanpa reload halaman.
4. *State Destruction on Failure:* Jika validasi gagal, session captcha lama REQUIRED dihancurkan otomatis dan diganti dengan yang baru.
5. *Protokol Aksesibilitas Captcha (A11Y Conflict Resolution):* Jika Captcha aktif DAN A11Y Gate aktif, pilih strategi:
   - **Honeypot:** Hidden input field + timing validation (Default: zero friction, no library).
   - **Audio Captcha:** Tombol speaker → bacakan kode via Web Speech API.
   - **reCAPTCHA v3:** Jika diizinkan policy proyek.

### C. Arsitektur Peran File Sistem Vibes Coding (Single Responsibility Rule)
- `gemini.md` (Otak / OS) → Hukum universal di SEMUA proyek, SEMUA sesi.
- `prd-template.md` (Form Spesifikasi) → Data keputusan per-proyek dari wawancara.
- `design-system.md` (Database Visual) → Referensi token warna & komponen, dibaca ON-DEMAND.
**Hukum Duplikasi:** AI FORBIDDEN mengulangi aturan perilaku dari `gemini.md` ke dalam `prd.md`. `prd.md` HANYA boleh berisi data/pilihan spesifik proyek dan referensi silang (`→ BACA gemini.md §X`).

### D. Protokol Anti-Blank & Sistem Imun Visual DNA (Anti-Invisible Text Policy)
1. **Hukum Kontras Mutlak (Anti-Text Gaib):**
   - AI FORBIDDEN menerapkan kombinasi warna font yang memiliki tingkat kontras rendah dengan latar belakang komponen (e.g., `font putih + bg putih`).
   - Setiap card/surface/modal cerah/putih, warna teks utama (`text-main`) REQUIRED cocok dengan skala gelap (e.g., Slate-900 / Charcoal).
2. **Hukum Implementasi Tipografi Baku & Font Injeksi:**
   - AI REQUIRED menyuntikkan tautan pustaka font resmi (Google Fonts) pada tag `<head>` layout utama.
   - Fallback Font Stack: sertakan fallback stack lengkap (Inter/Playfair/Roboto + system-ui) agar teks tidak hilang jika CDN gagal.
3. **Hukum Pengadaan Media Visual Terintegrasi (Anti-Halaman Kosong):**
   - AI REQUIRED menyematkan URL gambar HD yang aktif dan kontekstual langsung dari CDN Unsplash/Picsum.
   - Seluruh tag `<img>` REQUIRED memiliki `object-cover` dan rasio aspek yang rigid agar tidak distorsi.
4. **Hukum Anti-Mati Rasa Vibrant Mode:** Jika palet "Vibrant / Streetwear" terpilih, AI FORBIDDEN menggunakan background `#ffffff` murni secara dominan. Gunakan Slate Gelap/Charcoal sebagai base dengan aksen KTM Orange atau Kawasaki Green.
5. **Hukum Preservasi Tonal & Anti-Banjir Putih-Hitam Murni:**
   - AI FORBIDDEN mengartikan Light Mode sebagai putih murni (`#FFF`) dan Dark Mode sebagai hitam murni (`#000`) hambar.
   - Light Mode: `--vibe-background` REQUIRED mewarisi `--raw-palette-bg`.
   - Dark Mode: `--vibe-background` REQUIRED dirumuskan dari rona dasar palet asli yang diturunkan kecerahannya (Midnight Shade).

### E. Regulasi Keamanan & Optimasi Upload File (Secure Upload Pipeline)

> ⛔ **HARD BLOCK:** AI **FORBIDDEN** menyimpan file upload dengan nama asli dari user. Pelanggaran = **Fatal Security Violation**.

#### Tahap 1 — Validasi & Keamanan Sebelum Proses (Pre-Upload Gate)
- Maksimal file size: 10MB.
- `ALLOWED_IMAGE_TYPES` = `['image/jpeg', 'image/png', 'image/webp', 'image/gif']`.
- ❌ **FORBIDDEN: SVG upload** (XSS risk).
- Validasi MIME type wajib dari Magic Bytes (bukan dari ekstensi nama file).

#### Tahap 2 — Penamaan File Aman (App-Slug + UUID)
- Nama file REQUIRED format: `[app-slug]_[konteks]_[uuid-8char]_[timestamp].webp`
- `app-slug` didefinisikan di `.env` (di-generate dari PRD).

#### Tahap 3 — Strip EXIF Metadata
- REQUIRED: Hapus metadata EXIF sebelum disimpan ke disk (gps data, device, dll.) menggunakan Sharp (Node.js) atau `orientate()` (PHP/Laravel).

#### Tahap 4 — Multi-Size Output & WebP Compression
- REQUIRED: Setiap upload gambar menghasilkan MINIMAL 2 varian ukuran:
  - `avatar`: thumb (80x80), medium (200x200)
  - `cover`: mobile (640w), desktop (1280w)
  - `content`: thumb (300w), medium (800w), large (1200w)
- Format output: WebP. Simpan paths ke JSON column di database.

#### Tahap 5 — Context-Aware Image Serving & Responsive srcset
- Gunakan `<img srcset="...">` dengan memanggil preset ukuran yang tepat.

---

### G. Protokol Human-Like HTTP Request (Stealth Fetch Engine)
Setiap HTTP request ke server eksternal REQUIRED menggunakan teknik kamuflase:

1. **Hukum Header Manusia:** AI **FORBIDDEN** menggunakan header default fetch/axios. Gunakan header lengkap (`User-Agent` Chrome/Windows terbaru, `Accept-Language`, `Sec-Ch-Ua`, dll.).
2. **Hukum Referer Kontekstual:** Tambahkan referer & origin yang valid.
3. **Hukum Delay Acak:** Jeda delay acak (0.5 - 2 detik) antar request.
4. **Hukum Retry Cerdas:** Exponential backoff + User-Agent rotation jika menerima status 429/403.
5. **Hukum Fallback Lokal:** Setiap `<img>` eksternal wajib punya `onerror` fallback ke placeholder lokal.
6. **Hukum Aset SVG Lokal:** Logo brand & ikon utama wajib diunduh manual dan disimpan secara lokal (fill/stroke via oklch).

---

### G-bis. Modern CSS Enforcement Gate (CSS 2026)
AI REQUIRED menggunakan fitur CSS modern berikut dengan fallback yang sesuai:

- **Container Queries (`@container`):** Reusable components.
- **`:has()` Selector:** State parent berdasarkan child (form validation, dimming).
- **`text-wrap: balance`:** Heading (`h1`-`h3`).
- **`text-wrap: pretty`:** Paragraph (`p`, `li`).
- **`color-mix(in oklch)`:** Hover effects.
- **`dvh` / `svh` / `lvh`:** Menggantikan `100vh` untuk full height layout.

---

### G-ter. BROWSER TOOL GATE — Token Anti-Waste Protocol

> ⛔ **HARD BLOCK:** AI **FORBIDDEN** memanggil `browser_subagent` tanpa memenuhi MINIMAL SATU dari kondisi di bawah. Pelanggaran = **Token Waste Violation**.

#### Decision Tree (Wajib Dijalankan Sebelum Pakai Browser Tool):

```
Perlu cek/baca konten web?
├── Butuh klik / interaksi UI (form, scroll, drag)?  → browser_subagent ✅
├── Butuh JavaScript rendering / SPA content?        → browser_subagent ✅
├── Butuh login UI (session/cookie browser)?         → browser_subagent ✅
├── User eksplisit minta recording/video demo?       → browser_subagent ✅
└── SISANYA (konten statis, HTML publik, API, docs): → read_url_content ✅
```

#### Tabel Substitusi Tool (DEFAULT):

| Skenario | ❌ FORBIDDEN (Boros) | ✅ REQUIRED (Hemat) | Penghematan |
|---|---|---|---|
| Cek halaman web publik | `browser_subagent` ~30K token | `read_url_content` ~1K token | **97%** |
| Ambil dokumentasi library | `search_web` + browser | `context7` MCP | **60%** |
| Baca HTML/JSON dari URL | `browser_subagent` | `read_url_content` | **97%** |
| Baca file lokal besar | `view_file` tanpa range | `view_file` + `StartLine`/`EndLine` | **75%** |
| Verifikasi build lokal | browser scratchpad DOM | `read_url_content` ke localhost | **90%** |

#### Token Guard — Per Turn Enforcement:

```
AI WAJIB per giliran:
- max 5 file dibuka (dari user-prefs.md: max_files_per_turn = 5)
- max 200 baris per view_file (dari user-prefs.md: max_lines_per_read = 200)
- FORBIDDEN baca file >100 baris tanpa StartLine/EndLine
- FORBIDDEN memanggil browser_subagent hanya untuk "cek DOM"
- FORBIDDEN memanggil browser_subagent untuk scratchpad debug
- DEFAULT recording = OFF kecuali user eksplisit minta
```

#### Pelanggaran & Konsekuensi:

```
Jika AI ingin pakai browser_subagent → wajib justifikasi 1 baris:
[Browser Gate] Alasan: [salah satu dari 4 kondisi di atas] → Proceed ✅
Jika tidak ada alasan valid → fallback ke read_url_content WAJIB.
```

---

## §4K. UI UX PRO MAX INTEGRATION PROTOCOL (SUMMARY)
*Detail implementasi lengkap dapat dibaca di folder skill: `skills/ui-ux-pro-max/SKILL.md` dan `taste-skill-bridge/SKILL.md`.*

### A. UUPM Pipeline Eksekusi
```
Input User → [UUPM Search] → [design-system.md Token Mapping] → [context7 Verify] → Output Kode
```
1. **Python Check:** Jalankan `python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "[deskripsi]"` secara senyap. Jika python tidak ada, fallback ke `design-system.md` kluster langsung.
2. **oklch() Mapping:** Hex hasil rekomendasi UUPM dikonversi ke oklch() dan dipetakan ke token `--raw-palette-*`.
3. **Component Pattern Query:** Query database stack-specific CSV (Laravel, Next.js, React) saat membuat komponen di Fase 3-5.

---

## §4L. SEO PRODUCTION PROTOCOL (SUMMARY)
*Checklist SEO 20-item tersedia inline di bawah. Jalankan penuh di Fase 8 / deploy prep.*

### A. 7 Lapisan SEO Wajib
- **L1 (Meta Core):** `<title>` unik (50-60 char), `<meta name="description">` unik (150-160 char), `<link rel="canonical">`.
- **L2 (Open Graph):** type, title, description, url, og:image (1200x630px WebP, <1MB, ada logo + tagline).
- **L3 (Twitter Card):** summary_large_image, title, description, image.
- **L4 (Structured Data):** JSON-LD Organization (semua proyek), WebSite (homepage), BreadcrumbList (pages), Article (blog).
- **L5 (robots.txt):** Blokir private routes (`/admin/`, `/api/`, `/dashboard/`).
- **L6 (sitemap.xml):** Static/dynamic sitemap.
- **L7 (Core Web Vitals):** LCP ≤ 2.5s, CLS ≤ 0.1, INP ≤ 200ms.
