---
name: ui-ux-pro-max
description: |
  AI-powered design intelligence with 193 industry-specific color palettes,
  84 UI styles, 73 font pairings, 99 UX guidelines, and 25 chart types across
  17 tech stacks. Activates automatically when the user requests UI building,
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
```cmd
:: Windows — gunakan python (bukan python3)
python skills/ui-ux-pro-max/scripts/search.py "<tipe_produk> <industri> <kata_kunci>" --design-system
```

Output memberikan: palet warna (Primary, Accent, Background), gaya visual terbaik,
font pairing, efek CSS, dan checklist implementasi.

### Step 3 — Domain Search Spesifik (Jika Dibutuhkan)
```cmd
python skills/ui-ux-pro-max/scripts/search.py "<query>" --domain [color|style|typography|ux|chart|landing]
python skills/ui-ux-pro-max/scripts/search.py "<query>" --stack [laravel|nextjs|react|vue|astro|...]
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

## Aturan Anti-AI-SLOP (HARD BLOCK)

FORBIDDEN menghasilkan desain generik dengan:
1. Warna `#6C63FF`, `#4CAF50`, `#2196F3` tanpa rekomendasi eksplisit UUPM
2. Font tunggal `Inter` saja — wajib pairing dua font dari `typography.csv`
3. `border-radius: 8px` hardcode — gunakan `--radius-md: 8px` CSS token
4. Shadow `0 2px 4px rgba(0,0,0,0.1)` generik — ikuti design-system.md §4
5. `transition: all 0.3s ease` — gunakan `var(--vibe-transition)`
6. `background: white` atau `color: black` — gunakan `var(--vibe-background)` / `var(--vibe-text-main)`
7. Pilih palet tanpa memeriksa `colors.csv` UUPM untuk industri terkait terlebih dahulu
