# Visual Rules — Single Source of Truth

> File ini menggabungkan semua visual rules dari:
> - AGENTS.md §VISUAL OUTPUT GATE
> - AGENTS.md §ANTI-SLOP ENFORCEMENT
> - gemini.md §VISUAL RULES
> - taste-skill-bridge/ESSENTIAL.md (HARD BLOCKS)
>
> AI WAJIB baca file ini setiap visual task.
> Token cost: 1 file (5K tokens) vs 5 files (25K tokens) = 80% reduction

---

## 🔴 HARD BLOCKS (100% Compliance)

1. **FORBIDDEN** menulis satu baris kode UI tanpa output `[Design Read]` + Three Dials
2. **FORBIDDEN** menggunakan `font-family: Inter` tunggal — wajib 2 font (heading + body)
3. **FORBIDDEN** hardcode warna (`#6C63FF`, `white`, `black`) — gunakan `var(--vibe-*)`
4. **FORBIDDEN** spacing acak (13px, 19px) — gunakan kelipatan 8pt grid
5. **FORBIDDEN** centered Hero jika `DESIGN_VARIANCE > 4`
6. **FORBIDDEN** `h-screen` pada hero — REQUIRED `min-h-[100dvh]`
7. **FORBIDDEN** eyebrow label > 1 per 3 section
8. **FORBIDDEN** ikon SVG mentah (hand-rolled) — gunakan icon library proyek
9. **FORBIDDEN** border/outline/stroke pada logo — logo as-is tanpa dekorasi
10. **FORBIDDEN** mencampur > 1 icon library dalam satu proyek
11. **FORBIDDEN** `border-radius: 8px` hardcode — gunakan `--radius-md`
12. **FORBIDDEN** `box-shadow` generik — gunakan nilai dari `design-system.md §4`
13. **FORBIDDEN** `transition: all 0.3s ease` — gunakan `var(--vibe-transition)`
14. **FORBIDDEN** `background: white` atau `color: black` hardcode — gunakan `--vibe-background` & `--vibe-text-main`
15. **FORBIDDEN** memilih palet tanpa memeriksa `colors.csv` UUPM terlebih dahulu
16. **FORBIDDEN** menghasilkan output visual tanpa memeriksa kepatuhan visual gate ini

---

## 🟡 IMPORTANT (90% Compliance)

### 8pt Grid Spacing
- REQUIRED: semua padding/margin dalam kelipatan 8pt (8, 16, 24, 32, 40, 48, ...)
- FORBIDDEN: spacing acak (13px, 19px, 27px)

### Font Pairing
- REQUIRED: 2-font pairing dari `typography.csv` UUPM — 1 heading font + 1 body font
- FORBIDDEN: Inter sendirian tanpa heading font
- Fallback stack: `font-family: '[HeadingFont]', '[Fallback]', system-ui, sans-serif`

### CSS Tokens
- REQUIRED: semua warna via `var(--vibe-*)`, tidak ada hex hardcode
- FORBIDDEN: `#6C63FF`, `white`, `black` (kecuali direkomendasikan UUPM)

### Visual DNA Validation
- REQUIRED: validasi tokens vs VDNA di prd.md §3
- FORBIDDEN: ikut CSS tokens tanpa validasi konsistensi

### UUPM Pipeline
- REQUIRED: jalankan UUPM search (Python atau fallback CSV)
- FORBIDDEN: pilih palet tanpa UUPM consultation

### DNA Inheritance
- REQUIRED: halaman turunan inherit font/palet/radius/shadow dari halaman utama
- FORBIDDEN: membuat halaman turunan tanpa membaca halaman utama

### Self-Check
- REQUIRED: jalankan visual self-check sebelum declare done
- FORBIDDEN: declare done tanpa self-check

---

## 🟢 NICE-TO-HAVE (70% Compliance)

### Rhythm Score
- REQUIRED: output [RHYTHM SCORE] sebelum kode HTML
- FORBIDDEN: 3 section berturut-turut dengan treatment sama
- REQUIRED: minimal 1 section `[E] MEDIA-HEAVY` atau `[C] FULL-BLEED` per halaman

### Geometry Variation
- REQUIRED: minimal 1 tipe elemen visual/kartu menggunakan bentuk geometri kustom
- Alternatif: asimetris, oval, blob, arch, intersecting circle badges

### Motion Guidelines
- REQUIRED: motion bermotivasi (hierarchy, storytelling, feedback, state transition)
- FORBIDDEN: animasi "karena terlihat keren" tanpa alasan
- Spring physics default: `type: "spring", stiffness: 100, damping: 20`

### Premium Visual Architecture
- Custom shape dividers (wave/cloud)
- Overlapping card layout & intersecting badges
- Floating micro-decorations (organic particles)
- Non-standard card geometry (anti-AI rectangles)

---

## 📋 Visual Gate Output Formats

### Untuk Perubahan Visual Kecil:
```
[Visual Gate] Perubahan: [deskripsi singkat] — token: [CSS token yang digunakan] — sesuai Visual DNA: ✅
```

### Untuk Pembuatan/Redesign Halaman:
```
[Design Read] Reading this as: [X] untuk [Y], vibe [Z], dials: V=[n] M=[n] D=[n]
[Style Rec] Rekomendasi: [style sesuai Visual DNA] — sumber: [UUPM/design-system.md/prd.md]
```

### Untuk Visual Self-Check:
```
[VISUAL SELF-CHECK]
Design Read: ✅ | Three Dials: ✅ | 8pt Grid: ✅ | Font Pairing: ✅
CSS Tokens: ✅ | DNA Valid: ✅ | UUPM: ✅ | DNA Extract: ✅ | DNA Validate: ✅
```

### Untuk Taste-Skill Pre-Flight:
```
[TASTE-SKILL PRE-FLIGHT]
DNA: ✅ | File: ✅ | Typography: ✅ | Hero: ✅ | Center-bias: ✅ | Eyebrow: ✅
CTA: ✅ | Contrast: ✅ | Shape: ✅ (Asymmetric/Blob/Oval/Arch) | Tokens: ✅ | Images: ✅ | Mobile: ✅ | Article: ✅
Rhythm: ✅ [A→C→B→D→A] — WOW moment: ✅ | Full-bleed: ✅ | BG variety: ✅
```

---

## 📚 Cross-References

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
