<!-- WORKSPACE COPY — jika file ini sudah di-load sebagai global rule, AI gunakan cached copy -->
# AGENTS.md — Global AI Behavior Rules (Antigravity IDE)
# Path: $HOME/.gemini/AGENTS.md (Windows: %USERPROFILE%\.gemini\AGENTS.md)
# Berlaku untuk: Gemini CLI | Antigravity IDE | Cursor | Copilot (semua sesi, semua proyek)
# Rules ini adalah L1 In-Memory Dispatcher & Runtime Rules

---

## §0. DYNAMIC PATH FALLBACK RESOLVER
AI REQUIRED menyelesaikan path file instruksi dan templates dengan urutan:
1. **Workspace Root:** `./[file]` (jika bekerja di repo brainvibes)
2. **Global Fallback:** `$HOME/.gemini/[file]` (Linux/WSL/macOS) atau `%USERPROFILE%\.gemini\[file]` (Windows native)
*Contoh:* Jika `gemini-templates.md` tidak ada di workspace saat ini, AI otomatis memuat `$HOME/.gemini/gemini-templates.md`.

---

## §1. SAKLAR UTAMA (UNIFIED L1 DISPATCH TABLE)
*(Tabel routing in-memory. AI langsung mengenali saklar tanpa tool call awal.)*

| Saklar | Alias Populer | Aksi Utama | Fast-Path / File yang Dimuat |
|---|---|---|---|
| `awal baru` | `proyek baru`, `start` | Setup proyek baru dari nol | Load `gemini-templates.md §2A`, `prd-template.md` |
| `awal lanjut` | `lanjut`, `resume` | Fast resume sesi aktif (Dual-Mode) | **Fast-Path L1** (Baca `app-context.md` + `git status --short`) |
| `awal konversi` | `migrasi`, `convert` | Legacy audit & 9 fase migrasi | Load `gemini-templates.md §2C`, `prd-template.md` |
| `tambah fitur` | `fitur baru` | Penambahan fitur incremental | Load `app-context.md §NEXT`, `prd.md §2` |
| `baca error` | `debug`, `error`, `perbaiki` | YOLO Debugging & issue tracking | Load `gemini-templates.md §5`, `issues.md` |
| `lanjut dari sini` | `recovery`, `balik lagi` | Mid-session context recovery | **Fast-Path L1** (Baca `app-context.md` + `git status --short`) |
| `status proyek` | `status`, `ringkasan` | Quick brief status (max 10 baris) | **Fast-Path L1** (Baca `app-context.md`) |
| `analisa kualitas` | `audit kode`, `quality` | Code review & smells check | Load `app-context.md`, `.docs/` |
| `cek komponen` | `cek kom`, `audit security` | OWASP + Secure Patterns audit | Load `security-patterns/data/`, `app-context.md` |
| `pentest*` | `pentest cepat`, `dast` | Dynamic App Security Testing | Load `security-patterns/data/`, `pentest-strix/` |
| `redesign` | `ubah desain`, `ubah tampilan` | Anti-slop visual overhaul | Load `taste-skill-bridge/ESSENTIAL.md`, UUPM data |

---

## §2. FAST-PATH EXECUTION PROTOCOL (SAKLAR RINGAN)

### A. Fast-Path `awal lanjut` & `lanjut dari sini` (Dual-Mode: Todo vs Ad-Hoc):
1. **Baca Snapshot:** Muat `app-context.md` (1 tool call).
2. **Proactive Drift Detection:** Jalankan `git status --short` (0.01 detik).
   - Jika ada file kode berstatus `M` / `??` yang belum tercatat: catat sebagai uncommitted drift.
3. **Pemeriksaan Mode Kerja:**
   - **Mode A (Todo Aktif):** Jika `todo.md` memiliki task `[/]` atau `[ ]`, laporkan task aktif dan lanjutkan fase.
   - **Mode B (Ad-Hoc / Fase Selesai):** Jika `todo.md` sudah selesai 100% atau tidak aktif, jangan paksakan grep todo. Laporkan entry log terakhir di `handover.md §10` / uncommitted git changes.
4. **Respon:** Cetak status ringkas (maks 3-5 baris) dalam Bahasa Indonesia dan langsung siap menerima instruksi ad-hoc.

### B. Fast-Path `status proyek`:
- Baca `app-context.md` dan sajikan ringkasan state proyek (maks 10 baris) tanpa memuat template eksternal.

---

## §3. SESSION INIT PROTOCOL (Prioritas Baca Awal)
AI REQUIRED mematuhi urutan Prioritas Baca Awal (Step -1 s/d Step 2) di `gemini.md §SESSION PROTOCOL`.
*AI FORBIDDEN membaca prd.md penuh, handover.md penuh, atau design-system.md di session init.*

---

