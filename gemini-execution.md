# AI CODING AGENT — DETAILED EXECUTION INSTRUCTIONS (VIBES CODING WORKFLOW V4.0.0)
*[Split Architecture: gemini-execution.md — dimuat AI via view_file saat eksekusi koding aktif]*

---

## §3. USER PREFERENCES LOADING & CONTEXT-AWARENESS

### §3.A User Preferences Loading & Instruction Validation (Context-Awareness) <!-- anchor:3A -->

-1. **User Preferences Load (HIGHEST PRIORITY — Silent — Setiap Sesi):**
    SEBELUM apapun, AI REQUIRED baca `$HOME/.gemini/user-prefs.md` (Windows: `%USERPROFILE%\.gemini\user-prefs.md`) secara senyap:
    - Ambil `[DEVELOPMENT]` → gunakan sebagai default port, package manager, db engine
    - Ambil `[DESIGN_DEFAULTS]` → gunakan sebagai fallback jika user tidak memilih font/palet/geometry
    - Ambil `[AI_BEHAVIOR].context7_whitelist` → aktifkan auto-trigger context7 untuk library ini
    - Ambil `[AI_BEHAVIOR].taste_skill_auto` → jika `true`, aktifkan taste-skill-bridge auto-trigger
    - Ambil `[AI_BEHAVIOR].uupm_auto_run` → jika `true`, jalankan UUPM Step 1 saat awal baru & redesign
    - Ambil `[SESSION_PROTOCOL].handover_trigger` → gunakan sebagai threshold handover update
    - Ambil `[BROWSER_TOOL].scratchpad_dom` → jika `FORBIDDEN`, aktifkan PROTEKSI ABSOLUT SCRATCHPAD DOM (lihat `AGENTS.md §BROWSER TOOL GATE`)
    - Ambil `[BROWSER_TOOL].browser_gate` → jika `STRICT`, wajib cetak `[Browser Gate]` log sebelum tiap browser_subagent
    - Ambil `[BROWSER_TOOL].dom_read_default` → gunakan sebagai default tool untuk cek DOM (`read_url` = wajib pakai read_url_content)
    - Ambil `[BROWSER_TOOL].recording_default` → jika `OFF`, FORBIDDEN auto-start recording browser
    - Ambil `[NOTIFICATION].milestone_banner` → jika `true`, cetak `[🔒 Milestone selesai]` setelah setiap fase selesai
    - Ambil `[NOTIFICATION].drift_alert` → jika `true`, cetak `[HANDOVER DRIFT DETECTED]` saat mismatch > 2 task
    - Ambil `[NOTIFICATION].browser_gate_log` → jika `true`, REQUIRED cetak `[Browser Gate]` sebelum tiap browser_subagent
    - Ambil `[NOTIFICATION].self_check_log` → jika `true`, REQUIRED cetak `[SELF-CHECK]` setelah tiap task selesai
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
2a. **Ask-Before-Assume Gate:** Jika instruksi user ambigu atau AI tidak yakin konteks yang benar (patuhi `user-prefs.md [ACTION_BEHAVIOR].ask_before_assume`):
    - STOP eksekusi
    - Tanyakan klarifikasi spesifik (maks 3 pertanyaan)
    - Jangan lanjutkan sampai user menjawab
    - FORBIDDEN asumsi yang bisa menyebabkan failure
    - Output wajib:
      ```
      [ASK-CLARIFY] Saya kurang yakin tentang [X]. Apakah Anda maksud:
          A) [opsi A]
          B) [opsi B]
          C) [opsi lain — jelaskan]
      ```
3.  **Sinkronisasi Wajib:** Setelah user setuju, AI WAJIB memperbarui `prd.md` dan/atau `todo.md` **sebelum** atau **dalam giliran yang sama** saat menulis kode fitur tersebut. Ini memastikan dokumentasi selalu sinkron dengan kenyataan.

### Auto-Apply Lessons Learned (Lessons-Aware Coding):
Setiap kali AI akan menulis kode untuk konteks berikut, WAJIB baca secara silent `lessons-learned/data/anti-patterns.md` (atau folder database/security patterns terkait):
- **Auth:** login, register, password, session, token, jwt, oauth
- **Database:** query, select, insert, update, delete, mysqli, PDO, prisma, knex
- **Input:** form, $_POST, $_GET, $_REQUEST, req.body, req.params, req.query
- **Upload:** file upload, multer, move_uploaded_file, storage, bucket
- **API:** route, endpoint, middleware, controller, handler

Jika pattern yang akan ditulis mirip dengan entry di `anti-patterns.md` → HINDARI. Gunakan pattern aman yang sudah teruji.
Format output (jika terdeteksi): `[LESSONS LEARNED] Pattern [Nama] terdeteksi pernah gagal → menggunakan pattern aman.`

### §3.B Protokol Eksekusi & Uji Coba (Fail-Fast Workflow) <!-- anchor:3B -->
1.  **Verifikasi Pre-Task:** Sebelum mengerjakan tugas di `todo.md`, baca ulang spesifikasi relevan di `prd.md`.
2.  **Pre-flight Check:** Sebelum menjalankan proses `build` penuh yang lambat, AI WAJIB menjalankan perintah cepat:
    *   **Linter & Formatter Check** (`eslint`, `prettier --check`, `pint`, dll.)
    *   **Type Checker** (`tsc --noEmit`, dll.)
    AI harus memperbaiki error dari *pre-flight check* ini terlebih dahulu.
3.  **Incremental Build Verification:**
    Sebelum menjalankan build penuh, AI WAJIB menjalankan verifikasi inkremental pada file-file yang diubah:
    - Lint file yang diubah → `eslint [file] --max-warnings=0` / `./vendor/bin/pint [file]` / `php -l [file]`
    - Type-check file yang diubah → `tsc --noEmit [file]` (jika TypeScript)
    - Jika lolos → lanjut ke build penuh (jika diperlukan)
    - Jika gagal → perbaiki → retry (maks 3x)
    *Pengecualian:* Build penuh wajib dijalankan di akhir Fase (milestone), setelah perubahan >5 file, atau perubahan arsitektur core (routing, DB, auth).
4.  **Build Penuh & 6 Lapisan Scan:** Hanya jika *pre-flight check* & incremental build lolos, AI menjalankan `build` penuh dan 6 lapisan scan keamanan.
5.  **Gerbang Kelulusan Taktis (Fail-Fast):** Jika ada error di tahap manapun, proses dihentikan, checkbox `todo.md` tidak dicentang, dan AI langsung masuk mode perbaikan.
6.  **Self-Reflection Gate (Sebelum Serah ke User):**
    Sebelum menyatakan task selesai, AI REQUIRED melakukan self-check cepat dan mencetak checklist format berikut:
    ```
    [PRE-FLIGHT CHECKLIST]
    - [ ] File yang diminta sudah dibuat/modified?
    - [ ] Tidak ada href="#" atau link mati?
    - [ ] CSS tokens dipakai (var(--vibe-*)), bukan hex hardcode?
    - [ ] Handover check: change_counter=[N]/[threshold] (§3.B.7)?
    - [ ] Self-check visual rules (jika task visual)?
    ```
    Jika ada item yang belum dicentang `[ ]`, perbaiki SEBELUM menyatakan selesai.

### §3.B.7 Handover Auto-Update Enforcement Protocol (Dual-Mode) <!-- anchor:3B7 -->

AI REQUIRED mengelola internal counter `change_counter` per session.

