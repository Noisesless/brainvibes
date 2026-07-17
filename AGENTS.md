# AGENTS.md — Global AI Behavior Rules (Antigravity IDE)
# Path: %USERPROFILE%\.gemini\AGENTS.md
# Berlaku untuk: Gemini CLI | Antigravity IDE | Cursor | Copilot | OpenCode (semua sesi, semua proyek)
# Rules ini MENAMBAH, bukan menggantikan, gemini.md

---

## SESSION INIT PROTOCOL (Tambahan gemini.md §3A)

### Prioritas Baca Awal (Urutan Wajib — Setiap Sesi Baru)

```
Step -1 : Baca user-prefs.md     → $HOME/.gemini/user-prefs.md  [SILENT] (Windows: %USERPROFILE%\.gemini\user-prefs.md)
Step  0 : Baca app-context.md    → [workspace]/app-context.md   [SILENT, jika ada]
Step  1 : Baca prd.md §1-§3     → jika app-context.md tidak ada [SILENT]
Step  2 : Ambil task aktif       → grep [/] di todo.md         [SILENT]
```

FORBIDDEN: Membaca prd.md penuh, handover.md penuh, atau design-system.md
di session init — hanya baca yang dibutuhkan (selective context loading).

---

## VISUAL OUTPUT GATE — TASTE-SKILL & ANTI-SLOP ENFORCEMENT
(PROTECTED BY gemini.md §1 HARD BLOCK #7)

🔴 HARD BLOCK: SETIAP kali AI akan menulis/mengedit kode yang menyentuh LAYER VISUAL
(CSS, style, class, komponen UI, ikon, warna, font, spacing, layout, gambar, animasi),
aturan berikut BERLAKU OTOMATIS — tanpa peduli apa kalimat perintah user:

### Untuk SEMUA perubahan visual (besar maupun kecil):
1. Gunakan CSS token `var(--vibe-*)` — FORBIDDEN hardcode hex/rgb/hsl
2. Gunakan icon library proyek — FORBIDDEN ikon SVG mentah/hand-rolled
3. FORBIDDEN memberi border/outline/stroke pada logo — logo as-is tanpa dekorasi
4. FORBIDDEN `font-family: Inter` tunggal — wajib 2 font (heading + body)
5. FORBIDDEN `background: white` / `color: black` hardcode
6. FORBIDDEN spacing acak (13px, 19px) — gunakan kelipatan 8pt grid
7. FORBIDDEN mencampur lebih dari 1 icon library dalam satu proyek
8. Patuhi seluruh 16 aturan Anti-AI-SLOP di bawah ini
9. AI REQUIRED memberikan rekomendasi style singkat yang sesuai Visual DNA proyek
   (dari `prd.md §3 CORE IDENTITY LOCK` atau `app-context.md §PALETTE`)
   SEBELUM menulis kode perubahan visual

**Output WAJIB sebelum kode (untuk perubahan visual kecil):**
```
[Visual Gate] Perubahan: [deskripsi singkat] — token: [CSS token yang digunakan] — sesuai Visual DNA: ✅
```

### Untuk pembuatan halaman/komponen BARU atau REDESIGN — tambahan wajib:
1. Panggil `view_file` pada `$HOME/.gemini/config/skills/taste-skill-bridge/SKILL.md` (Windows: `%USERPROFILE%\.gemini\config\skills\taste-skill-bridge\SKILL.md`)
2. Baca Visual DNA proyek dari `prd.md §3` atau `app-context.md §PALETTE`
3. Keluarkan baris `[Design Read]` + Three Dials + `[Style Rec]` SEBELUM kode apapun
4. Jalankan UUPM Pipeline — `search.py` atau fallback `design-system.md`

**Output WAJIB sebelum kode (untuk pembuatan/redesign):**
```
[Design Read] Reading this as: [X] untuk [Y], vibe [Z], dials: V=[n] M=[n] D=[n]
[Style Rec] Rekomendasi: [style sesuai Visual DNA] — sumber: [UUPM/design-system.md/prd.md]
```

---

## USER-PREFS DEFAULTS (Fallback jika user-prefs.md tidak ditemukan)

Jika `user-prefs.md` tidak ada, gunakan defaults ini:
- Port: Vite=5173, Next.js=3100, PHP=8080
- Package Manager: npm
- Font: Inter + 1 heading font dari typography.csv UUPM
- Geometry: Rounded 8px
- Dark Mode: Dynamic Toggle Switch
- Output Mode: COMPACT
- context7 auto-trigger: next.js, laravel, tailwindcss, react, astro

---

## ANTI-SLOP ENFORCEMENT (16 ATURAN WAJIB UI)

1. ❌ FORBIDDEN warna `#6C63FF` (ungu AI), `#4CAF50` (hijau), `#2196F3` (biru) tanpa rekomendasi UUPM colors.csv
2. ❌ FORBIDDEN `font-family: Inter` tunggal tanpa heading font pair — wajib pairing dari UUPM typography.csv
3. ❌ FORBIDDEN `border-radius: 8px` hardcode — REQUIRED gunakan CSS token `--radius-md`
4. ❌ FORBIDDEN `box-shadow` generik — REQUIRED gunakan nilai dari `design-system.md §4`
5. ❌ FORBIDDEN `transition: all 0.3s ease` — REQUIRED gunakan `var(--vibe-transition)`
6. ❌ FORBIDDEN `background: white` atau `color: black` hardcode — REQUIRED gunakan token `--vibe-background` & `--vibe-text-main`
7. ❌ FORBIDDEN memilih palet tanpa memeriksa `colors.csv` UUPM terlebih dahulu
8. ❌ FORBIDDEN spacing acak (13px, 19px) — REQUIRED gunakan kelipatan 8pt grid (`design-system.md §6`)
9. ❌ FORBIDDEN Inter sebagai satu-satunya font tanpa heading pair
10. ❌ FORBIDDEN centered Hero jika DESIGN_VARIANCE > 4 — gunakan Split/Asymmetric
11. ❌ FORBIDDEN `h-screen` pada hero — REQUIRED `min-h-[100dvh]`
12. ❌ FORBIDDEN eyebrow label > 1 per 3 section
13. ❌ FORBIDDEN ikon SVG mentah (hand-rolled) — REQUIRED gunakan icon library proyek (`@phosphor-icons` > `@tabler/icons` > `@radix-ui`)
14. ❌ FORBIDDEN memberi border, outline, atau shadow pada logo — logo wajib as-is tanpa dekorasi
15. ❌ FORBIDDEN mencampur > 1 icon library dalam satu proyek — ONE icon family rule
16. ❌ FORBIDDEN menghasilkan output visual tanpa memeriksa kepatuhan visual gate ini

---

## §LOAD PROTOCOL (ON-DEMAND FILES LOADING)

AI REQUIRED mematuhi load protocol berikut untuk menghemat token dan context window:
- **`gemini.md` (Core):** Dibaca sistem di awal sesi. Jangan di-load ulang secara penuh.
- **`gemini-execution.md`:** Wajib di-load via `view_file` (ambil section spesifik) saat AI mulai menulis kode, konfigurasi backend, setup database, atau memproses upload file.
- **`gemini-templates.md`:** Wajib di-load via `view_file` hanya saat saklar makro (`awal baru`, `awal konversi`, `baca error`) dipicu, saat membuat `todo.md`, update `handover.md`, atau melakukan git commit.
- **Auto-Ignore Legacy:** AI **REQUIRED** secara otomatis mengecualikan folder `/.legacy/` dari pemindaian filesystem global (seperti `search_files` atau `grep_search`) agar tidak membuang token dan mencegah lag pembacaan, kecuali diperintahkan secara eksplisit oleh user.

---

## BROWSER TOOL GATE — Token Anti-Waste (Dari gemini-execution.md §3G-ter)

🔴 **HARD BLOCK:** FORBIDDEN memanggil `browser_subagent` tanpa justifikasi eksplisit.

### 🔴 PROTEKSI ABSOLUT SCRATCHPAD DOM (Binding ke user-prefs.md):
Baca `user-prefs.md [BROWSER_TOOL].scratchpad_dom` di session init.
Jika nilai = `FORBIDDEN`:
- AI **DILARANG KERAS** memanggil `browser_subagent` untuk tujuan APAPUN
  (termasuk: verifikasi visual, cek DOM, render SPA lokal, crawl localhost/127.0.0.1)
  KECUALI user secara **EKSPLISIT dan TERTULIS** memintanya di turn tersebut.
- Inisiatif mandiri AI menggunakan browser untuk verifikasi lokal = **PELANGGARAN FATAL**.
- Frasa berikut BUKAN justifikasi valid: "cek tampilan", "verifikasi build",
  "render check", "lihat DOM", "screenshot lokal", "pastikan render".

### Kondisi SATU-SATUNYA yang membolehkan `browser_subagent`:
1. Butuh klik / interaksi UI aktif (hanya URL eksternal)
2. Halaman butuh JavaScript / SPA rendering — **hanya berlaku untuk URL EKSTERNAL**
   (jika `scratchpad_dom = FORBIDDEN`: localhost/127.0.0.1 TETAP FORBIDDEN meski SPA)
3. Butuh login browser (session/cookie UI)
4. User **eksplisit** minta recording/demo video pada turn tersebut

### DEFAULT untuk semua kasus lain:
```
Cek halaman web       → read_url_content  (bukan browser_subagent)
Scratchpad / cek DOM  → read_url_content  (bukan browser_subagent)
Fetch docs library    → context7 MCP      (bukan search_web + browser)
Baca file lokal besar → view_file + range (bukan baca penuh)
```

### Output Wajib jika pakai browser_subagent:
```
[Browser Gate] Alasan: [tulis kondisi yang memenuhi syarat] → Proceed ✅
```

### Token Guard per Turn (sumber: user-prefs.md [AI_BEHAVIOR] + [BROWSER_TOOL]):
```
max_files_per_turn = 5         → FORBIDDEN buka > 5 file per turn
max_lines_per_read = 200       → FORBIDDEN view_file > 200 baris tanpa StartLine/EndLine
recording_default  = OFF       → FORBIDDEN auto-record tanpa permintaan user
scratchpad_dom     = FORBIDDEN → FORBIDDEN browser_subagent ke localhost/DOM tanpa trigger eksplisit user
browser_gate       = STRICT    → REQUIRED justifikasi [Browser Gate] sebelum browser_subagent
dom_read_default   = read_url  → DEFAULT cek DOM via read_url_content, bukan browser_subagent
```

---

## SKILLS REGISTRY (Auto-Discovery)

| Skill Name | Path | Auto-Trigger Keywords |
|---|---|---|
| `ui-ux-pro-max` | `config/skills/ui-ux-pro-max/` | awal baru, redesign, buat halaman |
| `taste-skill-bridge` | `config/skills/taste-skill-bridge/` | redesign, buat halaman, UI baru, landing page |
| `lessons-learned` | `config/skills/lessons-learned/` | baca error, pernah coba, jangan ulangi |
| `code-snippets` | `config/skills/code-snippets/` | buat form, buat navbar, buat modal, buat toast |
| `database-patterns` | `config/skills/database-patterns/` | desain database, migration, seeder, query |
| `git-workflow` | `config/skills/git-workflow/` | commit, push, branch, merge, PR |
| `accessibility-audit` | `config/skills/accessibility-audit/` | audit a11y, screen reader, WCAG, cek a11y |
| `performance-audit` | `config/skills/performance-audit/` | audit performa, lighthouse, LCP, web vitals |
| `deployment-checklist` | `config/skills/deployment-checklist/` | deploy, hosting, production, go live |
| `security-patterns` | `config/skills/security-patterns/` | analisa keamanan, scan keamanan, cek vulnerability, security audit, perbaiki keamanan, fix vulnerability |
| `pentest-strix` | `config/skills/pentest-strix/` | **pentest, pentest cepat, pentest mendalam, pentest api, pentest auth, dast, dynamic scan, strix scan** |
| `quick-scaffold` | `config/skills/quick-scaffold/` | buat komponen, buat model, buat controller, buat form, scaffold, generate file |

---

## SMART SKILL INTEGRATION (SSI) PROTOCOL

### Auto-Detect Skill Baru
AI REQUIRED scan `config/skills/` setiap sesi baru:
- Jika ada folder baru tanpa entry di `.skill-index.json` → trigger `[SKILL DETECT]`
- Baca `SKILL.md` → extract metadata (name, description, triggers)
- Jalankan **Gap & Conflict Check** (§2)

### Gap & Conflict Check (5-Point Checklist)
1. **Trigger Keywords Overlap** → COMBINE (tidak replace)
2. **Data Files Path Collision** → SKIP jika collision, REPORT ke user
3. **Logic/Functions Duplication** → SKIP jika duplicate, REPORT ke user
4. **Dependencies Missing** → INSTALL dependency jika belum ada
5. **Conflicts with Existing Skills** → REPORT ke user, tunggu konfirmasi

### Smart Merge Rules
| Conflict Type | Resolution | Example |
|---|---|---|
| Trigger keywords | COMBINE | `["baca error"] + ["pernah coba"] → ["baca error", "pernah coba"]` |
| Data files | SKIP if collision | `data/form-validation.md` sudah ada → skip |
| Logic/functions | SKIP if duplicate | `authenticate()` sudah ada → skip |
| Dependencies | INSTALL if missing | Butuh `security-patterns` → install dulu |

### Auto-Trigger Policy
- Default: **ON** setelah integrate
- User control: `disable auto-trigger <name>`, `enable auto-trigger <name>`, `test trigger <name> <keyword>`
- AI auto-activate skill saat trigger keyword terdeteksi di user message

### AI-Managed Index
- `.skill-index.json` di-maintain oleh AI (bukan user)
- Auto-update setelah integrate/remove skill
- Format: name, path, triggers, version, dependencies, conflicts, installed_at
- Timestamp: `last_updated` setiap ada perubahan

### Quality Analysis Trigger
- User ketik: `analisa kualitas brainvibes`
- AI scan: context poisoning risk, skill gaps, skill conflicts, performance bottlenecks, .docs staleness
- AI recommend: update existing skills, implement new skills, remove redundant skills, optimize high-cost skills, auto-update .docs

### Auto-Update .docs Protocol
- Trigger: Setiap 5-6 task selesai → AI auto-scan `.docs/`
- Checklist: architecture.md, api-spec.md, database.md, quality_review.md, routes.md, dependency-graph.md, issues.md
- Update jika ada perubahan di codebase, skip jika tidak ada
- Print: `[DOCS UPDATE] X files updated, Y files skipped`

> Detail lengkap: `config/skills/integration-checker.md`

---

## SECURITY-AWARE CODING — SILENT AUTO-TRIGGER

Ketika AI menulis kode yang mengandung konteks berikut, wajib baca
`security-patterns/data/known-vulns.md` + `security-patterns/data/secure-patterns.md`
secara SILENT sebelum menghasilkan kode:

**Konteks yang memicu silent read (case-insensitive):**
- Auth: login, register, password, session, token, jwt, oauth
- Database: query, select, insert, update, delete, mysqli, PDO, prisma, knex
- Input: form, $_POST, $_GET, $_REQUEST, req.body, req.params, req.query
- Upload: file upload, multer, move_uploaded_file, storage, bucket
- API: route, endpoint, middleware, controller, handler

**Perilaku wajib:**
1. Cek `known-vulns.md` — jika stack + konteks cocok dengan entry known vuln → HINDARI pattern tersebut
2. Cek `secure-patterns.md` — jika ada pattern aman untuk konteks ini → GUNAKAN langsung
3. FORBIDDEN melaporkan proses silent read ke user
4. FORBIDDEN meminta konfirmasi untuk menerapkan pattern aman — langsung terapkan

**Jika AI mendeteksi pola mirip vulnerability yang pernah ditemukan:**
Cetak 1 baris pasif di bawah kode:
```
⚠️ Pola ini mirip [VULN-NNN] — telah diterapkan fix preventif secara otomatis.
```

---

## WEB SEARCH PROTOCOL (MCP-based)

Ketika AI tidak tahu jawaban atau butuh info real-time (patuhi `user-prefs.md [ACTION_BEHAVIOR].web_search_enabled`):

**Priority Order:**
1. Cek context7 MCP dulu (dokumentasi library resmi)
2. Jika tidak ada → gunakan web_search MCP (jika tersedia)
3. Jika MCP search tidak tersedia → beri tahu user:
   `[WEB-SEARCH] Jawaban di luar training data saya. Silakan cek: [saran URL]`

**Aturan:**
- Selalu cantumkan sumber jika memberikan info dari web search
- FORBIDDEN mengarang URL, versi, atau dokumentasi
- Jika pakai web_search, output WAJIB:
  ```
  [INFO-SOURCE] Sumber: web_search — [judul sumber] (URL)
  ```

**Output jika MCP search tidak tersedia:**
```
[INFO-SOURCE] Sumber: manual — AI tidak memiliki akses web search saat ini.
```
