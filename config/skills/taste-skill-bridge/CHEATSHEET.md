---
name: taste-skill-bridge-cheatsheet
description: |
  Quick-reference output format templates untuk model kecil.
  Copy-paste format tanpa perlu baca 800 baris instruksi.
---

# TASTE-SKILL BRIDGE — CHEATSHEET (Output Formats)

> Baca file ini untuk copy-paste format output. Detail rules di ESSENTIAL.md/DETAILED.md.

## Format: Design Read + DNA Source
```
[Design Read] Reading this as: [tipe halaman] untuk [audience], vibe [keyword],
leaning toward [aesthetic family], dials: V=[1-10] M=[1-10] D=[1-10]
[DNA Source] Inheriting from: [file halaman utama] — tokens: [--vibe-*, --font-*, --radius-*]
```

## Format: UUPM Source
```
[UUPM Source] Palet: [nama] dari [colors.csv baris N] | Style: [nama] dari [styles.csv baris N] | Font: [heading+body] dari [typography.csv baris N]
```

## Format: Layout Intelligence
```
[Layout Intel] ui-reasoning.csv baris [N]: Pattern=[Recommended_Pattern] | Anti-Patterns=[Anti_Patterns] | Decision=[Decision_Rules relevan]
```

## Format: Rhythm Score
```
[RHYTHM SCORE]
Nav      : [sticky glass / solid / transparent]
Hero     : [A/B/C/D/E] [deskripsi] — treatment: [detail]
Section2 : [A/B/C/D/E] [deskripsi] — treatment: [detail]
Section3 : [A/B/C/D/E] [deskripsi] — treatment: [detail]
...
Footer   : [D] dark-moment — treatment: [detail]
```

## Format: Pre-Flight Check
```
[TASTE-SKILL PRE-FLIGHT]
DNA: ✅ | File: ✅ | Typography: ✅ | Hero: ✅
Center-bias: ✅ | Eyebrow: ✅ | CTA: ✅ | Contrast: ✅
Shape: ✅ | Tokens: ✅ | Images: ✅ | Mobile: ✅
Rhythm: ✅ | Copy-slop: ✅ | UUPM-sourced: ✅
[COPY CHECK] Echo: ✅ | Blocklist: ✅ | Limit: ✅ | Meta: ✅ | TechLeak: ✅ | Lint: ✅ (0 hit)
```

## Format: Copy Table (Gate 5B — sebelum kode)
```
[COPY TABLE] Bahasa: [Indonesia] | Entitas: [transaksi] | Aksi: [ekspor, filter]
Slot       | Dari instruksi                      | Teks UI (jumlah kata)
h1         | "menampilkan data transaksi harian" | Transaksi Harian (2)
btn utama  | "ekspor"                            | Ekspor CSV (2)
empty      | -                                   | Belum ada transaksi (3)
```

## Section Treatment Types
```
[A] AIRY       → Light bg, max-width container, banyak whitespace
[B] DENSE      → Grid rapat, banyak card/item, bg surface
[C] FULL-BLEED → Bg melebar ke edge, escape container
[D] DARK-MOMENT → Bg gelap/solid accent, teks terang
[E] MEDIA-HEAVY → Gambar/video dominan, teks minimal
```

## Copy Blocklist
Daftar lengkap EN+ID, batas kata, dan regex lint: `COPY_RULES.md` (§4, §3, §7).