**Definisi "1 Code-Change":**
- Setiap kali AI berhasil menulis atau menyunting file source code aplikasi (misal: `.php`, `.js`, `.ts`, `.tsx`, `.vue`, `.html`, `.css`, `.py`, `.sql`, dll.).
- Multiple edits pada 1 file dalam 1 turn = 1 code-change.
- Pembuatan file kode baru = 1 code-change.
- Edit file dokumentasi/metadata saja (`app-context.md`, `prd.md`, `handover.md`, `todo.md`, `.docs/`) = **BUKAN** code-change (tidak menambah counter).

**Dual-Mode Trigger Logic:**
```
MODE A — Todo-Active (Proyek baru/fase berjalan dengan todo.md aktif):
  → Gunakan todo counter: setiap `handover_trigger` task [x] di todo.md → trigger handover

MODE B — Ad-Hoc (Proyek selesai fase / request incremental tanpa todo.md):
  → Gunakan change counter: setiap `handover_trigger` code-changes tercapai → trigger handover
```

**Prosedur Saat Trigger Tercapai:**
1. Overwrite `app-context.md` (update state snapshot terbaru dan perbarui timestamp `<!-- Last: ... -->`).
2. Append log entry ringkas ke `handover.md §10`:
   `[YYYY-MM-DD HH:MM] [AD-HOC] Deskripsi ringkas perubahan kode terakhir`
3. Cek panjang baris `handover.md` → jika > 500 baris, jalankan pemotongan arsip ke `.archive/`.
4. Cetak log konfirmasi: `[HANDOVER UPDATE] Triggered (Mode: [Todo/Ad-Hoc]) → app-context.md & handover.md updated.`
5. Reset `change_counter` = 0.

**Session-End Handover (Failsafe):**
- Jika sesi akan berakhir atau user berganti topik/mengakhiri sesi dan `change_counter > 0` (ada perubahan kode yang belum di-handover):
  → AI WAJIB melakukan force update ke `app-context.md` + append `handover.md §10` sebelum sesi ditutup.
  → Cetak: `[SESSION-END HANDOVER] [N] uncommitted changes saved to app-context.md`

**Proactive Drift Detection saat `awal lanjut` / `lanjut dari sini`:**
1. Jalankan `git status --short` (0.01 detik).
2. Jika ditemukan file kode berstatus `M` (modified) atau `??` (untracked) di luar snapshot `app-context.md`:
   → Cetak: `[HANDOVER DRIFT] Terdeteksi [N] file kode berubah di luar snapshot. Auto-updating app-context.md...`
   → Perbarui `app-context.md` dengan daftar file terkini sebelum menyajikan status.

### §3.C Definisi 6 Lapisan Scan Kelayakan Keamanan (Security Gate Protocol) <!-- anchor:3C -->
AI REQUIRED mengeksekusi keenam lapisan berikut secara berurutan. Lapisan tidak boleh dilewati. Jika satu lapisan gagal, proses dihentikan.

| Lapisan | Nama | Perintah Konkret | Lulus Jika |
|---|---|---|---|
| **L1** | Linter & Formatter | `npx eslint . --max-warnings=0` / `npx prettier --check .` / `./vendor/bin/pint --test` | Zero warnings, zero errors |
| **L2** | Type Safety | `npx tsc --noEmit` / `npx tsc --noEmit --strict` | Zero type errors |
| **L3** | SAST (Static Analysis) | Audit celah keamanan. Jika AST linter terinstall (e.g. `eslint-plugin-security` / `phpstan`), prioritaskan verifikasi via linter tersebut. Fallback: grep manual untuk pola berbahaya: `eval(`, `innerHTML =`, `dangerouslySetInnerHTML`, `exec(`, `system(`, query tanpa prepared statement | Zero pola berbahaya / scan clean |
| **L4** | Form Input Validation Guard | Baca setiap file form/endpoint — pastikan ada: validasi panjang input, sanitasi string, rate-limiting pada endpoint login/register/reset-password (rujuk `secure-patterns.md §SP-014/015` dan `xampp-php-patterns.md §SP-PHP-004`). Waspadai X-Forwarded-For spoofing (`lessons-learned §SG-016`). | Semua form & endpoint tervalidasi |
| **L5** | Auth Integrity Verification | Cek setiap protected route — pastikan middleware/guard aktif, token/session diperiksa, tidak ada bypass `if(true)` | Semua route terproteksi |
| **L6** | Security Headers Check | Cek middleware/response header handler — pastikan minimal ada 8 header: `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `X-Frame-Options: SAMEORIGIN`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy: camera=(), microphone=(), geolocation=(self)`, `Cross-Origin-Opener-Policy: same-origin`, `Cross-Origin-Resource-Policy: same-origin`, `X-Permitted-Cross-Domain-Policies: none`. Untuk HTTPS: `Strict-Transport-Security: max-age=31536000; includeSubDomains`. Pastikan tidak ada duplikasi / konflik header antar-layer. Rujuk `secure-patterns.md §SP-011/012/013/023` untuk snippet per-stack. | Semua security header wajib lengkap, hardened, dan bebas duplikasi |

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

### §3.C.1 Mode Compliance Check (untuk saklar `cek komponen`) <!-- anchor:3C1 -->
> **PENTING:** Ini adalah **verifikasi kelengkapan komponen kode** terhadap standar perusahaan (SP registry), BUKAN security audit/scan. Tujuannya: memastikan setiap komponen keamanan yang disyaratkan sudah TERPASANG di kode, bukan mencari vulnerability.

Saat saklar `cek komponen` (atau alias `analisa keamanan`) aktif, AI menjalankan **Compliance Verification Mode**:

1. **Deteksi stack proyek** dari `app-context.md §APP` (PHP Native / Laravel / Next.js).
2. **Filter SP yang relevan** berdasarkan stack:
   - PHP Native → SP-001 s/d SP-004, SP-008 s/d SP-011, SP-016 s/d SP-023, SP-PHP-001 s/d SP-PHP-004, SP-HTACCESS-001
   - Laravel → SP-005, SP-008 s/d SP-010, SP-013, SP-015 s/d SP-023
   - Next.js → SP-006 s/d SP-010, SP-012, SP-014, SP-016 s/d SP-023
   - Universal → SP-008, SP-009, SP-010, SP-016, SP-017, SP-018, SP-019, SP-020, SP-021, SP-022, SP-023
   - **Multi-Stack Rule:** Jika proyek menggunakan >1 framework (misalnya PHP Native + Next.js), gabungkan SP set dari semua stack yang terdeteksi. Deduplikasi otomatis — setiap SP hanya diperiksa 1x.
3. **OWASP Top 10:2025 mapping** — organisasikan temuan per kategori OWASP:

   | OWASP | Kategori | SP Terkait | Grep Indicators |
   |---|---|---|---|
   | A01 | Broken Access Control | SP-006, SP-PHP-001, **SP-020**, **SP-021**, **SP-022**, L5 | `getServerSession`, `requireAuth`, `csrf_token`, `validateUrl`, `user_id` ownership, `safeRedirect` |
   | A02 | Security Misconfiguration | SP-008, SP-011/012/013, **SP-023**, SP-HTACCESS-001 | `Content-Security-Policy`, `X-Frame-Options`, `Permissions-Policy`, `Cross-Origin-Opener-Policy`, `Cross-Origin-Resource-Policy` |
   | A03 | Supply Chain Failures | **SP-016** | `package-lock.json` exists, no `*` versions, `npm ci` |
   | A04 | Cryptographic Failures | SP-004, SP-007, SP-009 | `password_hash`, `PASSWORD_BCRYPT`, env check |
   | A05 | Injection | SP-001, SP-002, L3 | `prepare(`, `htmlspecialchars`, no `eval(` |
   | A06 | Insecure Design | SP-014/015, SP-PHP-004 | `rateLimit(`, `throttle:`, login attempts |
   | A07 | Authentication Failures | SP-PHP-002, SP-004, CS-033 | `session_regenerate_id`, `cookie_httponly`, 429 |
   | A08 | Software Integrity | **SP-017** | `integrity=` in CDN scripts, `npm ci`, `.gitignore` check |
   | A09 | Logging Failures | **SP-018** | `display_errors=0`, `log_errors=1`, no password in logs |
   | A10 | Exceptional Conditions | **SP-019** | `set_error_handler`, `error.tsx`, `Handler.php`, `APP_DEBUG=false`, no empty catch |

