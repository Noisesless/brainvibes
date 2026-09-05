---
name: ui-ux-pro-max
description: |
  AI-powered design intelligence with 193 industry-specific color palettes,
  84 UI styles, 73 font pairings, 163 UI reasoning rules, 99 UX guidelines,
  36 landing page patterns, and 25 chart types across 17 tech stacks.
  Activates automatically when the user requests UI building,
  component creation, style/color/font/chart/UX recommendations or review.
  Runs the design intelligence pipeline silently before any design decision.
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis pada skenario:

| Skenario | Contoh Trigger | Mulai Dari |
|---|---|---|
| Proyek/halaman baru | "Buatkan landing page", "Build a dashboard" | Step 1 → Step 2 (design system) |
| Komponen baru | "Buat pricing card", "Tambah modal" | Step 3 (domain: style, ux) |
| Pilih gaya/warna/font | "Apa style cocok untuk fintech?", "Rekomendasikan palet" | Step 2 (design system) |
| Review UI existing | "Review halaman ini dari sisi UX", "Cek aksesibilitas" | Quick Reference checklist |
| Perbaiki UI bug | "Hover button rusak", "Layout geser saat load" | Relevant domain search |
| Dark mode | "Tambah dark mode" | Domain: style "dark mode" |
| Grafik/chart | "Tambah chart analytics dashboard" | Domain: chart |

## Pipeline Eksekusi (Urutan Wajib)

### Step 1 — Analisis Kebutuhan User
Ekstrak dari permintaan:
- **Tipe produk**: SaaS, E-commerce, Healthcare, Gaming, dll
- **Target pengguna**: B2B/B2C, usia, konteks penggunaan
- **Kata kunci gaya**: minimal, dark, vibrant, professional, dll

### Step 2 — Generate Design System (REQUIRED — Diam-diam)

**Opsi A — Python tersedia:**
```bash
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<tipe_produk> <industri> <kata_kunci>" --design-system
# Windows: python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "<tipe_produk> <industri> <kata_kunci>" --design-system
```

Output memberikan: palet warna (Primary, Accent, Background), gaya visual terbaik,
font pairing, efek CSS, dan checklist implementasi.

**Opsi B — Direct-Read CSV (Jika Python tidak tersedia/gagal):**
JANGAN skip desain. Lakukan manual CSV read via `grep_search` dengan `SearchPath` absolut:
- **Global Path:** `$HOME/.gemini/config/skills/ui-ux-pro-max/data/` (Windows: `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\`)
- **Workspace Path:** `<workspace-root>/config/skills/ui-ux-pro-max/data/`

```
1. grep_search SearchPath: "<PATH>\colors.csv" | Query: "[industri/Product Type]"
   → Ambil: Primary, Accent, Background, On Primary hex
   → Konversi ke oklch() → masuk ke --vibe-* tokens

2. grep_search SearchPath: "<PATH>\styles.csv" | Query: "[vibe/Keywords]"
   → Ambil: Design System Variables, Effects & Animation, Implementation Checklist
   → Gunakan CSS variables langsung di :root

3. grep_search SearchPath: "<PATH>\typography.csv" | Query: "[mood/Category]"
   → Ambil: Heading Font, Body Font, Google Fonts URL, CSS Import
   → Apply ke --vibe-font-head dan --vibe-font-main

4. grep_search SearchPath: "<PATH>\ui-reasoning.csv" | Query: "[UI_Category/industri]"
   → Ambil: Recommended_Pattern, Style_Priority, Decision_Rules, Anti_Patterns
   → Gunakan sebagai layout constraint (mencegah "main aman" — tidak ada di search.py!)

5. grep_search SearchPath: "<PATH>\landing.csv" | Query: "[Pattern Name/keywords]"
   → Ambil: Section Order, Primary CTA Placement, Conversion Optimization
   → Gunakan jika task = landing page
```

Catat sumber: `[UUPM Source] Direct-Read CSV — colors.csv, styles.csv, typography.csv, ui-reasoning.csv (SearchPath: <PATH>)`

### Step 3 — Domain Search Spesifik (Jika Dibutuhkan)
```bash
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<query>" --domain [color|style|typography|ux|chart|landing]
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<query>" --stack [laravel|nextjs|react|vue|astro|...]
```

### Step 4 — Konversi ke design-system.md Token
- Hex warna UUPM → oklch() → masukkan ke `--raw-palette-*` CSS variables
- Implementasikan dalam `@layer tokens { :root { ... } }` sesuai design-system.md §2
- CSS keywords dari `styles.csv` kolom "Design System Variables" → gunakan di komponen

### Step 5 — Cross-check via context7 (Sebelum Kode Ditulis)
Jika komponen menggunakan library eksternal (Chart.js, Next.js, dll):
- Resolve library ID via context7
- Query dokumentasi terbaru
- Prioritaskan sintaks context7 jika ada konflik dengan data statis UUPM

## Data Files Reference (14 file)

| File | Records | Content | Kapan Dibaca |
|---|---|---|---|
| `colors.csv` | 193 | Palet warna per industri (Primary, Accent, BG) | SELALU — Gate 3 |
| `styles.csv` | 84 | Gaya visual + CSS variables + checklist | SELALU — Gate 3 |
| `typography.csv` | 73 | Font pairing (Heading + Body + Google URL) | SELALU — Gate 3 |
| `ui-reasoning.csv` | 163 | Decision rules per industri + anti-patterns | SELALU — Gate 4 |
| `landing.csv` | 36 | Landing page patterns + section order | Jika landing page |
| `ux-guidelines.csv` | 99 | UX best practices per kategori | On-demand |
| `design.csv` | ~800 | Comprehensive design patterns | Complex task only |
| `charts.csv` | 25 | Chart type recommendations | Jika ada chart |
| `app-interface.csv` | ~50 | App interface patterns | On-demand |
| `google-fonts.csv` | ~1000 | Full Google Fonts database | Jika cari font baru |
| `icons.csv` | ~100 | Icon library recommendations | On-demand |
| `products.csv` | ~300 | Product-specific patterns | On-demand |
| `react-performance.csv` | ~50 | React performance patterns | React/Next.js only |
| `stacks/` | 17 | Stack-specific guidelines per framework | Stack search |

## Aturan Anti-AI-SLOP (HARD BLOCK)

Semua visual task wajib mematuhi 23 larangan Anti-AI-SLOP yang tercantum dalam:
- `gemini.md §VISUAL RULES` (18 larangan + 5 enforcement positif)
- `taste-skill-bridge/MODEL_HINTS.md` (model-specific overrides)

