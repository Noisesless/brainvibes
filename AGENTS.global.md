# AGENTS.md — Global AI Behavior Rules (Antigravity IDE & Gemini CLI)
# Path: $HOME/.gemini/AGENTS.md (Windows: %USERPROFILE%\.gemini\AGENTS.md)
# L1 In-Memory Dispatcher & Runtime Rules (Universal across all sessions & projects)

---

## §0. DYNAMIC PATH FALLBACK RESOLVER
Urutan resolusi path berkas instruksi dan template:
1. **Workspace Root:** `./[file]` (jika bekerja di repo lokal)
2. **Global Fallback:** `$HOME/.gemini/[file]` (Linux/macOS) atau `%USERPROFILE%\.gemini\[file]` (Windows)
*Contoh:* Jika `gemini-templates.md` tidak ada di workspace, AI memuat dari path global.

---

## §1. SAKLAR UTAMA (UNIFIED L1 DISPATCH TABLE)
*(In-Memory Routing Table — Kenali saklar tanpa tool call awal)*

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
| `update docs` | `buat docs`, `generate docs`, `dokumentasi`, `buat dokumentasi`, `update dokumentasi` | Buat/update semua 9 file `.docs/` dari scan codebase | Load `app-context.md`, `gemini-execution.md §4N.G` |

---

## §2. FAST-PATH EXECUTION PROTOCOL (SAKLAR RINGAN)

### A. Fast-Path `awal lanjut` & `lanjut dari sini` (Dual-Mode: Todo vs Ad-Hoc):
1. **Baca Snapshot:** Muat `app-context.md` (1 tool call).
2. **Proactive Drift Detection:** Jalankan `git status --short`.
   - Catat uncommitted drift jika ada file kode `M` / `??` yang belum tercatat.
3. **Pemeriksaan Mode Kerja:**
   - **Mode A (Todo Aktif):** Jika `todo.md` memiliki task `[/]` atau `[ ]`, laporkan task aktif dan lanjutkan fase.
   - **Mode B (Ad-Hoc / Fase Selesai):** Jika `todo.md` selesai 100% atau tidak aktif, laporkan log terakhir di `handover.md §10` / uncommitted git changes.
4. **Respon:** Cetak status ringkas (maks 3-5 baris) dalam Bahasa Indonesia, siap menerima instruksi.

### B. Fast-Path `status proyek`:
- Baca `app-context.md` dan sajikan ringkasan state proyek (maks 10 baris) tanpa memuat template eksternal.

---

## §3. §BROWSER TOOL GATE (ABSOLUTE ENFORCEMENT — INLINE)
⛔ **FORBIDDEN** memanggil `browser_subagent` ke `localhost`, `127.0.0.1`, atau port dev lokal untuk tujuan apapun:
- Verifikasi build, cek tampilan, render check, lihat DOM, screenshot lokal, scratchpad debug.
- **Alternatif WAJIB:** `read_url_content` ke localhost URL.
- **Exception tunggal:** User mengetik permintaan eksplisit di turn tersebut (contoh: "buka browser ke localhost:3100").
- **Sebelum SETIAP `browser_subagent` call:** Wajib cetak `[Browser Gate] Alasan: [justifikasi]`. Tanpa log = VIOLATION.
- **Pelanggaran** = cetak `[SCRATCHPAD BLOCKED]`, batalkan call, STOP, tunggu instruksi user.

---

## §4. POINTER ATURAN SISTEM (SINGLE SOURCE OF TRUTH)
Untuk menghindari duplikasi token, aturan teknis mendalam didelegasikan ke file induk:
- **Session Init & Load Protocol:** Lihat `gemini.md §SESSION PROTOCOL` & `§LOAD PROTOCOL`.
- **Universal Laws & Visual Rules:** Lihat `gemini.md §1` & `gemini.md §VISUAL RULES`.
- **Eksekusi Teknis, DB, Auth & Build:** Lihat `gemini-execution.md`.
- **Anti-Bloat & Pragmatic Output:** Lihat `.agents/rules/anti-bloat-code.md` & `taste-skill-bridge/COPY_RULES.md`.
- **Skills Registry:** Auto-discovery via `config/skills/` (detail di `gemini-execution.md §4N`).