4. **🔴 MANDATORY: Grep codebase FAKTUAL per SP** — AI WAJIB menjalankan `grep_search` untuk SETIAP SP yang relevan. Cari indikator implementasi (function name, header value, config key) di file kode aktual. FORBIDDEN menulis status komponen dari memori/asumsi tanpa grep.
   - Jika SP relevan = 15 → minimum 15x `grep_search` (boleh di-batch per kategori OWASP)
   - Setiap SP yang dicek WAJIB menyertakan evidence: `[Evidence: grep "pattern" → file:line | NOT FOUND]`
   - Jika grep indicator DITEMUKAN → status: `✅ TERPASANG [file:line]`
   - Jika grep indicator TIDAK DITEMUKAN → status: `❌ BELUM TERPASANG — rekomendasi: [SP-XXX]`
5. **🔴 MANDATORY: Dependency Audit** — Jika `package-lock.json` ada → WAJIB jalankan `npm audit --json 2>$null`. Jika `composer.lock` ada → WAJIB jalankan `composer audit --format=json 2>$null`. Hasil masuk ke section A03. Jika tidak ada lockfile → catat "No lockfile found". FORBIDDEN skip step ini.
6. **Output checklist** ke `/.docs/security-audit.md` dengan format per-OWASP (lihat gemini-templates.md §2I). Setiap finding WAJIB memiliki evidence marker.
7. **Opsional** menjalankan linter/SAST tools (`eslint`, `tsc`, `phpstan`) jika terinstall — TIDAK FORBIDDEN, tapi bukan syarat wajib. Yang WAJIB: `grep_search` per SP + `view_file` untuk verifikasi konteks.
8. **🔴 FORBIDDEN membaca `security-audit.md` lama** sebagai pengganti scan baru. Setiap eksekusi `cek komponen` = scan ulang penuh dari codebase aktual. File output lama di-overwrite.

### §3.C.2 Factual Scan Enforcement Protocol (FSEP) <!-- anchor:3C2 -->
> Aturan universal yang berlaku untuk SEMUA mode audit dan verifikasi: `cek komponen`, `analisa kualitas`, 6 Lapisan Scan.

**🔴 HARD RULES (Tidak Dapat Dikecualikan):**

1. **Anti-Fabrication Audit Rule:** FORBIDDEN menulis "PASSED", "✅ TERPASANG", "CLEAN", "OK", atau status positif lainnya tanpa bukti `grep_search`, `view_file`, atau `run_command` yang mendukung finding tersebut. Finding positif tanpa evidence = FABRICATION = pelanggaran Hard Block #10.

2. **Evidence Requirement:** Setiap baris finding di output WAJIB menyertakan salah satu:
   - `[Evidence: grep "pattern" → file.php:L42]` — ditemukan
   - `[Evidence: grep "pattern" → NOT FOUND]` — tidak ditemukan
   - `[Evidence: view_file path L42-L50]` — verifikasi konteks
   - `[Evidence: run_command "npm audit" → 0 critical]` — tool output
   Finding tanpa evidence marker = INVALID, WAJIB diulang.

3. **Minimum Scan Depth:**
   - `cek komponen`: Minimum 1x `grep_search` per SP yang di-filter. Jika 15 SP relevan → minimum 15x grep. SEMUA SP WAJIB dicek — komponen keamanan krusial, tidak boleh ada yang di-skip.
   - `analisa kualitas`: Minimum scan semua file utama di direktori source (`src/`, `app/`, `pages/`, atau root project). Minimum 5x `grep_search` untuk code smells + 1x linter run.
   - 6 Lapisan Scan: Sesuai §3.C (sudah ada minimum per lapisan).

4. **Token Guard Suspension (Audit Exemption):** Selama mode audit aktif (`cek komponen` atau `analisa kualitas`), batas `max_files_per_turn` dan `max_lines_per_read` dari `user-prefs.md` **DITANGGUHKAN**. AI boleh membaca lebih dari 5 file dan lebih dari 200 baris per turn untuk keperluan scan. Batas di-restore setelah output audit selesai ditulis.

5. **Scan Log Wajib:** Setelah scan selesai, AI WAJIB mencetak log berikut SEBELUM menyajikan hasil ke user:
   ```
   [SCAN LOG] Mode: [cek komponen | analisa kualitas | 6 Lapisan]
   [SCAN LOG] grep_search: N queries executed
   [SCAN LOG] view_file: N files inspected
   [SCAN LOG] run_command: N commands executed (npm audit, linter, dll)
   [SCAN LOG] SP checked: N/N (harus 100% untuk cek komponen)
   [SCAN LOG] Findings: N total (X ❌ BELUM TERPASANG, Y ✅ TERPASANG)
   ```
   Jika `SP checked` < 100% pada `cek komponen` → scan TIDAK LENGKAP, WAJIB lanjutkan.

6. **No Legacy Read:** FORBIDDEN membaca file output lama (`security-audit.md`, `quality_review.md`) sebagai pengganti scan baru. Setiap eksekusi saklar audit = scan ulang penuh. Output lama di-overwrite, bukan di-append.

---

## §4. ATURAN PENULISAN KODE, ARSITEKTUR, & ACTIVE LINK POLICY

### §4.A Arsitektur Kode, ACID Transaksi, & Kebijakan Tautan Aktif (Structural Integrity) <!-- anchor:4A -->
- **Anti-Spaghetti & Strict Layer Separation:** AI REQUIRED memecah kode secara modular. Pisahkan secara ketat antara Presentation Layer (UI Components / Views), Business Logic Layer (Controllers / Hooks), dan Data Access Layer (Models / Queries).
- **Database Transaction Guarding (ACID Compliance):** Untuk mutasi data sensitif (stok, saldo, poin) dan mutasi data multi-tabel, AI **REQUIRED** membungkus rangkaian eksekusi query tersebut di dalam blok transaksi terisolasi secara rigid. Wajib menggunakan perintah `DB::beginTransaction();`, `DB::commit();`, dan `DB::rollBack();` di dalam `catch` block.
- **Active Navigation & Zero-Dead-End Link Policy:** AI FORBIDDEN membuat tautan mati (`href="#"` atau `href="javascript:void(0)"`). Semua menu, link sidebar, dan tombol navigasi REQUIRED memiliki file fisik halaman penampung yang aktif terhubung ke routing. Jika belum dibangun, arahkan ke halaman temporary dengan "Under Construction Card".
- **Dynamic Authentication State & Avatar Navbar Layout:** Komponen Navbar/Sidebar tidak boleh bersifat statis:
  1. *Guest State (Belum Login):* Hanya memunculkan tombol "Login" atau "Mulai". Menyembunyikan Admin/Member panel.
  2. *Logged In State:* Tombol login bertukar menjadi komponen **Avatar Lingkaran Foto Profil / Gambar User** (`rounded-full`). Klik avatar memicu dropdown menu berisi tautan Profil, Settings, dan Logout.
  3. *Admin State:* Muncul menu tambahan "Admin Panel" / "User Management" di dropdown avatar atau navigasi.
- **Dynamic Application Identity:** AI FORBIDDEN menuliskan nama aplikasi, copyright footer, dan logo secara statis (*hardcode*). Tarik secara dinamis dari config atau DB settings.

