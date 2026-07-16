# AI CODING AGENT — MACRO COMMANDS & TEMPLATES (VIBES CODING WORKFLOW V4.0)
*[Split Architecture: gemini-templates.md — dimuat AI via view_file hanya saat saklar aktif / butuh template]*

---

## §2. MACRO COMMANDS EXECUTION DETAILS

### 2A. Saklar: `awal baru`
1. Mulai wawancara terstruktur 10 poin utama + 2 poin tambahan (M1, M2) dari `prd-template.md`. Tanyakan satu per satu.
2. **Kecerdasan Desain:** Setelah user mendeskripsikan proyek, AI memberikan rekomendasi palet warna kontekstual (dari UUPM `colors.csv` atau 15 kluster `design-system.md §1`) sebelum menampilkan semua opsi.
3. **AI Stack Intelligence Gate:** Sebelum `prd.md` dikunci, AI menganalisis kompleksitas proyek secara mandiri dan memberikan rekomendasi stack tambahan (e.g. Python+FastAPI, Redis+BullMQ, WebSocket, Elasticsearch, dll) menggunakan format:
   ```
   [STACK INTELLIGENCE] Berdasarkan analisis kebutuhan proyek:
   Sinyal terdeteksi : [daftar sinyal]
   Rekomendasi       : [stack tambahan]
   Alasan teknis     : [penjelasan singkat]
   Implikasi budget  : [estimasi kompleksitas tambahan dalam fase]
   Konfirmasi        : Apakah Anda ingin mengadopsi rekomendasi ini? (Ya/Tidak/Sebagian)
   ```
