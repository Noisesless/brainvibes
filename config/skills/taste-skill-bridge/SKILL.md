---
name: taste-skill-bridge
description: |
  Anti-slop frontend integration bridge. Menghubungkan taste-skill (design intelligence)
  dengan pipeline UUPM + design-system.md. Auto-aktif saat user meminta: buat halaman,
  redesign, landing page, portfolio, UI baru, tampilan baru, ubah desain, frontend.
  Menghasilkan Design Read + Three Dials → UUPM query → CSS token → kode anti-slop.
  Berlaku untuk semua stack: PHP Native, Laravel, Next.js, React, Astro, Vanilla HTML/CSS.
---

# TASTE-SKILL BRIDGE — Anti-Slop Frontend Integration

> Skill ini adalah integrasi dari taste-skill (github.com/Leonxlnx/taste-skill) yang
> disesuaikan untuk pipeline Vibes Coding Workflow. Baca aturan ini SEBELUM menulis
> satu baris kode UI pun.
>
> ⚠️ **MANDATORY UNTUK AI:** Saat skill ini di-trigger, AI REQUIRED membaca file ini
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
```

**Contoh output:**
```
[Design Read] Reading this as: Web App dashboard untuk internal admin, vibe dark-professional,
leaning toward Carbon Mint palette + data-density layout, dials: V=6 M=5 D=7
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

## STEP 2 — UUPM PIPELINE (Wajib Diam-diam)

Setelah dials diset, jalankan UUPM search secara diam-diam:

**Langkah 0 — Cek Python Tersedia (Silent):**
```cmd
python --version
```

**Jika Python TERSEDIA** → jalankan UUPM search:
```cmd
python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "[tipe_proyek] [industri] [vibe_keyword]" --design-system
```

Ekstrak dari output:
- **Primary/Accent hex** → konversi ke `oklch()` → masuk ke `--raw-palette-*`
- **Gaya visual** → jadi CSS keyword guidance untuk komponen
- **`Design System Variables`** dari `styles.csv` → masuk ke `:root` token
- **`Implementation Checklist`** → jadi pre-delivery checklist

**Jika Python TIDAK TERSEDIA** → fallback graceful:
1. Tidak perlu lapor ke user — lanjut tanpa blokir
2. Pilih palet dari **15 kluster `design-system.md §1`** berdasarkan inferred vibe:
   - VARIANCE 8-10 → kluster "Cyber Industrial" / "Acid Streetwear" / "Holographic Dream"
   - VARIANCE 5-7 → kluster "Oceanic Jade" / "Nordic Earth" / "Carbon Slate"
   - VARIANCE 3-4 → kluster "Executive Navy" / "Medical Trust" / "Corporate Steel"
   - VARIANCE 1-2 → kluster "Minimalist Ivory" / "Pure Mono"
3. Catat di prd.md §3: `Sumber Palet: design-system.md Cluster (UUPM tidak tersedia — Python tidak di PATH)`

Jika stack terdeteksi (React/Next.js/Laravel), jalankan tambahan:
```cmd
python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "[komponen]" --stack [nextjs|react|laravel|vue|astro]
```

---

## STEP 3 — DESIGN SYSTEM INTEGRATION

### §3.A Stack Defaults (Pilih Berdasarkan prd.md §2)

| Stack | CSS Engine | Animation | Icons |
|---|---|---|---|
| Next.js / React | Tailwind v4 | motion/react | @phosphor-icons/react |
| Laravel + Blade | Vanilla CSS + @layer | CSS transition | Inline SVG |
| PHP Native | Vanilla CSS + @layer | CSS transition | Inline SVG |
| Astro 5+ | Vanilla CSS + @layer | CSS + View Transitions | @phosphor-icons |

**HARD RULES (semua stack):**
- NEVER `h-screen` untuk hero → REQUIRED `min-h-[100dvh]`
- NEVER flex percentage math → REQUIRED CSS Grid
- NEVER `useState` untuk tracking continuous values (scroll/mouse) → gunakan Motion's `useMotionValue`