### §4.B Regulasi Keamanan Captcha Anti-Bot & Form Publik <!-- anchor:4B -->
Untuk Formulir Login, Registrasi, atau Formulir Input Publik:
1. *Visual High-Contrast Engine:* Angka/huruf Captcha REQUIRED di-render dengan warna tegas bersaturasi tinggi di atas latar belakang kontras. FORBIDDEN warna buram, grey layer, atau hitam-putih.
2. *Alphanumeric Case-Insensitive Logic:* Kombinasi dinamis angka, huruf besar, dan huruf kecil (e.g. `pG4mQ`). Backend validation REQUIRED bersifat **Case-Insensitive** (`strtolower()` / `.toLowerCase()`).
3. *Mandatory Refresh Control:* Sediakan tombol/ikon refresh interaktif untuk menghasilkan captcha baru tanpa reload halaman.
4. *State Destruction on Failure:* Jika validasi gagal, session captcha lama REQUIRED dihancurkan otomatis dan diganti dengan yang baru.
5. *Protokol Aksesibilitas Captcha (A11Y Conflict Resolution):* Jika Captcha aktif DAN A11Y Gate aktif, pilih strategi:
   - **Honeypot:** Hidden input field + timing validation (Default: zero friction, no library).
   - **Audio Captcha:** Tombol speaker → bacakan kode via Web Speech API.
   - **reCAPTCHA v3:** Jika diizinkan policy proyek.

### §4.C Arsitektur Peran File Sistem Vibes Coding (Single Responsibility Rule) <!-- anchor:4C -->
- `gemini.md` (Otak / OS) → Hukum universal di SEMUA proyek, SEMUA sesi.
- `prd-template.md` (Form Spesifikasi) → Data keputusan per-proyek dari wawancara.
- `design-system.md` (Database Visual) → Referensi token warna & komponen, dibaca ON-DEMAND.
**Hukum Duplikasi:** AI FORBIDDEN mengulangi aturan perilaku dari `gemini.md` ke dalam `prd.md`. `prd.md` HANYA boleh berisi data/pilihan spesifik proyek dan referensi silang (`→ BACA gemini.md §X`).

### §4.D Protokol Anti-Blank & Sistem Imun Visual DNA (Anti-Invisible Text Policy) <!-- anchor:4D -->
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

### §4.E Regulasi Keamanan & Optimasi Upload File (Secure Upload Pipeline) <!-- anchor:4E -->

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

### §4.F Protokol Human-Like HTTP Request (Stealth Fetch Engine) <!-- anchor:4F -->
Setiap HTTP request ke server eksternal REQUIRED menggunakan teknik kamuflase:

1. **Hukum Header Manusia:** AI **FORBIDDEN** menggunakan header default fetch/axios. Gunakan header lengkap (`User-Agent` Chrome/Windows terbaru, `Accept-Language`, `Sec-Ch-Ua`, dll.).
2. **Hukum Referer Kontekstual:** Tambahkan referer & origin yang valid.
3. **Hukum Delay Acak:** Jeda delay acak (0.5 - 2 detik) antar request.
4. **Hukum Retry Cerdas:** Exponential backoff + User-Agent rotation jika menerima status 429/403.
5. **Hukum Fallback Lokal:** Setiap `<img>` eksternal wajib punya `onerror` fallback ke placeholder lokal.
6. **Hukum Aset SVG Lokal:** Logo brand & ikon utama wajib diunduh manual dan disimpan secara lokal (fill/stroke via oklch).

### §4.G Visual DNA Extraction & Validation (Gap 3, 4, 12 Fix) <!-- anchor:4G -->

#### STEP 1 — Visual DNA Extraction (Wajib Sebelum Code)
AI REQUIRED ekstrak DNA tokens dari halaman utama sebelum menulis kode halaman turunan:

**Extraction Checklist:**
```
1. Baca halaman utama → index.html / home.blade.php / page.tsx / index.php
2. Ekstrak DNA tokens:
   a. Palet aktif         → cari var(--vibe-*) atau :root CSS variables
   b. Font pair           → cari font-family declaration (heading + body)
   c. Border-radius system → cari --radius-* atau border-radius pattern
   d. Spacing rhythm      → cari gap/padding pattern (kelipatan 8pt?)
   e. Shadow style        → cari box-shadow (tinted? pure black? neumorphic?)
   f. Nav pattern         → fixed/sticky? height? glassmorphism?
   g. Section structure   → full-width? max-width container? padding pattern?
   h. Button style        → solid? outline? ghost? pill shape?
3. Catat di [DNA Source] sebelum menulis kode apapun
```

**Output Format:**
```
[DNA Source] Inheriting from: [nama file halaman utama] — tokens: --vibe-primary, --font-heading: Geist, --radius-md: 8px, shadow-style: tinted
```

#### STEP 2 — Visual DNA Validation (Gap 4 Fix)
AI REQUIRED validasi tokens vs VDNA di prd.md §3 sebelum code:

**Validation Checklist:**
```
1. Baca prd.md §3 → ekstrak VDNA specs (palette, font, vibe)
2. Baca app.css → ekstrak CSS tokens aktual
3. Compare: apakah tokens sesuai VDNA?
4. Jika mismatch → output [DNA MISMATCH]
5. Tanya user: "VDNA mana yang mau di-apply?"
```

**Output Format (jika mismatch):**
```
[DNA MISMATCH]
prd.md §3: Acid Streetwear (orange, bold, high contrast)
app.css: --vibe-accent-1: [UUPM-selected — see design-system.md §1]
→ Question: VDNA mana yang mau di-apply?
  A) Acid Streetwear (dari prd.md §3)
  B) Phantom Violet (dari app.css)
  C) Random (UUPM search)
```

#### STEP 3 — Ask-Before-Design (Gap 6 Fix)
Jika VDNA ambiguous → STOP dan tanya user:

**Output Format:**
```
[ASK-CLARIFY] VDNA mana yang mau di-apply?
  A) Phantom Violet (dari app.css)
  B) Acid Streetwear (dari prd.md §3)
  C) Random (UUPM search)
FORBIDDEN asumsi VDNA tanpa konfirmasi
```

### §4.H Browser Tool Gate — Token Anti-Waste Protocol <!-- anchor:4H -->

> **⚠️ Primary enforcement di `AGENTS.md §BROWSER TOOL GATE` (selalu di context). Section ini adalah supplementary detail.**

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

#### ⛔ Scratchpad DOM — Proteksi Absolut (Binding user-prefs.md):
Jika `[BROWSER_TOOL].scratchpad_dom = FORBIDDEN`:
- FORBIDDEN `browser_subagent` ke `localhost`, `127.0.0.1`, port dev lokal MANAPUN
- FORBIDDEN untuk tujuan: "verifikasi build", "cek tampilan", "render check", "lihat DOM"
- Satu-satunya exception: user mengetik permintaan eksplisit di turn tersebut
- Alternatif wajib: gunakan `read_url_content` ke localhost URL (bukan browser)
Pelanggaran = FATAL VIOLATION → cetak `[SCRATCHPAD BLOCKED]`, STOP, tunggu instruksi user.

#### Pelanggaran & Konsekuensi:

```
Jika AI ingin pakai browser_subagent → wajib justifikasi 1 baris:
[Browser Gate] Alasan: [salah satu dari 4 kondisi — scratchpad_dom check lulus] → Proceed ✅
Jika tidak ada alasan valid → fallback ke read_url_content WAJIB.
Jika scratchpad_dom = FORBIDDEN dan target adalah localhost → [SCRATCHPAD BLOCKED] STOP.
```

### §4.I Visual Self-Check & Pre-Flight (Gap 5, 9 Fix) <!-- anchor:4I -->

#### Visual Self-Check (WAJIB untuk perubahan visual)
AI REQUIRED jalankan self-check ini sebelum menyatakan task UI selesai:

