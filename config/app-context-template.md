<!--
  ╔══════════════════════════════════════════════════════════════════════╗
  ║  APP-CONTEXT MASTER TEMPLATE — Antigravity IDE Global Config        ║
  ║  Path: C:\Users\ClasNet\.gemini\config\app-context-template.md      ║
  ║  Tujuan: Template acuan AI saat generate .docs/app-context.md        ║
  ║  AI: Isi semua placeholder [SEPERTI_INI] dengan nilai aktual proyek  ║
  ║  Target ukuran output: ≤5 KB per proyek                              ║
  ║  Version: 2.0 (v4.0.0 — added §VISUAL_GATE & §FLOWS, updated docs)   ║
  ╚══════════════════════════════════════════════════════════════════════╝

  CARA GENERATE:
  1. Baca prd.md §1–§3 + handover.md §2 + todo.md
  2. Resolve Context7 IDs untuk stack di §IDENTITY
  3. Isi semua placeholder dengan data aktual (bukan template kosong)
  4. Simpan ke [PROJECT_ROOT]/.docs/app-context.md
  5. Tambahkan .docs/app-context.md ke .gitignore HANYA jika proyek minta privacy
-->

# [APP_NAME] — App Context
> Stack: [STACK_ONELINER] | Fase: [FASE_N_DARI_TOTAL] | Updated: [YYYY-MM-DD HH:MM]

---

## §IDENTITY
<!-- Distilasi dari prd.md §1 + §2. Isi nilai aktual — bukan template -->
| Key | Value |
|-----|-------|
| **App Name** | [Nama Aplikasi] |
| **App Type** | [Web App / SaaS / E-Commerce / Company Profile / Portal / dll.] |
| **Scale** | [Internal / Desa / Kabupaten / Nasional / Publik] |
| **Core Value** | [Satu kalimat fungsi utama] |
| **Frontend** | [HTML-CSS-JS / Next.js App Router / React Vite / Vue / dll.] |
| **Backend** | [PHP Native / Laravel / Express / Hono / Supabase / Pure Frontend] |
| **Database** | [MySQL / PostgreSQL+Prisma / SQLite / State Simulator] |
| **Styling** | [Vanilla CSS / Tailwind CSS v4 / Bootstrap 5] |
| **Package Mgr** | [npm / pnpm / yarn / bun / composer] |
| **Dev Port** | [PORT — baca dari handover.md §2 atau .env] |
| **Env Keys** | [KEY1, KEY2, KEY3 — nama key saja, TANPA value] |
| **Project Root** | [Absolute path proyek] |

---

## §DESIGN
<!-- Distilasi dari prd.md §3 atau design-system/MASTER.md. Tulis HEX AKTUAL bukan placeholder -->
```css
/* Active Design Tokens — Resolved */
--vibe-background: [#HEX];     /* Palet [No.]: [Nama Kluster] */
--vibe-surface:    [#HEX];
--vibe-text-main:  [#HEX];
--vibe-primary:    [#HEX];
--vibe-secondary:  [#HEX];
--vibe-error:      #FF3E3E;
--vibe-success:    #00E676;
--vibe-warning:    #FFD600;
--vibe-radius:     [0px / 6px / 8px / 9999px];
--vibe-font-main:  '[Font Name]', sans-serif;
--vibe-font-head:  '[Heading Font]', serif;
--vibe-transition: all 0.2s ease-in-out;
```
- **Palette No.:** [1–15 atau UUPM] — **[Nama Kluster]**
- **Theme Mode:** [Static Light / Static Dark / Dynamic Toggle]
- **Nav Model:** [Top Sticky / Vertical Sidebar / Floating Dock]
- **Icon Set:** [Phosphor / Heroicons / Lucide / Tabler]
- **Box Radius:** [Sharp 0px / Rounded 6–8px / Pill 9999px]

---

## §VISUAL_GATE
<!-- 10 aturan visual anti-slop — embedded agar AI SELALU membaca setiap sesi -->
icon_lib=[phosphor|heroicons|lucide|tabler]
🔴 FORBIDDEN: ikon SVG mentah (hand-rolled) → gunakan icon_lib di atas
🔴 FORBIDDEN: border/outline/stroke/shadow pada logo → logo as-is tanpa dekorasi
🔴 FORBIDDEN: hardcode hex/rgb/hsl di CSS/JS → REQUIRED gunakan var(--vibe-*)
🔴 FORBIDDEN: font-family: Inter tunggal → heading=[heading font] body=[body font]
🔴 FORBIDDEN: background: white / color: black hardcode
🔴 FORBIDDEN: spacing acak (13px, 19px) → kelipatan 8pt grid
🔴 FORBIDDEN: mencampur lebih dari 1 icon library dalam satu proyek
🔴 REQUIRED: output [Design Read] + Three Dials sebelum halaman/komponen baru
🔴 REQUIRED: kontras elemen teks utama terhadap bg/surface ≥ 4.5:1
🔴 REQUIRED: panggil view_file pada taste-skill-bridge/SKILL.md sebelum kode visual

