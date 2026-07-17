---
name: taste-skill-bridge-reference
description: |
  Anti-slop frontend integration bridge — REFERENCE section.
  Checklist, examples, dan reference materials.
  Dibaca AI HANYA untuk pre-flight check sebelum declare done.
---

# TASTE-SKILL BRIDGE — REFERENCE (Checklist & Examples)

> Baca file ini HANYA untuk pre-flight check sebelum declare done.
> Untuk task biasa, ESSENTIAL.md + DETAILED.md sudah cukup.

---

## STEP 5 — PRE-FLIGHT CHECK (Sebelum Declare Selesai)

AI REQUIRED menjalankan checklist ini sebelum menyatakan task UI selesai:

### Pre-Flight Checklist (Mechanical)
- [ ] **DNA Inheritance:** Halaman non-utama sudah inherit font/palet/radius/shadow dari halaman utama
- [ ] **File Written:** Perubahan sudah ditulis ke disk via `write_to_file`/`replace_file_content` — FORBIDDEN declare done jika hanya output di chat
- [ ] **Typography:** Dua font dipakai (heading + body), bukan Inter sendirian
- [ ] **Hero:** Fit dalam viewport, max 4 text elements, top padding ≤ pt-24
- [ ] **Height:** Tidak ada `h-screen` → sudah `min-h-[100dvh]`
- [ ] **Center Bias:** Jika VARIANCE > 4, hero BUKAN centered
- [ ] **Eyebrow count:** ≤ ceil(sectionCount / 3)
- [ ] **Zigzag:** Tidak ada 3+ consecutive image+text split layout
- [ ] **CTA:** Semua labels fit 1 line, tidak ada duplicate intent
- [ ] **Button contrast:** Semua tombol pass WCAG AA 4.5:1
- [ ] **Shape consistency:** Menggunakan 1 corner-radius system yang konsisten untuk semua komponen. Jika menggunakan geometri kustom (asimetris/blob/oval/arch), pastikan sudah diterapkan secara seragam dan tidak dicampur tanpa aturan tertulis.
- [ ] **Geometry Check:** FORBIDDEN hanya menggunakan persegi panjang rounded standar di seluruh halaman. Minimal ada 1 tipe elemen visual/kartu yang menggunakan bentuk geometri kustom (asimetris, oval, blob, arch, atau intersecting circle badges) untuk memecah monotoni.
- [ ] **Color:** Tidak ada hardcode `white`/`black`/`#6C63FF`
- [ ] **Spacing:** Semua padding/margin dalam kelipatan 8pt
- [ ] **Images:** Minimal 2 real images, tidak ada fake screenshot div, tidak ada color overlay
- [ ] **Mobile:** Semua section punya explicit mobile collapse rule
- [ ] **CSS tokens:** Semua warna via `var(--vibe-*)`, tidak ada hex hardcode
- [ ] **Article containment:** Jika tipe artikel/berita → `overflow-wrap: break-word` + `img { max-width: 100% }` + `pre { overflow-x: auto }` sudah diterapkan
- [ ] **Rhythm Score:** Sudah ada [RHYTHM SCORE] output. Tidak ada 3 section berturut dengan treatment sama. Ada minimal 1 [C] atau [E] section. Rhythm Check: 4+ dari 5 jawaban [Ya]

**Format output self-check:**
```
[TASTE-SKILL PRE-FLIGHT]
DNA: ✅ | File: ✅ | Typography: ✅ | Hero: ✅ | Center-bias: ✅ | Eyebrow: ✅
CTA: ✅ | Contrast: ✅ | Shape: ✅ (Asymmetric/Blob/Oval/Arch) | Tokens: ✅ | Images: ✅ | Mobile: ✅ | Article: ✅
Rhythm: ✅ [A→C→B→D→A] — WOW moment: ✅ | Full-bleed: ✅ | BG variety: ✅
```
Jika ada ❌ → perbaiki SEBELUM declare done.

---

## REFERENSI SILANG