4. **Scope Warning Gate:** Jika estimasi >20 halaman atau >15 fitur, berikan peringatan untuk membagi milestone.
5. **Knowledge Priming (Silent):** Scan `%USERPROFILE%\.gemini\antigravity-ide\knowledge\` (`project-retrospectives`, `error-solutions`, `vibes-stack-patterns`) untuk pre-populate `todo.md` lebih presisi.
6. Generate `prd.md` dan `todo.md` (8 Fase), lalu mulai eksekusi Fase 1.

### 2B. Saklar: `awal lanjut`
1. **Baca `app-context.md` PERTAMA (Silent - Priority Context).** Fallback jika tidak ada: baca `prd.md`, `todo.md`, `handover.md`, dan `/.docs/`.
2. **Analisis Kesenjangan & Konsistensi (Wawancara Kondisional):**
   - Checksum CORE IDENTITY LOCK: Bandingkan stack di `prd.md` dengan file manifest dependensi (`package.json`, `composer.json`, dll.).
   - Visual DNA Checksum (Auto-Sync): Bandingkan `app-context.md §PALETTE` dengan CORE IDENTITY LOCK di `prd.md`. Jika drift, update `app-context.md §PALETTE` sesuai `prd.md` lalu overwrite `app-context.md`.
3. Tampilkan ringkasan status dalam Bahasa Indonesia dan tunggu instruksi.

### 2C. Saklar: `awal konversi`
1. **Legacy System Audit (WAJIB):** Scan folder proyek lama secara senyap dan buat `/.docs/legacy-audit.md` (Peta Routes, Controller Inventory, Model Inventory, View Inventory, Database Schema DDL, API Endpoints, Webhooks, Third-Party, Upload Dirs, Active Pages Map). Tampilkan ringkasan dan minta konfirmasi.
2. **Wawancara Stack Baru (7 Poin):** P1 (Stack target), P2 (DB target), P3 (Migrasi data?), P4 (Redesign/tetap?), P5 (Fitur prioritas MVP), P6 (API/Webhook backward compatibility?), P7 (Target waktu).
3. **Database Compatibility Matrix:** Petakan skema tabel lama vs baru di `prd.md §6D` (merujuk `legacy-audit.md §5`).
4. **Generate `prd.md` + `todo.md` (9 Fase Mode Konversi):** Fase 1-3 setup baru, Fase 4-6 migrasi fitur, Fase 7-8 data migration & testing, Fase 9 legacy purge.
5. **Protokol Strangler Fig:** Sistem lama tetap berjalan selama konversi. Dilarang mematikan sistem lama sebelum versi baru lolos verifikasi 5 Lapisan Scan.
6. **Legacy Purge Gate (Fase 9):** Hapus folder `/.legacy/` hanya setelah dry-run log dan persetujuan tertulis user.

### 2D. Saklar: `tambah fitur`
1. Baca `prd.md §2` + `app-context.md §NEXT` secara senyap.
2. Cek konflik terhadap CORE IDENTITY LOCK atau fitur eksisting.
2a. **Dependency Impact Check:** Cek `/.docs/dependency-graph.md §🔴 Critical Files`.
    Jika file target ada di daftar Critical Files → tambahkan peringatan dampak ke gerbang konfirmasi:
    ```
    ⚠️ [DEP-IMPACT] File [nama] adalah Critical File (diimport oleh [N] modul).
       Perubahan ini berisiko tinggi. Pastikan test regression setelah edit.
    ```
3. Cetak gerbang konfirmasi cerdas:
   ```
   [TAMBAH FITUR] Fitur yang diminta : [nama fitur]
   Konflik terdeteksi              : [ada/tidak ada]
   Halaman terpengaruh             : [daftar halaman yang perlu diubah]
   Critical Files terdampak        : [ada/tidak ada — dari dependency-graph.md]
   Update dokumen yang diperlukan  : prd.md §2 + Blueprint Manifest §4
   Estimasi sub-task baru          : [jumlah] task di todo.md
   Konfirmasi untuk lanjut? (Y/N)
   ```
4. Setelah disetujui, perbarui `prd.md §2` dan Blueprint Manifest, baru tulis kode.
5. Tambahkan sub-task baru di `todo.md` tanpa mengubah fase yang sudah selesai.

### 2E. Saklar: `baca error`
1. Aktifkan **YOLO Debugging Pipeline** (Detail di §5 di bawah). Tulis `/.docs/issues.md` dengan format rigid.
2. **Mandor Approval Gate:** STOP dan minta izin user sebelum merubah kode apa pun setelah `issues.md` selesai ditulis.

### 2F. Saklar: `lanjut dari sini`
1. Baca `app-context.md` (Priority Recovery) -> dapatkan STATE dan NEXT. Grep `todo.md` untuk `[/]` dan `[ ]` terdekat.
2. Rekonstruksi status secara mandiri.
3. Cetak laporan singkat (max 10 baris):
   ```
   [RECOVERY] Task aktif: [nama task]
   [RECOVERY] File terakhir disentuh: [path file]
   [RECOVERY] Issue terbuka: [ada/tidak ada]
   [RECOVERY] Langkah berikutnya: [aksi konkret]
   ```
4. Lanjut tanpa konfirmasi jika tidak ada issue terbuka.

### 2G. Saklar: `status proyek`
1. Baca `todo.md` (hitung `[x]` vs total) dan `app-context.md §APP`.
2. Cetak brief dalam format tabel ringkas (max 10 baris):
   ```
   Proyek     : [name dari app-context.md §APP]
   Fase Aktif : Fase X dari Y
   Progress   : [N]% ([N]/[Total] sub-task selesai)
   State      : [build dari app-context.md §STATE]
   Next Task  : [Task berikutnya dari todo.md]
   ```

### 2H. Saklar: `analisa kualitas`
1. Scan codebase terhadap standard linter, type-safety, code smells, duplikasi, dan standard visual Vibes.
2. Output wajib di `/.docs/quality_review.md` dengan format severity (CRITICAL, WARNING, INFO).
3. Setelah review selesai, sajikan ringkasan dan rekomendasi refactoring konkret kepada user.

### 2I. Saklar: `analisa keamanan`
1. Jalankan **6 Lapisan Scan Kelayakan Keamanan** secara mendalam (SAST — Static Analysis).
2. Scan dependencies terhadap vulnerability database (CVE).
3. Output ke `/.docs/security-audit.md` menggunakan format dari `security-patterns/data/audit-template.md`.
4. Laporkan temuan risiko dan rencana mitigasi ke user.
5. *Tidak memerlukan Docker atau API key eksternal — murni static analysis.*

### 2J. Saklar: `pentest` / `pentest cepat` / `pentest mendalam` / `pentest api` / `pentest auth`
> DAST — Dynamic Application Security Testing via Strix AI Pentest Agent.
> Detail lengkap: `config/skills/pentest-strix/SKILL.md`

1. **Baca `pentest-strix/SKILL.md`** via `view_file` sebelum eksekusi apapun.
2. **Pre-Flight Check (5 item wajib):**
   - `docker ps` → Docker running?
   - `strix --version` → strix-agent terinstall?
   - `$env:STRIX_LLM` → LLM model terkonfigurasi?
   - `$env:LLM_API_KEY` → API key tersedia?
   - Baca `app-context.md §APP` → ambil field `url=` untuk URL lokal
   Jika salah satu gagal → cetak instruksi setup dari `pentest-strix/SKILL.md §5` dan STOP.
3. **Target Detection:** Deteksi URL target dari `app-context.md §APP` (field `url`) / `prd.md §1` → tampilkan dan minta konfirmasi user.
4. **Scope per Sub-Saklar:**
   - `pentest` → `strix --target [URL]` (full scan)
   - `pentest cepat` → `strix --target [URL] --scan-mode quick`
   - `pentest mendalam` → full + instruction fokus business logic & race condition
   - `pentest api` → instruction fokus API security (IDOR, auth, rate limit)
   - `pentest auth` → instruction fokus authentication bypass & session attack
5. **Eksekusi Strix** → monitor progress → parse hasil dari `strix_runs/`
6. **Merge findings** ke `/.docs/security-audit.md` section `## DAST FINDINGS (Strix)`
7. **Mandor Gate:** STOP setelah report — tampilkan ringkasan, tunggu instruksi fix user.

