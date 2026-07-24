---
name: taste-skill-bridge-essential
description: |
  Anti-slop frontend integration bridge — ESSENTIAL section.
  Menghubungkan taste-skill (design intelligence) dengan pipeline UUPM + design-system.md.
  Auto-aktif saat user meminta: buat halaman, redesign, landing page, portfolio, UI baru,
  tampilan baru, ubah desain, frontend, perbaiki halaman, buat artikel, halaman berita,
  template post, edit tampilan, update konten halaman, ubah layout, perbaiki artikel,
  ubah bentuk, ubah tampilan, redesign visual, ubah visual,
  sesuai visual dna, sesuai vdna, visual dna, vdna, samakan visual, konsistensi visual,
  ikuti desain halaman utama, ikuti style halaman lain, perbaiki agar konsisten, update tampilan.
  
  PRINSIP INTI: Visual DNA sebuah proyek dimulai dari halaman utama (landing/dashboard).
  Semua halaman lain WAJIB mewarisi dan konsisten dengan Visual DNA halaman utama.
---

# TASTE-SKILL BRIDGE — ESSENTIAL (50 Baris Pertama)

> ⚠️ **MANDATORY UNTUK AI:** Saat skill ini di-trigger, AI REQUIRED membaca file ESSENTIAL ini
> secara **PENUH** menggunakan `view_file` — BUKAN hanya membaca deskripsi singkat dari
> skills registry. Deskripsi registry hanya untuk trigger-detection; aturan sesungguhnya
> ada di body file ini. FORBIDDEN mengeksekusi STEP 0-6 dari memori tanpa baca ulang.

---

## STEP 0 — BRIEF INFERENCE (Wajib Sebelum Apapun)

Sebelum menulis kode atau memilih palet, AI REQUIRED membaca konteks:

### 0.A Sinyal yang Harus Dibaca
1. **Tipe halaman** — landing, dashboard, portfolio, auth, CMS, public portal
2. **Vibe dari prd.md** — ambil dari §3 Karakter Visual dan §3 Core Identity Lock
3. **Audience** — dari prd.md §1 Target User
4. **Stack** — dari prd.md §2 Tech Stack (tentukan apakah pakai Motion/GSAP/vanilla CSS)
5. **Brand assets** — palet warna terkunci di prd.md CORE IDENTITY LOCK
6. **Quiet constraints** — jika proyek pemerintahan/publik/anak-anak → OVERRIDE ke trust-first

### 0.B Output Design Read Wajib (1 Baris — Sebelum Kode)
```
[Design Read] Reading this as: [tipe halaman] untuk [audience], vibe [kata-kunci dari prd.md], 
leaning toward [aesthetic family], dials: V=[1-10] M=[1-10] D=[1-10]
[DNA Source] Inheriting from: [nama file halaman utama] — tokens: [daftar token yang diekstrak]
```

**Contoh output (halaman baru):**
```
[Design Read] Reading this as: Halaman artikel untuk blog tech, vibe dark-editorial,
leaning toward Carbon Slate palette + reading-optimized layout, dials: V=6 M=4 D=3
[DNA Source] Inheriting from: index.html / home.blade.php — tokens: --vibe-primary, --font-heading: Geist, --radius-md: 8px, shadow-style: tinted
```

**Contoh output (halaman utama / tidak ada parent):**
```
[Design Read] Reading this as: Landing page untuk SaaS B2B, vibe dark-professional,
leaning toward Oceanic Jade palette + asymmetric layout, dials: V=7 M=6 D=4
[DNA Source] NEW — ini halaman utama, Visual DNA dimulai di sini. UUPM akan menentukan token.
```

### 0.C Anti-Default Discipline (HARD BLOCK)
FORBIDDEN defaulting ke:
- AI-purple gradients + centered dark mesh hero
- 3 equal feature cards (symmetrical)
- Glassmorphism everywhere tanpa alasan
- Infinite loop micro-animations di semua elemen
- Inter + slate-900 tanpa heading font pair

---

## STEP 1 — THREE DIALS INFERENCE

Setelah Design Read, set 3 dials. Semua keputusan layout, motion, density mengacu ini.

| Dial | Range | Default |
|---|---|---|
| `DESIGN_VARIANCE` | 1=Simetri Penuh → 10=Chaos Kreatif | 7 |
| `MOTION_INTENSITY` | 1=Statis → 10=Sinematik/Physics | 5 |
| `VISUAL_DENSITY` | 1=Art Gallery/Airy → 10=Cockpit Data | 4 |

### Tabel Inferensi Dials dari Konteks Proyek

| Sinyal dari prd.md | VARIANCE | MOTION | DENSITY |
|---|---|---|---|
| Dashboard admin / data-heavy | 5 | 3 | 7 |
| Landing page SaaS / startup | 7 | 6 | 4 |
| Portfolio / creative agency | 9 | 8 | 3 |
| Proyek pemerintahan / publik | 3 | 2 | 5 |
| E-commerce premium | 7 | 6 | 3 |
| Blog / editorial / CMS | 6 | 4 | 3 |
| Auth pages (login/register) | 5 | 4 | 4 |
| Redesign — preserve | match existing | +1 | match |
| Redesign — overhaul | +2 | +2 | match |

---

## 🔴 HARD BLOCKS (100% Compliance)

Semua visual task wajib mematuhi 16 larangan Anti-AI-SLOP yang tercantum dalam single source of truth: [visual-rules.md](../visual-rules.md) (atau `%USERPROFILE%\.gemini\config\skills\visual-rules.md`).

> **Detail lengkap:** Baca `taste-skill-bridge/DETAILED.md` (STEP 2-6)
> **Checklist:** Baca `taste-skill-bridge/REFERENCE.md` (Pre-Flight Checklist)
