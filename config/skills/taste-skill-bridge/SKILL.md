---
name: taste-skill-bridge
description: |
  Anti-slop frontend integration bridge. Menghubungkan taste-skill (design intelligence)
  dengan pipeline UUPM + design-system.md. Auto-aktif saat user meminta: buat halaman,
  redesign, landing page, portfolio, UI baru, tampilan baru, ubah desain, frontend,
  perbaiki halaman, buat artikel, halaman berita, template post, edit tampilan,
  update konten halaman, ubah layout, perbaiki artikel,
  sesuai visual dna, sesuai vdna, visual dna, vdna, samakan visual,
  konsistensi visual, ikuti desain halaman utama, ikuti style halaman lain,
  perbaiki agar konsisten, update tampilan.
  Menghasilkan Design Read + Three Dials → UUPM query → CSS token → kode anti-slop.
  Berlaku untuk semua stack: PHP Native, Laravel, Next.js, React, Astro, Vanilla HTML/CSS.
  PRINSIP INTI: Visual DNA sebuah proyek dimulai dari halaman utama (landing/dashboard).
  Semua halaman lain WAJIB mewarisi dan konsisten dengan Visual DNA halaman utama.
---

# TASTE-SKILL BRIDGE — Router (v2.0)

> ⚠️ **MANDATORY:** Saat skill ini di-trigger, AI REQUIRED membaca file ini DAN sub-file
> yang sesuai via `view_file`. FORBIDDEN mengeksekusi pipeline dari memori tanpa baca ulang.
>
> ⛔ **LAZY ROUTER EXIT GUARD (Gemini 3.7 Flash & Fast Models):**
> DILARANG berhenti di berkas router ini dan langsung menulis kode!
> AI WAJIB memanggil `view_file` untuk membaca `ESSENTIAL.md` (105 baris) sebelum Gate 2.
> Jika menggunakan Gemini 3.7 Flash atau terindikasi slop → WAJIB membaca juga `MODEL_HINTS.md`.
> Nilai Three Dials (V/M/D) pada output `[Design Read]` WAJIB mengacu pada tabel inferensi `ESSENTIAL.md §1`.

---

## PIPELINE OVERVIEW (6 Gate — Urutan Wajib)

| Gate | Aksi | Output Wajib |
|---|---|---|
| 1. Design Read | Baca konteks proyek → tipe halaman, vibe, audience | `[Design Read] ...` + `[DNA Source] ...` |
| 2. Three Dials | Set VARIANCE / MOTION / DENSITY | `dials: V=[n] M=[n] D=[n]` |
| 3. UUPM Search | Jalankan search.py ATAU Direct-Read CSV | `[UUPM Source] Palet + Style + Font` |
| 4. Layout Intel | grep `ui-reasoning.csv` + `landing.csv` per industri | `[Layout Intel] Pattern + Anti-Patterns` |
| 5. Rhythm Score | Susun section order A/B/C/D/E | `[RHYTHM SCORE] per section` |
| 6. Write Code | Tulis kode — semua dari UUPM output | CSS tokens via `var(--vibe-*)` |

**HARD BLOCK:** Kode tanpa Gate 1-5 output = INVALID.

---

## LOAD PROTOCOL (Pilih Berdasarkan Kompleksitas Task)

| Task Complexity | Yang Dibaca | Est. Tokens |
|---|---|---|
| **Standar** (tweak, edit section, tambah komponen) | `ESSENTIAL.md` (105 baris) | ~1.5K |
| **Complex** (halaman baru, redesign penuh, landing page) | `ESSENTIAL.md` + `DETAILED.md` (611 baris) | ~8.5K |
| **Pre-Flight** (sebelum declare done) | `REFERENCE.md` (128 baris) | ~1K |
| **Quick Reference** (copy-paste output format) | `CHEATSHEET.md` (~30 baris) | ~0.5K |
| **Model Override** (Gemini Flash / model slop-prone) | `MODEL_HINTS.md` (~50 baris) | ~0.5K |

---

## HARD BLOCKS SUMMARY (1-liner — Detail di ESSENTIAL/DETAILED)

1. ❌ Default centered hero + 3 equal cards → Bento/Staggered/Split
2. ❌ Color overlay pada gambar sebagai "DNA" → DNA via typography/spacing/radius
3. ❌ Cosmetic-only redesign (ganti warna saja) → ubah min 2 dari 4 dimensi
4. ❌ Halaman tanpa gambar kontekstual → generate_image atau Unsplash spesifik
5. ❌ 3 section treatment sama berturut → alternasi Rhythm Score wajib
6. ❌ Eyebrow/capsule di auth pages → FORBIDDEN
7. ❌ Copy slop: "Unlock", "Empower", "Revolutionize" dll → bahasa industri spesifik
8. ❌ Font tunggal (Inter saja) → 2-font pair dari typography.csv
9. ❌ Ikon SVG mentah → icon library proyek
10. ❌ Hex hardcode → var(--vibe-*) tokens

---

## REFERENSI SILANG

| Komponen | Baca Di |
|---|---|
| Enforcement pipeline detail | `gemini-execution.md §4K` (anchor:4K) |
| Self-check protocol | `gemini-execution.md §4I` (anchor:4I) |
| Anti-slop 23 rules (inline) | `gemini.md §VISUAL RULES` |
| Master palette 15 kluster | `design-system.md §1` |
| UUPM data (192 palet, 79 styles, 74 fonts, 17 GSAP presets) | `ui-ux-pro-max/data/` |
| Layout decision intelligence (193 rules) | `ui-ux-pro-max/data/ui-reasoning.csv` |
| GSAP motion presets | `ui-ux-pro-max/data/motion.csv` |