**Self-Check Checklist:**
```
- [ ] Design Read output?
- [ ] Three Dials diset?
- [ ] 8pt grid dipakai?
- [ ] Font pairing (2 font)?
- [ ] CSS tokens (var(--vibe-*))?
- [ ] Visual DNA valid?
- [ ] UUPM pipeline dijalankan?
- [ ] DNA extraction dilakukan?
- [ ] DNA validation dilakukan?

Jika ada ❌ → perbaiki SEBELUM declare done
```

**Output Format:**
```
[VISUAL SELF-CHECK]
Design Read: ✅ | Three Dials: ✅ | 8pt Grid: ✅ | Font Pairing: ✅
CSS Tokens: ✅ | DNA Valid: ✅ | UUPM: ✅ | DNA Extract: ✅ | DNA Validate: ✅
```

#### Pre-Flight Checklist (Sebelum Declare Selesai)
AI REQUIRED jalankan taste-skill pre-flight checklist sebelum menyatakan task UI selesai:

**Output Format:**
```
[TASTE-SKILL PRE-FLIGHT]
DNA: ✅ | File: ✅ | Typography: ✅ | Hero: ✅ | Center-bias: ✅ | Eyebrow: ✅
CTA: ✅ | Contrast: ✅ | Shape: ✅ (Asymmetric/Blob/Oval/Arch) | Tokens: ✅ | Images: ✅ | Mobile: ✅ | Article: ✅
Rhythm: ✅ [A→C→B→D→A] — WOW moment: ✅ | Full-bleed: ✅ | BG variety: ✅
```

Jika ada ❌ → perbaiki SEBELUM declare done.

> Detail checklist lengkap: `taste-skill-bridge/REFERENCE.md` (STEP 5)

### §4.J Modern CSS Enforcement Gate (CSS 2026) <!-- anchor:4J -->
AI REQUIRED menggunakan fitur CSS modern berikut dengan fallback yang sesuai:

- **Container Queries (`@container`):** Reusable components.
- **`:has()` Selector:** State parent berdasarkan child (form validation, dimming).
- **`text-wrap: balance`:** Heading (`h1`-`h3`).
- **`text-wrap: pretty`:** Paragraph (`p`, `li`).
- **`color-mix(in oklch)`:** Hover effects.
- **`dvh` / `svh` / `lvh`:** Menggantikan `100vh` untuk full height layout.

---

<!-- §4H = Browser Tool Gate (defined in gemini-execution.md §4.H <!-- anchor:4H -->) -->
<!-- §4I, §4J = Reserved for future use -->

## §4K. UI UX PRO MAX INTEGRATION PROTOCOL (SUMMARY) <!-- anchor:4K -->
*Detail implementasi lengkap dapat dibaca di folder skill: `skills/ui-ux-pro-max/SKILL.md` dan `taste-skill-bridge/SKILL.md`.*

### §4K.A UUPM Pipeline Eksekusi
```
Input User → [Three Dials] → [UUPM Search] → [design-system.md Token Mapping] → Output Kode
```
1. **Three Dials Assessment (Wajib Sebelum Search):** Tentukan 3 dial dari konteks proyek sebelum query UUPM:
   - **V (Vibrance):** 1-5 — Saturasi/vibransi palet. (1=monokrom netral, 5=neon/streetwear)
   - **M (Modernity):** 1-5 — Tingkat modernitas desain. (1=klasik/editorial, 5=ultra-futuristik)
   - **D (Darkness):** 1-5 — Preferensi gelap/terang. (1=full light, 5=full dark/noir)
   Output format wajib sebelum kode: `dials: V=[n] M=[n] D=[n]`
2. **Python Search (Prioritas):** Jalankan `python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "[deskripsi]"` (Windows: `python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "[deskripsi]"`) secara senyap.
3. **Fallback Chain (jika Python gagal atau tidak terinstall):**
   - **Fallback A:** Baca `design-system.md §1` → pilih kluster warna yang paling cocok dengan Three Dials.
   - **Fallback B:** Jika `design-system.md` tidak tersedia → gunakan `user-prefs.md [DESIGN_DEFAULTS]` sebagai baseline.
   - Catat fallback yang dipakai di baris output `[Style Rec] ... — sumber: Fallback A/B`.
4. **oklch() Mapping:** Hex hasil rekomendasi UUPM dikonversi ke oklch() dan dipetakan ke token `--raw-palette-*`.
5. **Component Pattern Query:** Query database stack-specific CSV (Laravel, Next.js, React) saat membuat komponen di Fase 3-5.

---

## §4L. SEO PRODUCTION PROTOCOL (SUMMARY) <!-- anchor:4L -->
*Checklist SEO 20-item tersedia inline di bawah. Jalankan penuh di Fase 8 / deploy prep.*

### §4L.A 7 Lapisan SEO Wajib
- **L1 (Meta Core):** `<title>` unik (50-60 char), `<meta name="description">` unik (150-160 char), `<link rel="canonical">`.
- **L2 (Open Graph):** type, title, description, url, og:image (1200x630px WebP, <1MB, ada logo + tagline).
- **L3 (Twitter Card):** summary_large_image, title, description, image.
- **L4 (Structured Data):** JSON-LD Organization (semua proyek), WebSite (homepage), BreadcrumbList (pages), Article (blog).
- **L5 (robots.txt):** Blokir private routes (`/admin/`, `/api/`, `/dashboard/`).
- **L6 (sitemap.xml):** Static/dynamic sitemap.
- **L7 (Core Web Vitals):** LCP ≤ 2.5s, CLS ≤ 0.1, INP ≤ 200ms.

### §4L.B Checklist 20-Item (Jalankan Per Halaman di Fase 8)

**Tier 1 — Meta & Discovery (1-6):**
- [ ] 1. `<title>` unik, 50-60 karakter, mengandung keyword utama halaman
- [ ] 2. `<meta name="description">` unik, 150-160 karakter, mengandung CTA/keyword
- [ ] 3. `<link rel="canonical">` ada di setiap halaman (self-referencing)
- [ ] 4. `<meta name="robots" content="index, follow">` untuk semua halaman publik
- [ ] 5. `<html lang="[kode-bahasa]">` terset (`id` / `en` sesuai proyek)
- [ ] 6. URL bersih: lowercase, hyphens, tanpa special chars, tanpa trailing slash kecuali root

**Tier 2 — Social & Rich Preview (7-11):**
- [ ] 7. `og:title`, `og:description`, `og:url`, `og:type` ada di semua halaman publik
- [ ] 8. `og:image` berukuran 1200×630px, format WebP, ≤1MB, ada logo + tagline
- [ ] 9. `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image` ada
- [ ] 10. JSON-LD `Organization` schema ada di root layout (nama, url, logo, sameAs)
- [ ] 11. JSON-LD `BreadcrumbList` di halaman non-root; `Article` di setiap post/berita

**Tier 3 — Indexing & Structure (12-16):**
- [ ] 12. `robots.txt` memblokir `/admin/`, `/api/`, `/dashboard/`, `/auth/`
- [ ] 13. `sitemap.xml` dinamis — mencakup semua URL publik, di-update otomatis
- [ ] 14. Hanya ada 1 `<h1>` per halaman, urutan heading tidak loncat (h1→h2→h3)
- [ ] 15. Setiap `<img>` punya `alt` deskriptif — bukan `alt="image"` atau kosong
- [ ] 16. Tidak ada orphan page — semua halaman bisa dicapai via navigasi atau sitemap