---

## §5. YOLO DEBUGGING PIPELINE (`baca error` mode)

1. **State Retention:** Catat file bermasalah dan hipotesis ke `/.docs/issues.md` (tandai status `IN_PROGRESS`) secara temporer agar state tidak hilang jika sesi terputus.
2. **Pembersihan Zombie Port & Access Denied Fallback:** Cek port dev server. Jika port terkunci, matikan proses. Jika Access Denied, increment port + 1, update `.env` dan `app-context.md §APP` field `port=`, lalu jalankan server di port baru. *Batas Port Drifting:* AI dilarang melakukan increment port lebih dari **3 kali** berturut-turut (maks PORT+3). Jika port ke-3 tetap gagal/terkunci, hentikan server secara total, cetak error kritis ke terminal, dan tunggu instruksi manual dari user. Bypass jika Pure Frontend.
3. **Log Dev Server Background:** Pipa stdout/stderr dev server ke `.scratchpad/dev-server.log`.
4. **Full-Scan Fitur & Database Lock Release:** Gunakan tool filesystem untuk tracing error. Hapus file lock database (SQLite `.db-journal`, `.db-wal`) jika transaksi DB hang.
5. **issues.md & FIFO Rolling Buffer:** Tulis temuan ke `/.docs/issues.md`. FIFO: max 10 RESOLVED history, OPEN/IN_PROGRESS dilarang hapus.
6. **Mandor Approval Gate:** STOP koding, sodorkan analisis perbaikan di terminal, dan tunggu persetujuan tertulis user sebelum mengubah file kode. *Bypass Non-Interactive:* Jika terdeteksi lingkungan non-interactive (seperti `$CI = true`, `$env:CI = 'true'`, atau terminal bukan TTY), AI diizinkan mem-bypass gerbang ini, langsung menerapkan kode perbaikan, dan menandai commit dengan tag `[AUTO-FIX]` secara terpisah.
7. **Imunitas Core Arsitektur & Mock Fallback:** Dilarang update dependensi sepihak atau merubah arsitektur core. Jika API eksternal down, implementasikan mock fallback, catat `RESOLVED_WITH_FALLBACK` di `issues.md`.
8. **Kompilasi Interseptor & Auto-Fix Lint Traps:** Setiap perbaikan wajib di-build (`CI=true` / `$Null`). Jalankan auto-fix formatter (`eslint --fix`, `pint`) sebelum edit manual untuk menghindari linter traps.
9. **Looping Guard & Rollback Git Bersih:** Batasi max 3x percobaan perbaikan. Jika gagal, git restore/clean workspace (gunakan `git restore . && git clean -fd` secara tuntas), update `issues.md` status `GAGAL`, dan lapor user.
10. **Verifikasi Runtime & IT Scan:** Verifikasi `.scratchpad/dev-server.log` dan jalankan ulang 6 Lapisan Scan Keamanan sebelum set status `RESOLVED` / `RESOLVED_WITH_FALLBACK` di `issues.md`.

---

## §6. OTOMATISASI WORKFLOW (HANDOVER & COMMIT)

### 6A. Git Commit Protocol (5 Tahap Wajib)

> ⛔ **HARD BLOCK:** AI **FORBIDDEN** menggunakan `git commit -am`, `git add .`, atau `git add -A` tanpa melalui 5 tahap di bawah ini. Pelanggaran = **Fatal Leak Violation**.

1. **Tahap 1 — Verifikasi `.gitignore`:** Pastikan sudah mencakup Kategori Rahasia Dapur (Internal AI files: `handover.md`, `prd.md`, `todo.md`, `issues.md`, `gemini.md`, `design-system.md`, `app-context.md`; Kredensial: `.env*`, `*.key`, `*.pem`; DB: `*.sqlite`, `*.db`; Logs: `/.scratchpad/`, `*.log`; Aset: `node_modules/`, `build/`, `dist/`, `.next/`).
2. **Tahap 2 — Force Untrack:**
   ```powershell
   # Windows PowerShell:
   $Null = git rm --cached -r --force .env* handover.md prd.md todo.md issues.md app-context.md *.sqlite *.db *.sqlite3 *creds.json *accounts.json *secret* .scratchpad/ 2>$Null
   ```