## §4. §LOAD PROTOCOL (ON-DEMAND FILES LOADING)
AI REQUIRED mematuhi load protocol berikut untuk menghemat token dan context window:
- **`gemini.md` (Core):** Dibaca sistem di awal sesi / spesifikasi induk. Jangan di-load ulang secara penuh.
- **`gemini-execution.md`:** Wajib di-load via `view_file` (ambil section spesifik) saat AI mulai menulis kode, konfigurasi backend, setup database, atau memproses upload file.
- **`gemini-templates.md`:** Wajib di-load via `view_file` hanya saat saklar makro (`awal baru`, `awal konversi`, `baca error`, `redesign`) dipicu, saat membuat `todo.md`, update `handover.md`, atau melakukan git commit.
- **Auto-Ignore Legacy:** → Lihat `gemini-execution.md §3.A` (Auto Workspace Verification).

---

## §5. §BROWSER TOOL GATE (ABSOLUTE ENFORCEMENT — INLINE)
⛔ **FORBIDDEN** memanggil `browser_subagent` ke `localhost`, `127.0.0.1`, atau port dev lokal untuk tujuan apapun:
- Verifikasi build, cek tampilan, render check, lihat DOM, screenshot lokal, scratchpad debug.
- **Alternatif WAJIB:** `read_url_content` ke localhost URL.
- **Exception tunggal:** User mengetik permintaan eksplisit di turn tersebut (contoh: "buka browser ke localhost:3100").
- **Sebelum SETIAP `browser_subagent` call:** Wajib cetak `[Browser Gate] Alasan: [justifikasi]`. Tanpa log = VIOLATION.
- **Pelanggaran** = cetak `[SCRATCHPAD BLOCKED]`, batalkan call, STOP, tunggu instruksi user.
- Supplementary detail: `gemini-execution.md §4.H`

**Rule Priority:** Critical > Important > Nice-to-have. Detail: `gemini-execution.md §4M.H`

---

## §6. SKILLS REGISTRY (Auto-Discovery)
| Skill Name | Path | Auto-Trigger Keywords | Read Protocol |
|---|---|---|---|
| `ui-ux-pro-max` | `config/skills/ui-ux-pro-max/` | awal baru, redesign, buat halaman, animasi, GSAP | Baca ESSENTIAL.md (50 baris) → DETAILED.md jika complex |
| `taste-skill-bridge` | `config/skills/taste-skill-bridge/` | redesign, buat halaman, UI baru, landing page, ubah bentuk, ubah tampilan, ubah layout, perbaiki halaman, redesign visual, ubah visual | **WAJIB baca ESSENTIAL.md PENUH** → DETAILED.md jika complex → REFERENCE.md untuk pre-flight |
| `lessons-learned` | `config/skills/lessons-learned/` | baca error, pernah coba, jangan ulangi | Baca SKILL.md deskripsi → data/anti-patterns.md jika trigger |
| `code-snippets` | `config/skills/code-snippets/` | buat form, buat navbar, buat modal, buat toast | Baca SKILL.md deskripsi → data/ jika perlu snippet |
| `database-patterns` | `config/skills/database-patterns/` | desain database, migration, seeder, query | Baca SKILL.md deskripsi → data/ jika perlu pattern |
| `git-workflow` | `config/skills/git-workflow/` | commit, push, branch, merge, PR | Baca SKILL.md deskripsi → data/ jika perlu workflow |
| `accessibility-audit` | `config/skills/accessibility-audit/` | audit a11y, screen reader, WCAG, cek a11y | Baca SKILL.md deskripsi → checklist jika audit |
| `performance-audit` | `config/skills/performance-audit/` | audit performa, lighthouse, LCP, web vitals | Baca SKILL.md deskripsi → checklist jika audit |
| `deployment-checklist` | `config/skills/deployment-checklist/` | deploy, hosting, production, go live | Baca SKILL.md deskripsi → checklist jika deploy |
| `security-patterns` | `config/skills/security-patterns/` | cek komponen, cek kelengkapan, verifikasi kode, cek regulasi, perbaiki keamanan, fix vulnerability | Baca SKILL.md deskripsi → data/known-vulns.md + data/secure-patterns.md |
| `pentest-strix` | `config/skills/pentest-strix/` | **pentest, pentest cepat, pentest mendalam, pentest api, pentest auth, dast, dynamic scan, strix scan** | Baca SKILL.md deskripsi → docker jika pentest |
| `quick-scaffold` | `config/skills/quick-scaffold/` | buat komponen, buat model, buat controller, buat form, scaffold, generate file | Baca SKILL.md deskripsi → data/ jika perlu scaffold |

*Mekanisme Smart Skill Integration (SSI) diatur di `gemini-execution.md §4N`.*

---

## §7. SECURITY-AWARE CODING & WEB SEARCH (Cross-Reference)
- **Security-Aware Coding:** Ketika menulis kode auth/db/input/upload/API, AI wajib secara SILENT membaca `security-patterns` data. Detail di `gemini.md §1 STANDARD #5` dan `gemini-execution.md §3.C`.
- **Web Search Protocol:** Protokol pencarian informasi web diatur di `gemini.md §1 HARD BLOCK #9`.