**Tier 4 — Performance & Technical (17-20):**
- [ ] 17. LCP ≤ 2.5s — gambar hero di-preload (`<link rel="preload" as="image">`)
- [ ] 18. CLS ≤ 0.1 — semua `<img>` dan `<video>` punya `width` + `height` eksplisit
- [ ] 19. INP ≤ 200ms — tidak ada blocking JS di main thread saat interaksi pertama
- [ ] 20. Font heading di-preload: `<link rel="preload" as="font" type="font/woff2" crossorigin>`

---

## §4M. EFFICIENCY & SPEED INTELLIGENCE PROTOCOL (V4.0.0) <!-- anchor:4M -->

### §4M.A UUPM Cache Mechanism (Fix Gap 4)
UUPM Python search result CACHE 24 jam di `$HOME/.gemini/.cache/uupm-results.json` (Windows: `%USERPROFILE%\.gemini\.cache\uupm-results.json`).

**Cache Logic:**
```
1. Cek mtime search.py → jika < 24 jam, SKIP Python execution
2. Baca hasil cache → validasi Three Dials match
3. Jika cache expired/stale → re-execute Python, update cache
4. Fallback chain tetap aktif jika cache corrupt
```

**Cache File Format:**
```json
{
  "query": "minimal corporate dark",
  "dials": {"V": 2, "M": 4, "D": 5},
  "result": {"palette": "...", "fonts": "..."},
  "cached_at": "2026-07-17T10:30:00+07:00",
  "source_mtime": "2026-07-10T08:00:00+07:00"
}
```

**Token Savings:** ~2K tokens/session (no re-execution)

---

### §4M.B Handover.md Smart Truncation + Archive (Fix Gap 5)
Handover.md **MAX 500 baris**. Jika melebihi → auto-truncate oldest entries + archive.

**Truncation Logic:**
```
1. Jika handover.md > 500 baris → keep 400 baris terbaru
2. Archive 100 baris terlama ke handover-YYYYMMDD.md (di folder .gemini/.archive/)
3. Archive file RENAME + compress (.gz) jika ukuran > 1MB
4. Handover.md header: "Last updated: [timestamp] | Archived: [count] entries"
```

**Archive Strategy:**
- Archive file: `handover-20260717.md` (date-based)
- Compressed: `handover-20260717.md.gz` (if > 1MB)
- Max archive: 10 files (oldest auto-delete)
- Archive accessible via: `cat .gemini/.archive/handover-YYYYMMDD.md`

**Token Savings:** ~47.5K tokens/session (95% reduction from unbounded growth)

---

### §4M.C Parallel File Loading Protocol (Fix Gap 6)
AI **REQUIRED** load multiple files PARALLEL saat context assembly.

**Parallel Loading Rules:**
```
1. Group files by dependency:
   - Group A (no dependency): user-prefs.md, app-context.md → LOAD PARALLEL
   - Group B (depends on A): prd.md, todo.md → LOAD after A
   - Group C (depends on B): gemini-execution.md sections → LOAD after B

2. Max parallel: 5 files per batch
3. Timeout per file: 10 seconds
4. Fallback: jika 1 file timeout → skip + log [PARALLEL TIMEOUT: file]
```

**Sequential (Before):** 4-8 detik  
**Parallel (After):** 2-4 detik  
**Impact:** Reduced context fragmentation, faster AI response

---

### §4M.D app-context.md Priority Compression (Fix Gap 7)
app-context.md **MAX 100 baris**. Priority compression untuk project besar.

**Compression Rules:**
```
1. Active pages (WIP): FULL detail (3-5 baris/page)
2. Stable pages (STABLE): COMPRESSED (1 baris/page)
   Format: [path]=[Nama]=[STABLE]=[Fase]
3. Pending pages: LIST ONLY (1 baris/page)
   Format: [path]=[Nama]=[akses]=[Fase]
4. Schema: COMPRESSED if > 10 tables
   Format: table(col1,col2,...) — max 5 cols shown
5. Flows: MAX 3 primary flows (oldest archived)
```

**Compression Example:**
```markdown
## [PAGES] BUILT
/dashboard=Dashboard=member=STABLE
/profile=Profile=member=STABLE
/settings=Settings=admin=STABLE
```

**Token Savings:** ~15K tokens/session (30-50% reduction for large projects)

---

### §4M.E Context Caching Mechanism (Fix Gap 8) <!-- anchor:4M.E -->
AI **REQUIRED** cache context files in memory per session. Re-read only if mtime changed.

**Cache Logic:**
```
1. Session start → load mtime checksum for all context files
2. File checksum → compare dengan cached checksum
3. Jika mtime unchanged → SKIP re-read, use cached content
4. Jika mtime changed → re-read file, update cache
5. Cache invalidation: manual `reset cache` command
```

**Files to Cache:**
- `gemini.md` (~14K tokens)
- `gemini-execution.md` (~20K tokens)
- `gemini-templates.md` (~14K tokens)
- `AGENTS.md` (~9K tokens)
- `user-prefs.md` (~4K tokens)

**Total Cached:** ~61K tokens (no re-read waste)  
**Token Savings:** ~20K tokens/session (no duplicate reads)

---

### §4M.F Security Patterns Cache (Fix Gap 9)
Security patterns (security-patterns data) **CACHE per session**. No full file read per code write.

**Cache Logic:**
```
1. Session start → load security-patterns into memory cache
2. Pattern lookup → instant (no file read)
3. Cache scope: per session (auto-clear on session end)
4. Fallback: jika cache corrupt → re-read file
```

**Files Cached:**
- `gemini.md §1 Security-Aware Coding` (~8K tokens)
- `gemini-execution.md §3C 6 Lapisan Scan` (~4K tokens)

**Token Savings:** ~8K tokens/session (50 writes = 400K/project)

---

### §4M.G Optimized Git Commit Commands (Fix Gap 10)
Git commit **OPTIMIZED single command**, faster execution.

**Before (2 commands, 2-4 detik):**
```bash
git add -A
git commit -m "feat: add login page"
```

**After (1 command, 0.5 detik):**
```bash
git add -A && git commit -m "feat: add login page"
```

**Optimized Commit Protocol:**
```
1. git add -A && git commit -m "[type]: [message]"
2. Type: feat|fix|docs|style|refactor|perf|test|chore
3. Message format: [type]: [scope] - [description]
   Example: feat(auth): add JWT refresh token
4. Git sanitation (FORBIDDEN commit tanpa check):
   - git status → check .env* not staged
   - git diff --cached → verify changes
   - git log --oneline -1 → verify last commit
```

**Token Savings:** ~0.1K tokens (minimal impact, faster execution)

---

### §4M.H Rule Priority System (Gap 10 Fix) <!-- anchor:4M.H -->

| Priority | Level | Compliance | Examples |
|---|---|---|---|
| 🔴 | CRITICAL | 100% — FORBIDDEN skip | Design Read, Three Dials, CSS tokens, Font pairing, ESSENTIAL.md read |
| 🟡 | IMPORTANT | 90% — minimize skip | 8pt grid, DNA validation, UUPM pipeline, DNA inheritance, Self-check |
| 🟢 | NICE-TO-HAVE | 70% — optional | Rhythm Score, Geometry variation, Motion guidelines, Premium architecture |

> AI tahu: Critical = FORBIDDEN skip, Important = minimize skip, Nice = optional

---

### §4M.I Efficiency Summary (All 10 Gaps Fixed)

| Fix | Tokens Saved/Session | Context Impact |
|---|---|---|
| 1. Duplicate §4G-ter | 6K | ✅ Moderate |
| 2. Duplicate §4K | 1K | ✅ Low |
| 3. Section numbering | 0.5K | ✅ Low |
| 4. UUPM cache | 2K | ✅ Moderate |
| 5. Handover truncation | 47.5K | ✅✅✅ CRITICAL |
| 6. Parallel loading | 0K | ✅ Indirect |
| 7. app-context compression | 15K | ✅✅ High |
| 8. Context caching | 20K | ✅✅✅ CRITICAL |
| 9. Security patterns cache | 8K | ✅✅ High |
| 10. Git optimization | 0.1K | ✅ Minimal |
| **TOTAL** | **~99.6K** | |