### §3.B Font System (Anti-Slop)
- FORBIDDEN: Inter sendirian tanpa heading font
- REQUIRED: 2-font pairing dari `typography.csv` UUPM
- Fallback stack wajib: `font-family: '[Primary]', '[Fallback]', system-ui, sans-serif`
- Discouraged as default: Fraunces, Instrument Serif (LLM favorites)
- Preferred heading fonts: Geist, Outfit, Cabinet Grotesk, Satoshi, GT America

### §3.C Icon Policy
- Priority: `@phosphor-icons/react` > `@tabler/icons-react` > `@radix-ui/react-icons`
- FORBIDDEN: lucide-react (kecuali user minta)
- FORBIDDEN: hand-roll SVG icons
- ONE icon family per project — jangan campur

---

## STEP 4 — LAYOUT ANTI-SLOP RULES

### §4.1 Typography
- Display/Headlines: `clamp(1.75rem, 4vw, 2.5rem)`, `font-weight: 700`, `line-height: 1.25`
- Body: `font-size: 1rem`, `max-width: 65ch`, `line-height: 1.5`
- REQUIRED `text-wrap: balance` pada H1/H2/H3
- REQUIRED `text-wrap: pretty` pada paragraf

### §4.2 Color Calibration
- Max 1 accent color. Saturation < 80% default
- FORBIDDEN AI-purple (`#6C63FF`) sebagai default — gunakan UUPM colors.csv
- FORBIDDEN fluctuate antara warm dan cool gray dalam 1 proyek
- **COLOR CONSISTENCY LOCK:** Accent dipilih sekali → locked di semua section

### §4.3 Layout — Anti-Center Bias
- FORBIDDEN: Centered Hero jika `DESIGN_VARIANCE > 4`
- REQUIRED: gunakan Split Screen 50/50, Left-aligned, atau Asymmetric
- **SECTION REPETITION BAN:** Max 1 kali per layout family per page
- **ZIGZAG CAP:** Max 2 section berturut-turut image+text split. Section ke-3 HARUS beda
- **EYEBROW RESTRAINT:** Max 1 eyebrow per 3 section. Jika section A pakai eyebrow → 2 section berikutnya FORBIDDEN pakai eyebrow

### §4.4 Cards & Shadows
- Cards HANYA saat elevation communicates hierarchy
- Shadow HARUS ditint ke hue background — no pure black shadow
- **SHAPE CONSISTENCY LOCK:** Satu corner-radius untuk seluruh halaman (sharp/soft/pill)
- FORBIDDEN: mixed radius system tanpa documented rule

### §4.5 Interactive States (Wajib Semua)
- Loading: Skeletal loaders matching final layout shape
- Empty State: Beautifully composed, shows how to populate
- Error State: Clear, inline (forms) atau toast (transient only)
- Tactile feedback: pada `:active` gunakan `-translate-y-[1px]` atau `scale-[0.98]`
- **BUTTON CONTRAST CHECK (mandatory):** Setiap button wajib WCAG AA (4.5:1 body, 3:1 large text)
- **CTA WRAP BAN:** Button label MUST fit 1 line. Label > 3 kata → shorten
- **NO DUPLICATE CTA INTENT:** Satu intent = satu label di seluruh page

### §4.6 Hero Section Rules
- Hero HARUS fit dalam initial viewport (no scroll untuk lihat CTA)
- Max 2 lines headline di desktop
- Subtext max 20 words, max 4 lines
- Max 4 text elements total: [eyebrow OR nothing] + [headline] + [subtext] + [CTAs]
- Hero top padding MAX `pt-24` (≈6rem)
- **BANNED di dalam hero:** trust logo wall, pricing teaser, feature bullet list
- Logo wall = seksi BAWAH hero, bukan di dalam hero

### §4.7 Navigation Rules
- Nav HARUS render single line di desktop
- Nav height: 64-72px default, MAX 80px
- Bento cells = tepat sebanyak content. Empty cell = redesign grid
- Mobile collapse HARUS dideklarasikan eksplisit per section

