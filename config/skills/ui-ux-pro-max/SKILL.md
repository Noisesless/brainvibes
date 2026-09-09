---
name: ui-ux-pro-max
description: |
  AI-powered design intelligence with 192 industry-specific color palettes,
  79 UI styles (50 active), 74 font pairings, 193 UI reasoning rules,
  119 UX guidelines, 17 GSAP motion presets, 35 landing page patterns,
  and 25 chart types across 22 tech stacks.
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
| Animasi/motion | "Tambah animasi scroll", "GSAP stagger" | Domain: gsap |

## Pipeline Eksekusi (Urutan Wajib)

### Step 1 — Analisis Kebutuhan User
Ekstrak dari permintaan:
- **Tipe produk**: SaaS, E-commerce, Healthcare, Gaming, dll
- **Target pengguna**: B2B/B2C, usia, konteks penggunaan
- **Kata kunci gaya**: minimal, dark, vibrant, professional, dll

### Step 2 — Generate Design System (REQUIRED — Diam-diam)

**Opsi A — Python tersedia (dengan Three Dials native):**
```bash
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<tipe_produk> <industri> <kata_kunci>" --design-system --variance <1-10> --motion <1-10> --density <1-10>
# Windows: python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "<tipe_produk> <industri> <kata_kunci>" --design-system --variance <1-10> --motion <1-10> --density <1-10>
```

Three Dials (opsional, default diinferensikan dari query):
- `--variance` : DESIGN_VARIANCE (1=centered/minimal → 10=bold/asymmetric)
- `--motion`   : MOTION_INTENSITY (1=subtle → 10=complex; melampirkan GSAP snippet dari motion.csv)
- `--density`  : VISUAL_DENSITY (1=spacious → 10=dense/dashboard; mengatur spacing scale)

Output memberikan: palet warna (16 semantic tokens: Primary, On Primary, Secondary, Accent/CTA,
Background, Foreground, Card, Muted, Border, Destructive, Ring), gaya visual terbaik,
font pairing, efek CSS, GSAP animation snippet, dan checklist implementasi.

**Persistence (opsional — simpan design system ke file):**
```bash
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<query>" --design-system --persist --output-dir "<project-root>" -p "Project Name"
# Dengan page override:
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<query>" --design-system --persist --output-dir "<project-root>" -p "Project Name" --page "dashboard"
```

**Opsi B — Direct-Read CSV (Jika Python tidak tersedia/gagal):**
JANGAN skip desain. Lakukan manual CSV read via `grep_search` dengan `SearchPath` absolut:
- **Global Path:** `$HOME/.gemini/config/skills/ui-ux-pro-max/data/` (Windows: `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\`)
- **Workspace Path:** `<workspace-root>/config/skills/ui-ux-pro-max/data/`

```
1. grep_search SearchPath: "<PATH>/colors.csv" | Query: "[industri/Product Type]"
   → Ambil: Primary, Accent, Background, On Primary hex
   → Konversi ke oklch() → masuk ke --vibe-* tokens

2. grep_search SearchPath: "<PATH>/styles.csv" | Query: "[vibe/Keywords]"
   → Ambil: Design System Variables, Effects & Animation, Implementation Checklist
   → Gunakan CSS variables langsung di :root

3. grep_search SearchPath: "<PATH>/typography.csv" | Query: "[mood/Category]"
   → Ambil: Heading Font, Body Font, Google Fonts URL, CSS Import
   → Apply ke --vibe-font-head dan --vibe-font-main

4. grep_search SearchPath: "<PATH>/ui-reasoning.csv" | Query: "[UI_Category/industri]"
   → Ambil: Recommended_Pattern, Style_Priority, Decision_Rules, Anti_Patterns
   → Gunakan sebagai layout constraint (mencegah "main aman")

5. grep_search SearchPath: "<PATH>/landing.csv" | Query: "[Pattern Name/keywords]"
   → Ambil: Section Order, Primary CTA Placement, Conversion Optimization
   → Gunakan jika task = landing page

6. grep_search SearchPath: "<PATH>/motion.csv" | Query: "[Intensity Tier/Category]"
   → Ambil: GSAP Snippet, Trigger, Duration, Easing, Framework Notes
   → Gunakan jika MOTION_INTENSITY > 3 atau ada animasi
```

Catat sumber: `[UUPM Source] Direct-Read CSV — colors.csv, styles.csv, typography.csv, ui-reasoning.csv, motion.csv (SearchPath: <PATH>)`

### Step 3 — Domain Search Spesifik (Jika Dibutuhkan)
```bash
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<query>" --domain [color|style|typography|ux|chart|landing|icons|gsap|react|web]
python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "<query>" --stack [laravel|nextjs|react|vue|astro|svelte|shadcn|nuxtjs|nuxt-ui|html-tailwind|...]
```

### Step 4 — Konversi ke design-system.md Token
- Hex warna UUPM → oklch() → masukkan ke `--raw-palette-*` CSS variables
- Implementasikan dalam `@layer tokens { :root { ... } }` sesuai design-system.md §2
- CSS keywords dari `styles.csv` kolom "Design System Variables" → gunakan di komponen
- GSAP snippet dari output → terapkan di komponen animasi

### Step 5 — Cross-check via context7 (Sebelum Kode Ditulis)
Jika komponen menggunakan library eksternal (Chart.js, Next.js, dll):
- Resolve library ID via context7
- Query dokumentasi terbaru
- Prioritaskan sintaks context7 jika ada konflik dengan data statis UUPM

## Data Files Reference (18 file)

| File | Records | Content | Kapan Dibaca |
|---|---|---|---|
| `colors.csv` | 192 | Palet warna per industri (16 semantic tokens) | SELALU — Gate 3 |
| `styles.csv` | 89 (50 active) | Gaya visual + CSS variables + checklist | SELALU — Gate 3 |
| `typography.csv` | 74 | Font pairing (Heading + Body + Google URL) | SELALU — Gate 3 |
| `ui-reasoning.csv` | 193 | Decision rules per industri + anti-patterns | SELALU — Gate 4 |
| `motion.csv` | 17 | GSAP animation presets (Intensity Tier, Snippet) | Jika MOTION > 3 |
| `landing.csv` | 35 | Landing page patterns + section order | Jika landing page |
| `ux-guidelines.csv` | 119 | UX best practices per kategori | On-demand |
| `charts.csv` | 25 | Chart type recommendations + A11y Risk | Jika ada chart |
| `app-interface.csv` | 33 | App interface patterns | On-demand |
| `google-fonts.csv` | 1935 | Full Google Fonts database (provenance-pinned) | Jika cari font baru |
| `icons.csv` | 105 | Icon library + Semantic Role + Allowed Contexts | On-demand |
| `products.csv` | 192 | Product-specific palettes & reasoning profiles | On-demand |
| `react-performance.csv` | 45 | React performance patterns | React/Next.js only |
| `stacks/` | 22 | Stack-specific guidelines per framework | Stack search |
| `data-provenance.json` | — | Metadata provenance sumber data | Maintenance |
| `google-font-licenses.json` | — | Lisensi font per family | Maintenance |
| `phosphor-icons-upstream.json` | — | 1512 upstream Phosphor icons mapping | Maintenance |
| `catalog-summary.json` | — | Ringkasan statistik katalog | Maintenance |

## Aturan Anti-AI-SLOP (HARD BLOCK)

Semua visual task wajib mematuhi 23 larangan Anti-AI-SLOP yang tercantum dalam:
- `gemini.md §VISUAL RULES` (18 larangan + 5 enforcement positif)
- `taste-skill-bridge/MODEL_HINTS.md` (model-specific overrides)