3. **Tahap 3 — Selective Add:** Stage hanya folder/file source code aktif yang diubah (e.g. `git add src/components/Button.tsx`).
4. **Tahap 4 — Unstage Checkpoint:**
   ```powershell
   git status --porcelain
   $Null = git restore --staged .env* handover.md prd.md todo.md issues.md *.sqlite *.db *.sqlite3 *.log *creds.json *accounts.json *secret* .scratchpad/ 2>$Null
   ```
   Jika file rahasia dapur masih staged, HENTIKAN commit dan ulangi dari Tahap 2.
5. **Tahap 5 — Conventional Commit:**
   - `feat: [fitur] - Fase [X]` (milestone todo)
   - `chore: update handover milestone log - [Sub-Fase]` (auto-update handover)
   - `fix: [bug] - closes #[issue-id]` (YOLO debug)
   - `style: [perubahan visual] - [komponen]` (revisi UI)
   - `refactor: [deskripsi] - no functional change` (refactoring)

---

### 6B. Template File `handover.md` (9-Section Anatomy)
```markdown
# SYSTEM HANDOVER & ACTIVE STATE LOG

## 1. Ringkasan Proyek
- **Deskripsi:** [Fungsi utama proyek]

## 2. Environment & Local Settings
- **Local Dev Server Port:** [Port aktif]
- **App URL (Lokal):** [URL lokal]
- **Database Path:** [SQLite path / detail DB]
- **Kondisi Kompilasi:** SUCCESS / PRODUCTION READY
- **Status 6 Lapisan Scan:** [L1: PASSED | L2: PASSED | L3: CLEAN | L4: SECURED | L5: VERIFIED | L6: COMPLETE]
- **Timestamp Akhir:** [Waktu WIB/+07:00]
- **Nama Tema:** [Nama unik proyek]
- **Developer:** [Nama/Inisial]

## 3. Tech Stack
- **Framework & Runtime:** [Next.js / Laravel / PHP Native, dll]
- **CSS / Styling:** [Tailwind CSS v4 / Vanilla CSS, dll]
- **Icons Library:** [Lucide / Phosphor, dll]
- **Charts Engine:** [Chart.js / N/A]
- **Additional Stack:** [Python FastAPI / Redis / N/A]

## 4. Karakter Visual (Visual DNA) — IDENTITY SNAPSHOT
- **Nama Aplikasi:** [Nama resmi]
- **Palet No. & Nama:** [No. X — Nama]
- **Hex Bg / Surface:** [#hex / #hex]
- **Hex Accent1 / Accent2:** [#hex / #hex]
- **Mode Tema:** [Static Light / Static Dark / Dynamic]
- **Font Family:** [Heading Font | Body Font]
- **Geometri Box:** [Sharp / Rounded / Pill]
- **Avatar Shape:** [Circle / Rounded Square]
- **Navigasi Model:** [Top Navbar / Sidebar / Floating Dock]
- **Hero Layout:** [Split 50:50 / Dashboard Grid, dll]

## 5. Struktur View & Fitur Baru
| Nama Halaman | Path Berkas Nyata | Kluster Akses | Status Fungsional |
| :--- | :--- | :--- | :--- |

## 6. File Kunci & Perubahan Sistem
- **Variabel State/Simulation Store:** [Daftar state]
- **Endpoint API / Server Actions:** [Jalur data]

## 7. Catatan Teknis & Bug Fixes (Resolved)
- [FIFO rolling log buffer 100 baris]

## 8. Catatan Debugging Gagal & Solusi (Lessons Learned)
- [Eksperimen yang gagal agar tidak diulangi]

## 8B. Known Limitations & Technical Debt
- [ID-LIM-XXX] [masalah]: [workaround]. Resolusi: [Fase]

## 8C. Technical Decision Log (ADR — Architecture Decision Record)
| ID | Keputusan Diambil | Alternatif Ditolak | Alasan Singkat | Tanggal |

## 9. Panduan Standarisasi & Lifecycle
- App-context overwrite dan handover append setiap 5-6 task selesai.
- Git commit dengan 5 tahap wajib.

## 10. Log Perubahan Terbaru (Milestone Timeline)
- [FIFO rolling log buffer 100 baris — format: `[YYYY-MM-DD HH:MM] [FASE N] [x] Deskripsi task`]
- Contoh: `[2026-07-15 14:30] [FASE 2] [x] Setup CSS tokens — design-system aktif`
```