---

## §FLOWS
<!-- Per-feature data flow — 1 baris per fitur utama (distilasi dari data flow) -->
<!-- Format: [Nama Fitur]=Step1→Step2→...→StepN -->
[Login]=Form→POST /auth/login→verify→JWT→redirect /dashboard
[Register]=Form→POST /auth/register→validate→hash→insert→redirect
[Example]=Form→POST /api/action→validate→process→update DB→response

---

## §STATE
<!-- Distilasi dari handover.md + todo.md. Update setiap 5–6 task selesai -->
- **Current Phase:** Fase [N] dari [TOTAL] — [Nama Fase Aktif]
- **Dev Server:** `[start command]` → `http://localhost:[PORT]`
- **Active Blockers:** [None / Deskripsi blocker jika ada]
- **prd_hash:** [8-char hash atau last-modified: YYYY-MM-DD HH:MM] — deteksi drift jika diubah manual
- **key_files:** prd=[modified], handover=[modified], todo=[modified]

**Last 5 Completed:**
- [x] [Task selesai ke-5 terbaru]
- [x] [Task selesai ke-4]
- [x] [Task selesai ke-3]
- [x] [Task selesai ke-2]
- [x] [Task selesai ke-1 — paling baru]

**Next 3 Tasks:**
- [ ] [Task berikutnya 1]
- [ ] [Task berikutnya 2]
- [ ] [Task berikutnya 3]

---

## §C7
<!-- Pre-resolved Context7 Library IDs — AI gunakan langsung untuk query-docs() -->
<!-- Tidak perlu resolve-library-id() lagi saat baca file ini -->

**Primary Stack:**
- `/[org/repo]` — [Nama Library] v[versi]
- `/[org/repo]` — [Nama Library] v[versi]

**Secondary:**
- `/[org/repo]` — [Nama Library]

---

## §RULES
<!-- HANYA aturan HARD BLOCK yang relevan untuk stack proyek ini -->
<!-- Filter dari gemini.md §1 — tidak perlu salin semua 98KB -->

🔴 **FORBIDDEN:**
- `migrate:fresh` / perintah reset DB destruktif → gunakan `migrate --force`
- Truncate kode dengan `// kode lainnya...` → tulis UTUH
- Ubah stack/palet/🔒 IMMUTABLE tanpa `[OVERRIDE IDENTITY: ...]`
- Hardcode hex di CSS/JS → REQUIRED gunakan `--vibe-*` variables
- Update semua dependencies sepihak saat debug

🟡 **GATE (perlu izin):**
- Git commit: unstage `.env*` dan metadata AI dulu (5 Tahap Git Commit)
- Debug mode: tulis `issues.md` → STOP → minta izin sebelum ubah kode
- Legacy purge: dry-run log sebelum hapus `/.legacy/`

⬜ **STANDARD:**
- Terminal: inject `CI=true` (Linux) atau `$Null |` (Windows PowerShell)
- Port conflict: kill PID atau increment port + update `.env`
- SEO: semua HTML REQUIRED punya title, meta desc, canonical, OG tags
- Handover trigger: setiap 5–6 task selesai → update handover.md + app-context.md

---

## §DOCS
<!-- Pointer ke file detail — AI load HANYA jika task spesifik membutuhkannya -->

| File | Load Kapan |
|------|-----------|
| `../prd.md` | Full PRD, core identity, atau feature list lengkap |
| `../handover.md` | Full log sesi, error history, atau rollback state |
| `../todo.md` | Seluruh task list atau tandai task selesai |
| `./architecture.md` | Macro data flow (Presentation -> Middleware -> Storage) |
| `./api-spec.md` | Endpoint list, request/response spec, auth flow |
| `./database.md` | Schema lengkap, relasi tabel, migration history |
| `./routes.md` | Peta routes aktif (Frontend & API) |
| `./dependency-graph.md` | Critical files, high-impact files, circular deps |
| `./issues.md` | Bug tracker — FIFO max 10 RESOLVED history + OPEN/IN_PROGRESS |
| `./design-system/MASTER.md` | Design tokens lengkap, component specs, spacing system |
| `./design-system/pages/[page].md` | Override design untuk halaman spesifik |

---
<!--
  METADATA
  Template Version: 2.0 (v4.0.0 — added §VISUAL_GATE & §FLOWS, updated docs blueprint)
  Source: %USERPROFILE%\.gemini\config\app-context-template.md
  Engine: Antigravity IDE — §APP Protocol v2.0
  Update trigger: Setiap handover cycle (5–6 task) atau perubahan major stack/design
-->