**Context Utilization:** 125% → 47% (within 128K window)  
**Context Quality:** 50% noise → 90% signal  
**Context Poisoning Risk:** HIGH → LOW

---

## §4N. SMART SKILL INTEGRATION (SSI) PROTOCOL <!-- anchor:4N -->

### §4N.A Auto-Detect Skill Baru
AI REQUIRED scan `config/skills/` setiap sesi baru:
- Jika ada folder baru tanpa entry di `.skill-index.json` → trigger `[SKILL DETECT]`
- Baca `SKILL.md` → extract metadata (name, description, triggers)
- Scan `data/` → list available files
- Baca `manifest.json` (jika ada) → extract version

### §4N.B Gap & Conflict Check (5-Point Checklist)
1. **Trigger Keywords Overlap** → COMBINE (tidak replace)
2. **Data Files Path Collision** → SKIP jika collision, REPORT ke user
3. **Logic/Functions Duplication** → SKIP jika duplicate, REPORT ke user
4. **Dependencies Missing** → INSTALL dependency jika belum ada
5. **Conflicts with Existing Skills** → REPORT ke user, tunggu konfirmasi

### §4N.C Smart Merge Rules
| Conflict Type | Resolution | Example |
|---|---|---|
| Trigger keywords | COMBINE | `["baca error"] + ["pernah coba"] → ["baca error", "pernah coba"]` |
| Data files | SKIP if collision | `data/form-validation.md` sudah ada → skip |
| Logic/functions | SKIP if duplicate | `authenticate()` sudah ada → skip |
| Dependencies | INSTALL if missing | Butuh `security-patterns` → install dulu |

### §4N.D Auto-Trigger Policy
- Default: **ON** setelah integrate
- User control: `disable auto-trigger <name>`, `enable auto-trigger <name>`, `test trigger <name> <keyword>`
- AI auto-activate skill saat trigger keyword terdeteksi di user message

### §4N.E AI-Managed Index
- `.skill-index.json` di-maintain oleh AI (bukan user)
- Auto-update setelah integrate/remove skill
- Format: name, path, triggers, version, dependencies, conflicts, installed_at
- Timestamp: `last_updated` setiap ada perubahan

### §4N.F Quality Analysis Trigger
- User ketik: `analisa kualitas brainvibes`
- AI scan: context poisoning risk, skill gaps, skill conflicts, performance bottlenecks, .docs staleness
- AI recommend: update existing skills, implement new skills, remove redundant skills, optimize high-cost skills, auto-update .docs

### §4N.G Auto-Update .docs Protocol <!-- anchor:4N.G -->
**Trigger:** Setiap handover terpicu (setiap 5 task selesai ATAU `change_counter` ad-hoc tercapai §3.B.7) → AI auto-scan `.docs/`

**Checklist:**
```
1. architecture.md → scan codebase → update jika ada perubahan arsitektur
2. api-spec.md → scan routes/endpoints → update jika ada endpoint baru
3. database.md → scan migrations/schema → update jika ada table/column baru
4. quality_review.md → run linter → update jika ada code smell baru
5. routes.md → scan frontend/backend → update jika ada route baru
6. dependency-graph.md → scan imports → update jika ada file baru
7. deployment.md → scan stack/target → update jika ada perubahan deploy config
8. issues.md → FIFO max 10 resolved → update jika ada issue baru
9. design-system.md → scan tokens/CSS & prd.md §3 → update jika ada perubahan token visual/komponen/palet
```

**Implementation:**
```
1. AI cek trigger: task count mod 5 == 0 (Mode Todo) ATAU change_counter tercapai (Mode Ad-Hoc §3.B.7)
2. Jika terpicu → jalankan auto-update .docs bersamaan dengan handover update
3. AI scan .docs/ files → compare dengan codebase aktual
4. Jika ada perubahan → update file
5. Jika tidak ada perubahan → skip
6. Print: "[DOCS UPDATE] X files updated, Y files skipped"
```

**Token Optimization:**
```
- Scan .docs/ files hanya jika ada perubahan di codebase
- Gunakan mtime check → skip jika file tidak berubah
- Batch update → 1x scan, update semua file yang perlu
- Archive old .docs/ jika ukuran > 100 baris/file
```

### §4N.H Error Handling
```
Skill Corrupt:
→ AI detect: SKILL.md tidak valid
→ Action: Log error, skip skill, report ke user
→ Print: "[SKILL ERROR] X corrupt, skip until fixed"

Dependency Missing:
→ AI detect: Skill A butuh Skill B, tapi B belum ada
→ Action: INSTALL B dulu, lalu A
→ Print: "[DEPENDENCY] Installing B (required by A)..."

Index Out of Sync:
→ AI detect: .skill-index.json tidak match dengan codebase
→ Action: Rebuild index dari codebase
→ Print: "[INDEX SYNC] Rebuilding index from codebase..."
```

### §4N.I SSI Workflow Summary
```
[STEP 1] Auto-Detect → Scan config/skills/
[STEP 2] Extract Metadata → Baca SKILL.md, data/, manifest.json
[STEP 3] Gap & Conflict Check → 5-point checklist
[STEP 4] Generate Report → Output ke user
[STEP 5] User Confirm → Y/n
[STEP 6] Auto-Integrate → Copy files, merge triggers, update index
[STEP 7] Notify User → "[SKILL INTEGRATED] X v1.0 aktif"
```

> Detail lengkap: `config/skills/integration-checker.md`


---

## §4K. Visual Design Pipeline (UUPM + Taste-Skill Enforcement) <!-- anchor:4K -->

> **Kapan di-load:** Saat saklar `redesign` aktif, saat `visual-gate` auto-trigger, atau saat buat halaman baru.
> **Sumber:** `gemini.md §VISUAL RULES` → section ini → `taste-skill-bridge/` → `ui-ux-pro-max/data/`

### §4K.1 Visual Task Detection (Kapan Pipeline Ini Aktif)

AI SEDANG mengerjakan visual task jika SALAH SATU kondisi terpenuhi:
1. Menulis/mengedit file CSS, SCSS, atau style block dalam komponen
2. Menulis HTML/JSX/Blade/PHP dengan class/style yang mengatur layout, warna, font, spacing
3. Membuat halaman baru atau memodifikasi struktur section halaman existing
4. User memakai saklar `redesign` atau alias-nya

**Jika terdeteksi → WAJIB jalankan pipeline berikut secara URUT:**

### §4K.2 Mandatory Pipeline (6 Gate — Tidak Boleh Skip)

```
GATE 1 — [Design Read]     : Baca taste-skill-bridge/SKILL.md (router) → ESSENTIAL.md
                              Output: [Design Read] + [DNA Source]

GATE 2 — [Three Dials]     : Set V/M/D berdasarkan tabel inferensi di ESSENTIAL.md §1
                              Output: dials: V=[n] M=[n] D=[n]

GATE 3 — [UUPM Search]     : Jalankan SALAH SATU:
                              A) python search.py "[industri] [vibe]" --design-system
                              B) Direct-Read: grep_search industri di colors.csv → styles.csv → typography.csv
                              Output: [UUPM Source] Palet + Style + Font pair

GATE 4 — [Layout Intel]    : grep_search industri/tipe proyek di ui-reasoning.csv
                              (WAJIB dijalankan mandiri via grep_search — search.py TIDAK mencari file ini!)
                              Ambil: Recommended_Pattern, Decision_Rules, Anti_Patterns
                              Jika landing page → grep juga landing.csv untuk Section Order
                              Output: [Layout Intel] Pattern=[X] | Anti-Patterns=[Y]

GATE 5 — [Rhythm Score]    : Susun section order dengan treatment visual A/B/C/D/E
                              Validasi: tidak ada 3 treatment berturut sama
                              Output: [RHYTHM SCORE] per section

GATE 6 — [Write Code]      : BARU BOLEH menulis kode setelah Gate 1-5 selesai
                              Semua warna via var(--vibe-*), semua dari UUPM output
```