---

## §7. DEFINISI STRUKTUR FASE TODO.MD
*(Struktur 8 fase untuk proyek baru / 9 fase untuk konversi. Hapus/skip fase yang tidak relevan dengan stack.)*

### Fase 1: Foundation & Environment Setup
- [ ] Init git repo + setup `.gitignore` (env, DB, handover, prd, node_modules, .scratchpad)
- [ ] Buat `.env` + `.env.example` + setup koneksi DB (SQLite/MySQL/PostgreSQL)
- [ ] Generate skeleton `app-context.md` + `handover.md` + folder `/.docs/`
- [ ] Install AST security linter (`eslint-plugin-security` / `phpstan`) — Mitigasi L3 SAST
- [ ] Verifikasi dev server jalan di port dari `user-prefs.md` (bukan port 3000/8000)

### Fase 2: Core Architecture & Design System
- [ ] Setup CSS token system lengkap (`--vibe-*` tokens) di file CSS utama
- [ ] Buat base layout shell (root layout, `<head>` dengan font preload dari Google Fonts)
- [ ] Implementasi auth middleware / route guard dasar (session/JWT check)
- [ ] Buat komponen base sesuai design-system.md: Button, Card, Input, Modal, Badge
- [ ] Setup routing struktur utama + generate `/.docs/routes.md` awal

### Fase 3: Guest Layer (Public / Unauthenticated)
- [ ] Landing Page: Hero section + Features + CTA — sesuai Visual DNA (Three Dials)
- [ ] Halaman Login + Captcha + rate limiting endpoint
- [ ] Halaman Register + validasi email + hashing password (bcrypt/argon2)
- [ ] Halaman publik pendukung (About, Contact, dll) — Zero Dead-End Link policy

### Fase 4: Member Layer (Authenticated / Protected)
- [ ] Member Dashboard dengan data dinamis dari DB (bukan dummy/hardcode)
- [ ] Halaman Profil + Avatar Upload — wajib ikuti `gemini-execution.md §4E` Upload Pipeline
- [ ] Halaman Settings (ubah password, notifikasi, preferensi)
- [ ] Protected route guard — redirect ke /login jika token tidak valid/expired

### Fase 5: Admin Layer (Privileged Control Panel)
- [ ] Admin Dashboard (statistik pengguna, log aktivitas terbaru)
- [ ] User Management CRUD (list, detail, edit role, ban/unban)
- [ ] App Settings dari DB (nama aplikasi, logo, konfigurasi — tidak hardcode)
- [ ] Role-based access control — guard admin terpisah dari guard member

### Fase 6: Backend Service Layer
- [ ] Validasi input terpusat + sanitasi string di semua endpoint form/API
- [ ] Rate limiting pada endpoint login, register, reset-password, dan API publik
- [ ] ACID Transaction Guard untuk mutasi multi-tabel (saldo, stok, relasi kritis)
- [ ] Email service: verifikasi akun + reset password (SMTP / Resend / Mailgun)

### Fase 7: API, Webhooks & Third-Party Integrations
- [ ] Definisikan dan implementasi semua REST/RPC API endpoint
- [ ] Generate `/.docs/api-spec.md` (method, auth, request, response setiap endpoint)
- [ ] Setup Webhook handler jika ada integrasi eksternal (payment, notifikasi push)
- [ ] Integrasi third-party SDK (payment gateway, cloud storage, maps, dll)

### Fase 8: Polish, SEO, A11Y & Deploy Prep
- [ ] Jalankan SEO Checklist 20-item (`gemini-execution.md §4L`) per halaman publik
- [ ] Buat `robots.txt` + `sitemap.xml` dinamis
- [ ] Audit A11Y: keyboard nav, ARIA labels, kontras warna ≥ 4.5:1
- [ ] Lighthouse audit — target LCP ≤ 2.5s, CLS ≤ 0.1, INP ≤ 200ms
- [ ] Jalankan 6 Lapisan Scan Keamanan penuh + generate `/.docs/security-audit.md`
- [ ] Generate `/.docs/` lengkap: architecture.md, routes.md, dependency-graph.md
- [ ] Tulis Retrospective di `knowledge/project-retrospectives/` + overwrite `app-context.md`

*(Fase 9: Legacy Purge — Khusus Mode Konversi: dry-run log + persetujuan tertulis user → hapus `/.legacy/`)*