### §4.8 Visual Assets (Mandatory)
1. Jika `generate_image` tersedia → REQUIRED generate kontekstual (hero, product shot, mood)
2. Tidak ada gen tool → gunakan `https://images.unsplash.com/photo-xxx?auto=format&fit=crop&w=800&q=80` dengan seed deskriptif
3. **FORBIDDEN:** div-based fake screenshots, placeholder SVG rectangles
4. **FORBIDDEN:** halaman text-only tanpa minimal 2-3 real images
5. Logo wall → gunakan SVG nyata dari `cdn.simpleicons.org/{slug}/currentColor`

### §4.9 Content Rules
- Headline: max 8 kata
- Subtext: max 25 kata per section
- Quote/testimonial: max 3 lines
- Attribution: name + role + company (FORBIDDEN: name only)
- **COPY SELF-AUDIT:** Re-read semua visible string sebelum declare done
- **FORBIDDEN:** fake-precise numbers (92%, 4.1×) tanpa real data

---

## STEP 5 — PRE-FLIGHT CHECK (Sebelum Declare Selesai)

AI REQUIRED menjalankan checklist ini sebelum menyatakan task UI selesai:

### Pre-Flight Checklist (Mechanical)
- [ ] **Typography:** Dua font dipakai (heading + body), bukan Inter sendirian
- [ ] **Hero:** Fit dalam viewport, max 4 text elements, top padding ≤ pt-24
- [ ] **Height:** Tidak ada `h-screen` → sudah `min-h-[100dvh]`
- [ ] **Center Bias:** Jika VARIANCE > 4, hero BUKAN centered
- [ ] **Eyebrow count:** ≤ ceil(sectionCount / 3)
- [ ] **Zigzag:** Tidak ada 3+ consecutive image+text split layout
- [ ] **CTA:** Semua labels fit 1 line, tidak ada duplicate intent
- [ ] **Button contrast:** Semua tombol pass WCAG AA 4.5:1
- [ ] **Shape consistency:** 1 corner-radius system untuk semua komponen
- [ ] **Color:** Tidak ada hardcode `white`/`black`/`#6C63FF`
- [ ] **Spacing:** Semua padding/margin dalam kelipatan 8pt
- [ ] **Images:** Minimal 2 real images, tidak ada fake screenshot div
- [ ] **Mobile:** Semua section punya explicit mobile collapse rule
- [ ] **CSS tokens:** Semua warna via `var(--vibe-*)`, tidak ada hex hardcode

**Format output self-check:**
```
[TASTE-SKILL PRE-FLIGHT] Typography: ✅ | Hero: ✅ | Center-bias: ✅ | Eyebrow: ✅ | 
CTA: ✅ | Contrast: ✅ | Shape: ✅ | Tokens: ✅ | Images: ✅ | Mobile: ✅
```
Jika ada ❌ → perbaiki SEBELUM declare done.

---

## STEP 6 — MOTION GUIDELINES (Berlaku jika MOTION_INTENSITY ≥ 4)

- Motion HARUS bermotivasi: hierarchy, storytelling, feedback, atau state transition
- FORBIDDEN: animasi "karena terlihat keren" tanpa alasan
- **MARQUEE MAX:** 1 per halaman. Lebih dari 1 = lazy filler
- Spring physics default: `type: "spring", stiffness: 100, damping: 20`
- FORBIDDEN: linear easing untuk UI interactions
- `prefers-reduced-motion`: REQUIRED fallback untuk semua animasi

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
| UUPM color database (193 palet) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\colors.csv` |
| UUPM style database (84 gaya) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\styles.csv` |
| UUPM typography (73 pairings) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\typography.csv` |
| UUPM UX guidelines | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\ux-guidelines.csv` |
| Auth + security rules | `gemini.md §4B` |
| Active link policy | `gemini.md §4A` |
| Upload pipeline | `gemini.md §4E` |
| Anti-slop HARD BLOCK lengkap | `gemini.md §4K F` |