**HARD BLOCK:** FORBIDDEN menulis `:root { --vibe-*` tanpa output [UUPM Source] terlebih dahulu.
**HARD BLOCK:** Gate 4 `ui-reasoning.csv` WAJIB dieksekusi via `grep_search` — dilarang berasumsi sudah tercakup di `search.py`.
**HARD BLOCK:** FORBIDDEN menulis `<section>` atau layout HTML tanpa output [RHYTHM SCORE] terlebih dahulu.

### §4K.3 Direct-Read CSV Protocol (Jika Python Tidak Tersedia / Eksekusi Mandiri)

> ⚠️ **PATH RESOLUTION (SearchPath Wajib Absolute):**
> Tool `grep_search` mewajibkan `SearchPath` absolut. Gunakan direktori dataset UUPM:
> - **Global Path (Default di semua proyek):** `$HOME/.gemini/config/skills/ui-ux-pro-max/data/` (Windows: `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\`)
> - **Local Path (Khusus repo Brainvibes):** `<workspace-root>/config/skills/ui-ux-pro-max/data/`

Lakukan pembacaan data langsung via `grep_search` dengan langkah berikut:

```
1. SearchPath: "<UUPM_DATA>\colors.csv" | Query: "[industri/product_type]"
   → Ambil: Primary, Accent, Background hex → konversi ke oklch() → --vibe-*
2. SearchPath: "<UUPM_DATA>\styles.csv" | Query: "[vibe/keyword]"
   → Ambil: Design System Variables + Effects & Animations
3. SearchPath: "<UUPM_DATA>\typography.csv" | Query: "[mood/category]"
   → Ambil: Font Pairing (Heading + Body + CSS Import Google Fonts)
4. SearchPath: "<UUPM_DATA>\ui-reasoning.csv" | Query: "[UI_Category/industri]"
   → Ambil: Recommended_Pattern, Decision_Rules, Anti_Patterns (Wajib — tidak di-cover oleh search.py!)
5. Jika Landing Page: SearchPath: "<UUPM_DATA>\landing.csv" | Query: "[tipe_bisnis]"
   → Ambil: Section Order & Primary CTA placement
```

Catat: `[UUPM Source] Direct-Read CSV — colors.csv, styles.csv, typography.csv, ui-reasoning.csv (Path: <UUPM_DATA>)`

### §4K.4 Saklar `redesign` Execution Protocol

Saat saklar `redesign` di-trigger:
1. Baca `app-context.md §PALETTE` → catat DNA saat ini
2. Jalankan Existing Page Audit (taste-skill-bridge/DETAILED.md §0.D)
3. Jalankan Anti-Cosmetic-Redesign check (§0.G) → WAJIB ubah minimal 2 dari 4 dimensi
4. Jika redesign ke-2+ → STOP, tampilkan 3 opsi layout berbeda, tunggu user pilih
5. Jalankan Gate 1-6 di atas
6. Setelah kode selesai → jalankan §4I Visual Self-Check

### §4K.5 Visual DNA Reverse-Engineering Protocol (Proyek Lanjutan / Sedang Berjalan)

> **Kapan Digunakan:** Saat `awal lanjut`, `awal konversi`, atau saat `/.docs/design-system.md` belum ada pada proyek eksisting.
> **Prinsip Utama (Anchor Immutability):** Halaman Utama (Landing Page / Homepage) adalah **Master Anchor**. Semua sub-halaman WAJIB tunduk dan mewarisi DNA halaman utama.

**Langkah Ekstraksi Visual DNA (5 Tahap):**
1. **Identifikasi Berkas Halaman Utama (Anchor Priority Hierarchy):**
   - *Tier 1 (Public Anchor):* `index.*`, `landing.*`, `home.*`, `page.tsx` (root)
   - *Tier 2 (App/Dashboard Anchor):* `layout.*`, `app.*`, `dashboard.*`, `main.*`
   - *Tier 3 (Auth/Entry Anchor):* `login.*`, `auth.*` (fallback terakhir)
2. **Identifikasi Berkas Styling Global:**
   - Cari berkas CSS/SCSS global (misal `styles.css`, `global.css`, `app.css`).
   - Cari deklarasi `:root` variables, `@theme`, atau konfigurasi Tailwind (`tailwind.config.js`).
3. **Ekstraksi Token Dominan:**
   - *Warna:* Background dominan, Surface (card), Teks utama, Accent 1 (CTA button), Accent 2.
   - *Tipografi:* Heading font vs Body font (dari `@import`, tag `<link>` Google Fonts, atau CSS font-family).
   - *Geometri:* `border-radius` dominan pada tombol dan kartu (`0px` / `8px` / `9999px`).
   - *Spacing:* Nilai grid margin dan padding section utama.
4. **Generate / Sinkronisasi `/.docs/design-system.md`:**
   - Tulis seluruh hasil ekstraksi ke `/.docs/design-system.md` sesuai format baku.
   - Perbarui snapshot `app-context.md §PALETTE`.
5. **Enforcement Sub-Halaman (Anti-Drift):**
   - Setiap kali AI membuat atau mengedit sub-halaman (detail, auth, checkout, blog, dashboard), AI **FORBIDDEN** menciptakan palet atau font baru.
   - AI **WAJIB** membaca `/.docs/design-system.md` dan menggunakan token yang telah di-anchor dari halaman utama.

---

## §4I. Visual Self-Check Protocol <!-- anchor:4I -->

> **Kapan di-load:** Setelah task visual selesai, sebelum declare done.
> **Sumber:** `taste-skill-bridge/REFERENCE.md` (pre-flight checklist)

### §4I.1 Mandatory Self-Check (Sebelum Declare Done)

AI REQUIRED menjalankan checklist berikut dan mencetak hasilnya:

```
[TASTE-SKILL PRE-FLIGHT]
DNA: [✅|❌] | File: [✅|❌] | Typography: [✅|❌] | Hero: [✅|❌]
Center-bias: [✅|❌] | Eyebrow: [✅|❌] | CTA: [✅|❌] | Contrast: [✅|❌]
Shape: [✅|❌] | Tokens: [✅|❌] | Images: [✅|❌] | Mobile: [✅|❌]
Rhythm: [✅|❌] | Copy-slop: [✅|❌] | UUPM-sourced: [✅|❌]
```

### §4I.2 Copy Anti-Slop Verification

Sebelum declare done, AI REQUIRED scan semua visible text di output dan:
1. Cek tidak ada kata dari Copy Blocklist (`gemini.md §VISUAL RULES #23`)
2. Cek tidak ada eyebrow/capsule di halaman auth
3. Cek headline ≤ 8 kata, subtext ≤ 25 kata
4. Cek tidak ada fake-precise numbers tanpa real data

Jika ada pelanggaran → FIX sebelum declare done. FORBIDDEN declare done dengan ❌ di pre-flight.

### §4I.3 Model-Specific Override

Jika terdeteksi model Gemini Flash (atau model dengan tendency AI slop):
- Baca `taste-skill-bridge/MODEL_HINTS.md` (1x per sesi, ~40 baris)
- Apply override tambahan yang spesifik model
- Prioritaskan Bento/Staggered/Split layout daripada centered