| Komponen | Baca Di |
|---|---|
| CSS token architecture (oklch, @layer) | `design-system.md §2` |
| Master palette 15 kluster | `design-system.md §1` |
| Typography hierarchy | `design-system.md §3` |
| Shadow & elevation | `design-system.md §4` |
| Z-index map | `design-system.md §5` |
| Spacing 8-point grid | `design-system.md §6` |
| Page Composition Rhythm | `taste-skill-bridge/DETAILED.md §0.I` |
| Anti-Color-Overlay | `taste-skill-bridge/DETAILED.md §0.F` |
| Anti-Cosmetic-Redesign | `taste-skill-bridge/DETAILED.md §0.G` |
| UUPM color database (193 palet) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\colors.csv` |
| UUPM style database (84 gaya) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\styles.csv` |
| UUPM typography (73 pairings) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\typography.csv` |
| UUPM UX guidelines | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\ux-guidelines.csv` |
| Auth + security rules | `gemini.md §4B` |
| Active link policy | `gemini.md §4A` |
| Upload pipeline | `gemini.md §4E` |
| Anti-slop HARD BLOCK lengkap | `gemini.md §4K F` |
| Anti-patterns library (AP-016 to AP-019) | `lessons-learned/data/anti-patterns.md` |

---

## EXAMPLES: Design Read Output

### Contoh 1: Halaman Baru (Landing Page)
```
[Design Read] Reading this as: Landing page untuk SaaS B2B, vibe dark-professional,
leaning toward Oceanic Jade palette + asymmetric layout, dials: V=7 M=6 D=4
[DNA Source] NEW — ini halaman utama, Visual DNA dimulai di sini. UUPM akan menentukan token.
[Style Rec] Rekomendasi: Split hero 50/50 dengan image kiri, text kanan — sumber: UUPM styles.csv
```

### Contoh 2: Halaman Turunan (Artikel)
```
[Design Read] Reading this as: Halaman artikel untuk blog tech, vibe dark-editorial,
leaning toward Carbon Slate palette + reading-optimized layout, dials: V=6 M=4 D=3
[DNA Source] Inheriting from: index.html / home.blade.php — tokens: --vibe-primary, --font-heading: Geist, --radius-md: 8px, shadow-style: tinted
[Style Rec] Rekomendasi: Article wrapper 65ch, line-height 1.75, text-wrap pretty — sumber: DETAILED.md §4.10
```

### Contoh 3: Redesign Halaman Existing
```
[Audit] Font: Inter saja → FIX: tambah Geist sebagai heading font | Container: tidak ada max-width → FIX: tambah .content { max-width: 65ch } | Status: langsung difix dalam task ini

[Design Read] Reading this as: Redesign halaman dashboard, vibe data-heavy,
preserving existing DNA, dials: V=5 M=3 D=7
[DNA Source] Inheriting from: dashboard.blade.php — tokens: --vibe-primary, --font-heading: Geist, --radius-md: 8px
[Style Rec] Rekomendasi: Preserve existing layout, fix typography + containment — sumber: DETAILED.md §0.D
```

---

## EXAMPLES: Rhythm Score Output

### Contoh: Landing Page 6 Sections
```
[RHYTHM SCORE]
Nav      : [sticky glass]
Hero     : [E] full-bleed split image — treatment: image kiri, text kanan
Section2 : [B] dense grid 3-col — treatment: card abu-abu, icon accent
Section3 : [C] full-bleed dark — treatment: bg --vibe-surface, quote besar center
Section4 : [A] airy single col — treatment: whitespace besar, 1 statistik besar
Section5 : [E] media-heavy — treatment: video/image fullwidth, caption bawah
Footer   : [D] dark-moment — treatment: bg gelap, link kolom

[RHYTHM CHECK]
1. WOW moment: ✅ Ya
2. Width variation: ✅ Ya
3. BG variety (3x+): ✅ Ya
4. Visual dominant section: ✅ Ya
5. Airy section after dense: ✅ Ya
```
