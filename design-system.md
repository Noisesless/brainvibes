# DESIGN SYSTEM REFERENCE
*File ini dibaca AI on-demand — HANYA saat: (1) wizard palet aktif, (2) Visual DNA Refresh di konversi, (3) debugging visual/CSS. TIDAK dimuat di setiap sesi.*

---

## §1. MASTER PALETTE — 15 TREN 2026

| No | Nama Kluster | Background | Surface | Text Utama | Accent 1 | Accent 2 |
|---|---|---|---|---|---|---|
| 1 | Cyber Industrial (Ultra Dark) | `#111111` | `#222222` | `#E2E8F0` | `#FF6B00` | `#00FFC2` |
| 2 | Quiet Luxury (Warm Premium) | `#FDFBF7` | `#F4F0E6` | `#1E1E24` | `#4A1525` | `#0D3B30` |
| 3 | Electric SaaS (Modern Tech) | `#0F172A` | `#1E293B` | `#F1F5F9` | `#635BFF` | `#00E5E5` |
| 4 | Acid Streetwear (Creative Studio) | `#0A0A0A` | `#1C1C1E` | `#FFFFFF` | `#DFFF00` | `#7000FF` |
| 5 | Cloud Dancer (Clean Minimalist) | `#F1F5F9` | `#FFFFFF` | `#0F172A` | `#008080` | `#94A3B8` |
| 6 | Deep Burgundy (Luxury Corporate) | `#1A0B10` | `#2D161E` | `#F5EFF1` | `#8B002A` | `#D4AF37` |
| 7 | Carbon Mint (Edgy Portfolio) | `#161719` | `#232529` | `#ECEFF1` | `#00FF9F` | `#37474F` |
| 8 | Dopamine Burst (Vibrant Startup) | `#0A051B` | `#171036` | `#FFFFFF` | `#EF5777` | `#FFA801` |
| 9 | Nordic Earth (Organic Minimal) | `#F9F6F0` | `#EFECE4` | `#2C3E50` | `#A47864` | `#708090` |
| 10 | Titanium Stealth (Tech Hardware) | `#0D0E10` | `#1C1E22` | `#E3E4E6` | `#788896` | `#FF3E3E` |
| 11 | Oceanic Jade (Fintech & Biotech) | `#051C24` | `#0B2D38` | `#E0F2F1` | `#00BFA5` | `#00E5FF` |
| 12 | Soft Velvet (Premium E-Commerce) | `#FAF7F5` | `#FFFFFF` | `#2B2523` | `#3A223A` | `#E0A96D` |
| 13 | Crimson Oxide (Automotive & MX) | `#121214` | `#1E1E22` | `#F0F0F2` | `#E60000` | `#8E9AA6` |
| 14 | Sage Balance (Wellness & Lifestyle) | `#F4F7F5` | `#E6ECE8` | `#1C2822` | `#4F6F52` | `#D2E0D6` |
| 15 | Neon Midnight (Cyberpunk Aesthetic) | `#03030C` | `#0D0D21` | `#E5E5F7` | `#FF007F` | `#7B2CBF` |

### Hukum Pemilihan Palet
- **RANDOM:** Kocok satu nomor dari 15 secara utuh. FORBIDDEN campur token lintas nomor.
- **Light Mode:** `--vibe-background` = hex Bg asli palet (DNA original). FORBIDDEN hardcode `#FFFFFF` kecuali palet aslinya memang putih.
- **Dark Mode:** Generate versi midnight/deep tonal dari hue dasar palet asli — BUKAN `#000000`.
- **Validasi kontras:** Rasio teks utama vs surface ≥ 4.5:1 (WCAG AA minimum).

### Panduan Konversi ke oklch() (Standar 2026)
*`oklch()` adalah standar warna modern 2026 — lebih perceptually uniform, aksesibel, dan mendukung HDR display.*
```css
/* oklch(lightness% chroma hue) */
/* Konversi: gunakan https://oklch.com atau tool: npx oklch */

/* Contoh konversi dari HEX ke oklch: */
/* #FF6B00 (Orange Cyber Industrial) → oklch(65% 0.22 35) */
/* #635BFF (Purple Electric SaaS)    → oklch(55% 0.25 275) */
/* #00BFA5 (Teal Oceanic Jade)       → oklch(68% 0.15 175) */

/* Aturan AI: saat generate CSS global pertama kali, */
/* REQUIRED gunakan oklch() untuk --raw-palette-* variables */
/* HEX di tabel §1 tetap sebagai referensi visual — oklch sebagai implementasi */
```

---

## §2. CSS TOKEN ARCHITECTURE

### @layer Architecture (REQUIRED — Standar 2026)
*Semua CSS global REQUIRED ditulis dalam `@layer` untuk mencegah specificity wars dan memudahkan override:*
```css
/* REQUIRED: Deklarasikan urutan layer di baris pertama CSS global */
@layer reset, tokens, base, components, utilities, overrides;

/* Layer tokens — semua CSS custom properties */
@layer tokens {
  :root { /* … semua --vibe-* variables */ }
}

/* Layer base — typography, reset, element defaults */
@layer base {
  body { font-family: var(--font-sans); }
  h1, h2 { /* … */ }
}

/* Layer components — navbar, card, button, dll */
@layer components {
  .card { /* … */ }
}

/* Layer utilities — helper class seperti .d-flex, .w-full */
@layer utilities {
  .d-flex { display: flex; }
}
```

### @property Typed Custom Properties (Animatable Variables)
*REQUIRED untuk CSS variables yang perlu di-animate (transisi warna, opacity, transform) untuk mencegah lompatan visual kasar saat ganti tema atau state hover.*

```css
/* Contoh: animatable color variable */
@property --vibe-primary {
  syntax: '<color>';
  inherits: true;
  initial-value: oklch(55% 0.25 275);
}

/* Sekarang bisa di-transition secara smooth: */
.button {
  background: var(--vibe-primary);
  transition: --vibe-primary 0.3s ease; /* ✔️ bekerja dengan @property */
}
```

#### Tabel Enforcement Registrasi `@property`
AI REQUIRED mendaftarkan custom property berikut menggunakan `@property` jika interaktivitas transisi warna digunakan pada elemen:

| CSS Variable | Syntax | Inherits | Fungsi Utama | Fallback Strategy |
|---|---|---|---|---|
| `--vibe-primary` | `<color>` | `true` | Transisi warna tombol, border focus, text links | Transition `background` / `color` standar |
| `--vibe-secondary` | `<color>` | `true` | Transisi warna aksen kedua, badge hover | Transition `background` / `color` standar |
| `--vibe-background` | `<color>` | `true` | Smooth transition saat toggle Light/Dark Mode | Transition `background-color` standar |
| `--vibe-surface` | `<color>` | `true` | Smooth transition background card/panel | Transition `background-color` standar |
| `--vibe-text-main` | `<color>` | `true` | Smooth transition warna teks saat toggle mode | Transition `color` standar |

*Catatan: Pastikan initial-value oklch() di-set sesuai default palet utama.*

```css
/* ══════════════════════════════════════════
   ARSITEKTUR TOKEN WARNA ADAPTIF (TREN 2026)
   AI: Isi nilai berdasarkan palet yang dipilih saat wawancara
   REQUIRED: Gunakan oklch() — bukan HEX/HSL murni
   ══════════════════════════════════════════ */

@layer tokens {
  :root {
    /* BASE DNA PALET — Dikunci saat wawancara — FORMAT oklch() */
    --raw-palette-bg:       [Isi oklch() bg palet terpilih];
    --raw-palette-surface:  [Isi oklch() surface palet terpilih];
    --raw-palette-text:     [Isi oklch() text palet terpilih];
    --raw-palette-accent-1: [Isi oklch() accent1 palet terpilih];
    --raw-palette-accent-2: [Isi oklch() accent2 palet terpilih];

    /* GLOBAL TRANSITION ENGINE */
    --vibe-transition: all 0.2s ease-in-out;

    /* STATUS TOKEN (Universal — tidak berubah antar tema) */
    --vibe-error:   oklch(60% 0.22 25);   /* merah */
    --vibe-success: oklch(72% 0.20 152);  /* hijau */
    --vibe-warning: oklch(82% 0.18 85);   /* kuning */
  }
}

/* ── LIGHT MODE (PALETTE ORIGINAL DNA) ──
   FORBIDDEN hardcode #FFFFFF pada --vibe-background
   kecuali palet aslinya memang menggunakan warna putih */
[data-theme="light"] {
  --vibe-background:  var(--raw-palette-bg);
  --vibe-surface:     var(--raw-palette-surface);
  --vibe-text-main:   var(--raw-palette-text);
  --vibe-text-muted:  rgba(0, 0, 0, 0.6);
  --vibe-primary:     var(--raw-palette-accent-1);
  --vibe-secondary:   var(--raw-palette-accent-2);
}

/* ── DARK MODE (DEEP TONAL PRESERVATION) ──
   Generate versi midnight dari rona dasar palet asli
   FORBIDDEN menggunakan #000000 atau #121212 murni
   
   FORMULA GENERASI (HSL Shift Guide):
   1. --vibe-background : Ambil hue (H) dari raw-palette-bg,
      pertahankan Saturation (S), turunkan Lightness (L) ke 3-8%
   2. --vibe-surface    : Hue sama, Lightness = background + 3-5%
   3. --vibe-text-main  : Hue senada palet asli, Lightness 85-95%
   Contoh: Palet Sage (#F4F7F5 → hsl(135,18%,96%))
           Dark bg = hsl(135,20%,8%) → #1B2921
           Dark surface = hsl(135,18%,12%) → #243530
           Dark text = hsl(135,10%,90%) → #E0E8E3
*/
[data-theme="dark"] {
  --vibe-background:  /* Generate: hsl([hue-palet], [sat-palet], 3-8%) */;
  --vibe-surface:     /* Generate: hsl([hue-palet], [sat-palet], 8-13%) */;
  --vibe-text-main:   /* Generate: hsl([hue-palet], [sat-palet-rendah], 85-95%) */;
  --vibe-text-muted:  rgba(255, 255, 255, 0.6);
  --vibe-primary:     var(--raw-palette-accent-1);
  --vibe-secondary:   var(--raw-palette-accent-2);
}
```

### Contoh Kasus Konkret Penerapan Tema:
| Palet | Light Mode `--vibe-background` | Dark Mode `--vibe-background` |
|---|---|---|
| Cyber Industrial (Bg #111111) | `#111111` (DNA asli gelap) | `#090909` (hsl(0,0%,3.5%) — lebih gelap) |
| Sage Balance (Bg #F4F7F5) | `#F4F7F5` (DNA asli terang) | `#1B2921` (hsl(135,20%,8%) — midnight hijau sage) |
| Cloud Dancer (Bg #F1F5F9) | `#F1F5F9` (DNA asli) | `#0D1117` (hsl(215,20%,7%) — midnight slate) |

---

## §2B. EXTENDED CSS TOKENS (Pelengkap Sistem Warna)

*Token tambahan yang REQUIRED ada untuk mencegah AI improvise dengan nilai acak:*

```css
:root {
  /* INTERACTIVE STATE TOKENS */
  --vibe-border:      rgba(128, 128, 128, 0.2);   /* Garis pembatas card/input default */
  --vibe-divider:     rgba(128, 128, 128, 0.12);  /* Pemisah section/horizontal rule */
  --vibe-input-bg:    rgba(128, 128, 128, 0.06);  /* Latar belakang field input form */
  --vibe-hover:       rgba(128, 128, 128, 0.08);  /* Warna hover state row/item */
  --vibe-focus-ring:  var(--raw-palette-accent-1); /* Warna outline focus accessibility */
  --vibe-overlay:     rgba(0, 0, 0, 0.5);         /* Backdrop modal/drawer */
  --vibe-skeleton:    rgba(128, 128, 128, 0.15);  /* Warna dasar skeleton loader */
}

[data-theme="dark"] {
  --vibe-border:      rgba(255, 255, 255, 0.12);
  --vibe-divider:     rgba(255, 255, 255, 0.08);
  --vibe-input-bg:    rgba(255, 255, 255, 0.05);
  --vibe-hover:       rgba(255, 255, 255, 0.06);
  --vibe-focus-ring:  var(--raw-palette-accent-1);
  --vibe-overlay:     rgba(0, 0, 0, 0.7);
  --vibe-skeleton:    rgba(255, 255, 255, 0.08);
}
```

### Aturan Penggunaan Token Interaktif:
| Token | Peruntukan Wajib |
|---|---|
| `--vibe-border` | Semua `border` pada card, input, table cell |
| `--vibe-divider` | Horizontal rule, pemisah sidebar menu |
| `--vibe-input-bg` | Background `<input>`, `<textarea>`, `<select>` |
| `--vibe-hover` | `:hover` state pada baris tabel, list item, menu |
| `--vibe-focus-ring` | `outline` / `box-shadow` saat `:focus-visible` |
| `--vibe-overlay` | Backdrop gelap di belakang modal/drawer |
| `--vibe-skeleton` | Animasi skeleton loader saat fetching data |

---

## §3. TYPOGRAPHY HIERARCHY

| Tag | Size | Weight | Line-Height | Keterangan |
|---|---|---|---|---|
| H1 | `24–32px` / `2rem` | Bold (700) | 1.25 | Hero title, judul halaman |
| H2 | `20px` / `1.5rem` | Semi-Bold (600) | 1.35 | Section title, sub-judul |
| Body | `16px` / `1rem` | Regular (400) | 1.5 | Isi konten, form label |
| Small | `14px` / `0.875rem` | Light/Regular (300–400) | 1.4 | Badge, toast, keterangan |

### Aturan text-wrap Modern (REQUIRED — CSS 2026)
```css
/* REQUIRED: Anti-widow dan heading rapi otomatis */
h1, h2, h3 {
  text-wrap: balance;   /* Distribusi baris merata — REQUIRED untuk heading */
}

p, li, blockquote {
  text-wrap: pretty;    /* Hindari orphan kata di baris terakhir paragraf */
}

/* FORBIDDEN: biarkan text-wrap: wrap default pada heading — hasilnya tidak rapi */
```

### Font Family Options:
- **Sans-Serif Modern:** Inter | Geist | Outfit | Satoshi | Cabinet Grotesk
- **Serif Elegan:** Playfair Display | EB Garamond | Cormorant Garamond
- **Official Clean:** Roboto | Open Sans
- **Monospace:** JetBrains Mono | Fira Code

> ⚠️ **FONT DISCOURAGED AS DEFAULT (BANNED):**
> - `Fraunces` dan `Instrument Serif` — LLM default serif, terlalu predictable
> - `Inter` sebagai **satu-satunya font** — REQUIRED pairing dengan 1 heading font
> - `Inter` di heading jika brief tidak mensyaratkan "neutral/Linear-style"
>
> **Preferred heading alternatives:** Geist, Outfit, Cabinet Grotesk, Satoshi, GT America

**Font Loading — Development vs Production (PENTING):**

```html
<!-- ✅ DEVELOPMENT ONLY — Google Fonts CDN -->
<!-- Acceptable di localhost, FORBIDDEN di production (render-blocking) -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
```

```jsx
/* ✅ PRODUCTION — Next.js (next/font — zero layout shift, zero CDN request) */
import { Inter, Outfit } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-sans',
});
const outfit = Outfit({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-heading',
});
// Tambahkan className={`${inter.variable} ${outfit.variable}`} ke <html>
```

```css
/* ✅ PRODUCTION — PHP Native/Laravel/Astro (@font-face self-hosted) */
/* Download font dari fonts.google.com → letakkan di /public/fonts/ */
@font-face {
  font-family: 'Outfit';
  src: url('/fonts/outfit-variable.woff2') format('woff2');
  font-weight: 100 900; /* Variable font range */
  font-display: swap;   /* REQUIRED — anti-FOIT */
  font-style: normal;
}
@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter-variable.woff2') format('woff2');
  font-weight: 100 900;
  font-display: swap;
  font-style: normal;
}
```

**CSS Global Wajib (REQUIRED ditulis eksplisit di `app.css` / `global.css`):**

```css
/* REQUIRED: Dua font — heading + body. FORBIDDEN Inter sendirian */
:root {
  --font-sans:    'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
  --font-heading: 'Outfit', 'Cabinet Grotesk', 'Inter', system-ui, sans-serif;
  --font-serif:   'Playfair Display', Georgia, 'Times New Roman', serif;
  --font-mono:    'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
}

body {
  font-family: var(--font-sans);
  font-size: 1rem;       /* 16px base */
  font-weight: 400;
  line-height: 1.5;
}

/* REQUIRED: Heading pakai font berbeda dari body */
h1, h2, h3 {
  font-family: var(--font-heading);
}

h1 { font-size: clamp(1.75rem, 4vw, 2.5rem); font-weight: 700; line-height: 1.25; text-wrap: balance; }
h2 { font-size: 1.5rem;    font-weight: 600; line-height: 1.35; text-wrap: balance; }
h3 { font-size: 1.25rem;   font-weight: 600; line-height: 1.4;  text-wrap: balance; }
p, li  { text-wrap: pretty; }
small, .text-sm { font-size: 0.875rem; line-height: 1.4; }
```


---

## §4. SHADOW & ELEVATION SYSTEM

```css
/* Soft (Pasif/Idle) */
box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);

/* Hover/Glow (Aktif — REQUIRED kombinasi dengan transition + transform) */
box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
transition: all 0.2s ease-in-out;
transform: translateY(-4px); /* Efek angkat ringan saat hover */
```

---

## §5. Z-INDEX MAP (Anti-Tabrakan Elemen)

| Level | Value | Peruntukan |
|---|---|---|
| Base | `0` | Konten utama, grid background |
| Overlap | `10` | Card mengambang ringan |
| Dropdown | `50` | Dropdown menu, tooltip, popover |
| Navigation | `100` | Sticky navbar, fixed sidebar |
| Drawer | `500` | Mobile drawer, hamburger overlay, floating dock |
| Modal | `999` | Modal dialog, toast system, fullscreen overlay |

---

## §6. SPACING SYSTEM (8-Point Grid)

| Token | Value | Contoh Penggunaan |
|---|---|---|
| XS | `4px` | Gap antar ikon dalam button |
| S | `8px` | Padding internal badge/tag |
| M | `16px` | Padding card, gap form field |
| L | `24px` | Margin section, gap grid column |
| XL | `32px` | Padding hero section, antar section |

**Aturan:** FORBIDDEN hardcode nilai acak (13px, 19px, 21px). Selalu gunakan kelipatan 8.

---

## §7. COMPONENT COLOR SEMANTICS (Status Badge)

| Status | CSS Variable | Nilai Hex Default | Penggunaan |
|---|---|---|---|
| Success | `var(--vibe-success)` | `#00E676` | Aktif, terverifikasi, berhasil, badge hijau |
| Warning | `var(--vibe-warning)` | `#FFD600` | Menunggu, pending, perhatian, badge kuning |
| Danger / Error | `var(--vibe-error)` | `#FF3E3E` | Gagal, blokir, admin-only, badge merah |

**Aturan Implementasi:**
- AI **REQUIRED** menggunakan variabel CSS di atas (`var(--vibe-success)` dst) pada semua badge/tag status — **FORBIDDEN** hardcode hex warna status secara langsung.
- Token ini dideklarasikan di `:root` (bukan di `[data-theme]`) sehingga **tidak berubah** antar mode light/dark.
- Geometri badge mengikuti setting **Geometri Box** dari hasil wawancara (Sharp 0px / Rounded 6-8px / Pill penuh).

```css
/* Contoh implementasi badge status yang benar: */
.badge-success { background-color: var(--vibe-success); color: #000; }
.badge-warning { background-color: var(--vibe-warning); color: #000; }
.badge-danger  { background-color: var(--vibe-error);   color: #fff; }
```

---

## §7B. COMPONENT TOKEN REGISTRY (Single Source of Truth) <!-- anchor:7B -->

> ⚠️ **HARD RULE:** Setiap kali AI menulis komponen UI (button, modal, toast, card, form, icon),
> AI REQUIRED menggunakan token dari section ini. FORBIDDEN improvise nilai acak.
> Jika proyek sudah punya `prd.md §3` yang menetapkan geometry/radius → ikuti prd.md.
> Jika belum ada prd.md → gunakan default di bawah sebagai starting point.

### §7B.1 BUTTON TOKENS

```css
:root {
  /* === SIZING === */
  --btn-height-sm:    32px;    /* inline action, table row */
  --btn-height-md:    40px;    /* default form submit */
  --btn-height-lg:    48px;    /* hero CTA, standalone */
  --btn-height-xl:    56px;    /* full-width mobile CTA */

  --btn-padding-sm:   8px 16px;
  --btn-padding-md:   10px 24px;
  --btn-padding-lg:   14px 32px;

  /* === TYPOGRAPHY === */
  --btn-font:         var(--vibe-font-main);
  --btn-font-size-sm: 0.8125rem;  /* 13px */
  --btn-font-size-md: 0.875rem;   /* 14px */
  --btn-font-size-lg: 1rem;       /* 16px */
  --btn-font-weight:  600;
  --btn-letter-spacing: 0.01em;

  /* === SHAPE === */
  --btn-radius:       var(--radius-md);  /* dari prd.md — Sharp:0 / Rounded:8px / Pill:9999px */
  --btn-border:       none;              /* solid: 1.5px solid var(--vibe-border) */

  /* === INTERACTION === */
  --btn-transition:   var(--vibe-transition);
  --btn-hover-lift:   translateY(-1px);
  --btn-active-press: translateY(0) scale(0.98);
  --btn-focus-ring:   0 0 0 3px var(--vibe-focus-ring);

  /* === ICON DI DALAM BUTTON === */
  --btn-icon-size:    1em;       /* relatif ke font-size button */
  --btn-icon-gap:     var(--space-xs, 4px);
}
```

**Variant Rules:**
| Variant | Background | Text | Border | Kapan Pakai |
|---|---|---|---|---|
| `primary` | `var(--vibe-accent-1)` | `var(--vibe-background)` | none | CTA utama — max 1 per section |
| `secondary` | `transparent` | `var(--vibe-accent-1)` | `1.5px solid var(--vibe-accent-1)` | Aksi sekunder |
| `ghost` | `transparent` | `var(--vibe-text-sub)` | none | Link-like, toolbar |
| `danger` | `var(--vibe-error)` | `#fff` | none | Hapus, batalkan, aksi destruktif |

**HARD BLOCKS:**
- FORBIDDEN button tanpa `min-height` — gunakan `--btn-height-*`
- FORBIDDEN mix variant dalam 1 button group (primary + primary = salah)
- FORBIDDEN `border-radius` hardcode — gunakan `var(--btn-radius)`
- FORBIDDEN label > 3 kata per button
- FORBIDDEN `cursor: pointer` manual — button sudah default pointer

### §7B.2 ICON TOKENS

```css
:root {
  /* === SIZING SCALE === */
  --icon-xs:          14px;    /* inline text, badge, meta */
  --icon-sm:          16px;    /* nav item, list prefix */
  --icon-md:          20px;    /* default UI icon */
  --icon-lg:          24px;    /* card header, toolbar */
  --icon-xl:          32px;    /* empty state, feature */
  --icon-hero:        48px;    /* hero section, onboarding */

  /* === WARNA === */
  --icon-color:       var(--vibe-text-sub);      /* default */
  --icon-color-active: var(--vibe-accent-1);     /* active/selected */
  --icon-color-muted: var(--vibe-text-sub);      /* disabled state — opacity 0.4 */

  /* === STROKE === */
  --icon-stroke:      1.5;     /* default stroke-width untuk outline icons */
}
```

**HARD BLOCKS:**
- FORBIDDEN ikon SVG hand-rolled (path mentah di HTML) — gunakan icon library proyek
- FORBIDDEN campur icon library — ONE family rule
- FORBIDDEN ikon tanpa `aria-hidden="true"` (kecuali ikon satu-satunya elemen interaktif)
- FORBIDDEN ikon tanpa explicit `width`/`height` — gunakan `--icon-*` token

### §7B.3 MODAL / DIALOG TOKENS

```css
:root {
  /* === SIZING === */
  --modal-width-sm:    400px;    /* konfirmasi, alert */
  --modal-width-md:    560px;    /* form, detail */
  --modal-width-lg:    720px;    /* tabel, preview */
  --modal-width-full:  calc(100vw - 48px);  /* mobile */
  --modal-max-height:  calc(100dvh - 48px);

  /* === SPACING === */
  --modal-padding:     var(--space-lg, 24px);
  --modal-header-gap:  var(--space-md, 16px);
  --modal-footer-gap:  var(--space-md, 16px);

  /* === SHAPE === */
  --modal-radius:      calc(var(--radius-md) * 1.5);  /* sedikit lebih besar dari card */
  --modal-shadow:      var(--shadow-dialog);

  /* === OVERLAY === */
  --modal-overlay:     var(--vibe-overlay);
  --modal-overlay-blur: 4px;   /* backdrop-filter: blur() */
}
```

**Anatomy Wajib:**
```
┌────────────────────────────┐
│ [Icon?] Title          [✕] │  ← header: --modal-padding, border-bottom: --vibe-divider
│────────────────────────────│
│                            │
│  Body Content              │  ← body: --modal-padding, overflow-y: auto
│                            │
│────────────────────────────│
│          [Cancel] [Action] │  ← footer: --modal-padding, gap: --space-sm
└────────────────────────────┘
```

**HARD BLOCKS:**
- FORBIDDEN modal tanpa overlay backdrop — gunakan `var(--modal-overlay)`
- FORBIDDEN modal tanpa close button (✕) atau ESC handler
- FORBIDDEN modal yang menutupi >90% viewport di desktop — max `--modal-width-lg`
- FORBIDDEN scroll pada body saat modal terbuka — gunakan `body { overflow: hidden }`

### §7B.4 TOAST / NOTIFICATION TOKENS

```css
:root {
  /* === SIZING === */
  --toast-width:       360px;
  --toast-min-height:  48px;
  --toast-max-width:   calc(100vw - 32px);  /* mobile */

  /* === SPACING === */
  --toast-padding:     12px 16px;
  --toast-gap:         var(--space-sm, 8px);   /* antar elemen di dalam toast */
  --toast-stack-gap:   var(--space-sm, 8px);   /* gap antar toast bertumpuk */

  /* === POSITION === */
  --toast-position:    fixed;
  --toast-inset:       auto 16px 16px auto;    /* bottom-right default */
  --toast-z:           var(--z-toast, 9000);

  /* === SHAPE === */
  --toast-radius:      var(--radius-md);
  --toast-shadow:      var(--shadow-dialog);

  /* === TIMING === */
  --toast-duration:    4000ms;       /* auto-dismiss */
  --toast-enter:       200ms ease-out;
  --toast-exit:        150ms ease-in;
}
```

**Variant Colors:**
| Variant | Icon | BG | Border-left |
|---|---|---|---|
| `success` | ✓ checkmark | `var(--vibe-success)` 10% opacity | `3px solid var(--vibe-success)` |
| `error` | ✕ cross | `var(--vibe-error)` 10% opacity | `3px solid var(--vibe-error)` |
| `warning` | ⚠ triangle | `var(--vibe-warning)` 10% opacity | `3px solid var(--vibe-warning)` |
| `info` | ℹ circle | `var(--vibe-accent-1)` 10% opacity | `3px solid var(--vibe-accent-1)` |

**HARD BLOCKS:**
- FORBIDDEN toast yang blocking — harus auto-dismiss setelah `--toast-duration`
- FORBIDDEN toast tanpa dismiss button (✕)
- FORBIDDEN lebih dari 3 toast visible bersamaan — yang lama auto-dismiss

### §7B.5 FORM ELEMENT TOKENS

```css
:root {
  /* === INPUT === */
  --input-height:      40px;
  --input-padding:     10px 14px;
  --input-bg:          var(--vibe-input-bg);
  --input-border:      1.5px solid var(--vibe-border);
  --input-radius:      var(--radius-md);
  --input-font-size:   0.875rem;    /* 14px — FORBIDDEN < 14px untuk readability */

  /* === LABEL === */
  --label-font-size:   0.8125rem;   /* 13px */
  --label-font-weight: 500;
  --label-color:       var(--vibe-text-sub);
  --label-gap:         var(--space-xs, 4px);  /* gap label ke input */

  /* === STATE === */
  --input-focus-border: var(--vibe-accent-1);
  --input-focus-ring:   0 0 0 3px rgba(var(--vibe-focus-ring), 0.15);
  --input-error-border: var(--vibe-error);
  --input-disabled-opacity: 0.5;

  /* === HELPER TEXT === */
  --helper-font-size:  0.75rem;     /* 12px */
  --helper-color:      var(--vibe-text-sub);
  --helper-error-color: var(--vibe-error);
  --helper-gap:        var(--space-xs, 4px);  /* gap input ke helper */

  /* === FORM LAYOUT === */
  --form-field-gap:    var(--space-md, 16px);  /* gap antar field */
  --form-group-gap:    var(--space-lg, 24px);  /* gap antar group/section */
}
```

**HARD BLOCKS:**
- FORBIDDEN input tanpa label (gunakan `<label>` atau `aria-label`)
- FORBIDDEN input `font-size` < 14px — iOS zoom issue
- FORBIDDEN placeholder sebagai pengganti label — hanya sebagai hint
- FORBIDDEN form tanpa error state visual (border merah + helper text)
- FORBIDDEN submit button tanpa loading state

### §7B.6 CARD TOKENS

```css
:root {
  /* === SPACING === */
  --card-padding:      var(--space-lg, 24px);
  --card-padding-compact: var(--space-md, 16px);  /* card kecil/dense grid */
  --card-gap:          var(--space-md, 16px);      /* gap antar card dalam grid */
  --card-content-gap:  var(--space-sm, 8px);       /* gap antar elemen di dalam card */

  /* === SHAPE === */
  --card-radius:       var(--radius-md);
  --card-border:       1px solid var(--vibe-border);
  --card-shadow:       var(--shadow-card, none);   /* dari §4 Shadow System */
  --card-bg:           var(--vibe-surface);

  /* === HOVER === */
  --card-hover-shadow: var(--shadow-hover);
  --card-hover-lift:   translateY(-2px);
  --card-hover-transition: var(--vibe-transition);
}
```

**HARD BLOCKS:**
- FORBIDDEN card tanpa `border` atau `box-shadow` — minimal salah satu untuk visual boundary
- FORBIDDEN mix `--card-radius` dan `--btn-radius` yang berbeda dalam satu halaman (kecuali documented geometry kustom di taste-skill §0.J-4)
- FORBIDDEN `padding` hardcode pada card — gunakan `var(--card-padding)`

### §7B.7 SPACING SEMANTIC TOKENS (Per Komponen)

> Mapping spacing token (§6) ke komponen spesifik — mencegah "spacing acak" lintas halaman.

```css
:root {
  /* === SPACING ALIASES (dari §6 8pt grid) === */
  --space-xs:   4px;
  --space-sm:   8px;
  --space-md:   16px;
  --space-lg:   24px;
  --space-xl:   32px;
  --space-2xl:  48px;
  --space-3xl:  64px;

  /* === SECTION SPACING === */
  --section-padding-y:   var(--space-3xl);    /* 64px — padding atas/bawah section */
  --section-padding-y-sm: var(--space-2xl);   /* 48px — section kecil/compact */
  --section-gap:         var(--space-2xl);    /* 48px — gap antar section (jika pakai flex/grid) */

  /* === CONTAINER === */
  --container-max:       72rem;               /* 1152px — max-width content */
  --container-padding:   clamp(1rem, 5vw, 2rem);  /* responsive side padding */

  /* === COMPONENT INTERNAL SPACING MAP === */
  /* Gunakan token ini BUKAN angka acak */
}
```

| Komponen | padding | gap internal | margin-bottom |
|---|---|---|---|
| Section | `--section-padding-y` `--container-padding` | `--space-xl` | 0 (pakai gap/padding section berikutnya) |
| Card | `--card-padding` | `--card-content-gap` | 0 (pakai grid gap) |
| Button | `--btn-padding-*` | `--btn-icon-gap` | — |
| Form field | — | `--label-gap` (label→input), `--helper-gap` (input→helper) | `--form-field-gap` |
| Form group | — | `--form-field-gap` | `--form-group-gap` |
| Modal | `--modal-padding` | `--modal-header-gap` / `--modal-footer-gap` | — |
| Toast | `--toast-padding` | `--toast-gap` | `--toast-stack-gap` |
| Nav | `--space-md` | `--space-sm` | — |
| Hero | `--section-padding-y` | `--space-lg` | — |
| Footer | `--section-padding-y` | `--space-lg` | — |

**HARD BLOCKS:**
- FORBIDDEN spacing hardcode (13px, 19px, 21px, 7px) — wajib kelipatan 8pt atau gunakan token di atas
- FORBIDDEN `margin-top` dan `margin-bottom` bersamaan pada 1 elemen — pilih salah satu arah (bottom-only atau gap-based)
- FORBIDDEN section tanpa `--section-padding-y` — minimal 48px

---

### §7B Enforcement Rule (Wajib Diikuti AI)

AI REQUIRED melakukan hal berikut saat menulis komponen UI:
1. **Cek §7B** terlebih dahulu — apakah komponen yang ditulis sudah ada tokennya
2. **Gunakan token** — FORBIDDEN menulis nilai mentah jika token tersedia
3. **Jika token belum ada** — deklarasikan token baru di `:root` mengikuti pola penamaan `--[komponen]-[properti]`, lalu catat di `[DESIGN TOKEN] Menambah: --[nama-token]: [nilai]`
4. **Cross-check consistency** — pastikan `--btn-radius`, `--card-radius`, `--modal-radius`, `--toast-radius` semua mengacu ke `--radius-md` (atau varian documented)

```

## §8. LAYOUT RULES

### Sidebar + Content Layout (Anti-Clipping):
```css
/* Sidebar — FORBIDDEN biarkan menyusut */
.sidebar {
  flex-shrink: 0;
  min-width: 240px; /* atau nilai fixed sesuai desain */
}

/* Content area — anti-clipping tabel */
.content-area {
  overflow-x: auto;
  flex: 1;
}
```

### Vanilla CSS Utility Engine (REQUIRED jika tanpa framework CSS):
```css
/* Responsive breakpoints */
@media (max-width: 768px) { /* mobile rules */ }
@media (min-width: 1024px) { /* desktop rules */ }

/* Layout helpers */
.d-flex { display: flex; }
.flex-column { flex-direction: column; }
.grid-layout { display: grid; }
.w-full { width: 100%; }
```

---

## §9. NAVIGATION STATE LOGIC

> **[REFERENSI SILANG]** Spesifikasi teknis 3 state navigasi (Guest / Member / Admin) ada di **`gemini-execution.md §4A`** — bukan di file ini.
> `design-system.md` hanya menyimpan referensi visual. Logika implementasi navigasi sepenuhnya diatur oleh `gemini-execution.md`.

---

## §10. MOBILE NAVIGATION & UX RULES (WAJIB DIIMPLEMENTASIKAN)

*AI REQUIRED mematuhi aturan mobile UX ini untuk SETIAP proyek yang memiliki navigasi. Mobile experience yang buruk = kegagalan produk.*

### A. Mobile Navigation Mode (Pilihan Wawancara)

AI REQUIRED menanyakan pilihan Mobile Navigation Mode saat wawancara, dan mencatatnya di `prd.md Bab 4 (Advanced Layouting)`:

| Mode | Perilaku | Tampilan | Cocok Untuk |
|---|---|---|---|
| **Bottom Tab Bar** *(Default)* | Auto-convert dari Top Navbar di `≤768px` — sticky ke bawah layar | 3–5 ikon + label teks | Web app, dashboard, fitur banyak |
| **Floating Header** *(Opsional)* | Card melayang di atas dengan blur backdrop — bukan fixed full-width | Compact, transparan, glassmorphism | Blog, portfolio, landing page |

### B. Bottom Tab Bar — Implementasi Wajib

```css
/* REQUIRED: Deteksi mobile — sembunyikan top navbar, tampilkan bottom nav */
@media (max-width: 768px) {
  .top-navbar { display: none; }  /* Sembunyikan navbar desktop */

  .bottom-nav {
    display: flex;
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 100;
    background: var(--vibe-surface);
    border-top: 1px solid var(--vibe-border);
    /* REQUIRED: safe-area-inset untuk iPhone home indicator */
    padding-bottom: env(safe-area-inset-bottom, 0px);
    padding-bottom: max(env(safe-area-inset-bottom), 8px);
  }

  /* REQUIRED: Minimum touch target 48x48px (Material Design standard) */
  .bottom-nav__item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 48px;
    gap: 4px;
    padding: 8px 4px;
    cursor: pointer;
    /* Anti-tap flash — REQUIRED */
    -webkit-tap-highlight-color: transparent;
    tap-highlight-color: transparent;
  }

  /* REQUIRED: Content area harus beri ruang untuk bottom nav */
  .main-content {
    padding-bottom: calc(64px + env(safe-area-inset-bottom, 0px));
  }
}

/* REQUIRED: Desktop — sembunyikan bottom nav */
@media (min-width: 769px) {
  .bottom-nav { display: none; }
  .top-navbar { display: flex; }
}
```

### C. Floating Header — Implementasi Opsional

```css
/* Pilih ini jika mode = Floating Header */
@media (max-width: 768px) {
  .floating-header {
    position: fixed;
    top: 12px;
    left: 16px;
    right: 16px;
    z-index: 100;
    border-radius: 16px;  /* Pill-like rounded */
    background: rgba(var(--vibe-surface-rgb), 0.85);
    backdrop-filter: blur(16px) saturate(180%);
    -webkit-backdrop-filter: blur(16px) saturate(180%);
    border: 1px solid var(--vibe-border);
    padding: 12px 16px;
    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.12);
    /* REQUIRED: safe-area-inset untuk status bar iPhone */
    top: calc(12px + env(safe-area-inset-top, 0px));
  }
}
```

### D. Mobile UX Mandatory Rules (Berlaku Semua Mode)

```css
/* REQUIRED di CSS global — anti mobile UX bugs */

/* 1. Anti-tap flash pada semua interactive element */
* { -webkit-tap-highlight-color: transparent; }

/* 2. Anti-scroll overflow pada modal/drawer */
.modal-open { overscroll-behavior: contain; }
.drawer { overscroll-behavior: none; }

/* 3. Touch target minimum — REQUIRED untuk tombol dan link */
button, a, [role="button"] {
  min-height: 44px;  /* Apple HIG minimum */
  min-width: 44px;
}

/* 4. REQUIRED: Viewport meta tag di setiap HTML — pastikan ada di <head> */
/* <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"> */
/* viewport-fit=cover — REQUIRED untuk safe area support */

/* 5. Scroll smooth native — ONLY jika prefers-reduced-motion: no-preference */
@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; }
}

/* 6. REQUIRED: Hero section height — FORBIDDEN h-screen/100vh */
/* Alasan: 100vh di iOS Safari = include address bar → layout jump saat scroll */
.hero-section,
[data-hero] {
  min-height: 100vh;    /* Fallback — semua browser, termasuk lama */
  min-height: 100dvh;   /* Override — browser support dvh (fix iOS Safari address bar) */
}

/* 7. REQUIRED: prefers-reduced-motion — Global animation kill-switch */
/* Letakkan di baris PALING ATAS file CSS global, sebelum komponen apapun */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### E. Mobile-First Breakpoint Strategy (Container Queries 2026)

```css
/* REQUIRED 2026: Gunakan Container Queries untuk komponen — bukan hanya viewport */
/* @supports guard — aman di browser lama */
@supports (container-type: inline-size) {
  .card-grid {
    container-type: inline-size;
    container-name: card-grid;
  }

  @container card-grid (min-width: 400px) {
    .card { /* layout untuk container lebar */ }
  }

  @container card-grid (max-width: 399px) {
    .card { /* layout untuk container sempit */ }
  }
}

/* Viewport breakpoint — tetap dipakai untuk layout makro */
@media (max-width: 768px)  { /* mobile  */ }
@media (min-width: 769px) and (max-width: 1023px) { /* tablet */ }
@media (min-width: 1024px) { /* desktop */ }
```

---

## §11. COLOR SWITCHER SYSTEM (APPEARANCE PANEL)

*Fitur opsional — aktifkan dengan memilih "Color Switcher: Aktif" saat wawancara. Dicatat di `prd.md Bab 3 (Design System)`.*

### A. Konsep Arsitektur

Appearance Panel = satu drawer/modal berisi 2 kontrol:
1. **Dark/Light Mode toggle** (sudah ada di §2)
2. **Palette Switcher** — 3–5 palet dikurasi AI, tersimpan di `localStorage`

### B. Aturan Kurasi AI (Wajib Dipatuhi)

- AI REQUIRED memilih **3–5 palet alternatif** dari 15 kluster `design-system.md §1` yang **harmonis** dengan palet utama
- Kriteria harmonis: sama vibrasi karakter (misal: semua dark/moody, atau semua clean/minimal)
- Palet utama dari wawancara = **default fallback** — tetap 🔒 IMMUTABLE
- Palet alternatif REQUIRED dicatat di `prd.md Bab 3 (Design System)` dengan alasan kurasi
- Jumlah maksimal: **5 palet** (termasuk palet utama) — FORBIDDEN lebih dari 5

### C. Implementasi CSS (data-palette + @layer)

```css
/* REQUIRED: Setiap palette = satu set raw token di @layer tokens */
@layer tokens {
  /* Palet Utama (IMMUTABLE default) */
  :root,
  [data-palette="primary"] {
    --raw-palette-bg:       oklch(/* nilai palet utama */);
    --raw-palette-accent-1: oklch(/* nilai palet utama */);
    /* ... semua token palet utama */
  }

  /* Palet Alternatif 1 (dikurasi AI) */
  [data-palette="alt-1"] {
    --raw-palette-bg:       oklch(/* nilai palet alt-1 */);
    --raw-palette-accent-1: oklch(/* nilai palet alt-1 */);
  }

  /* Palet Alternatif 2 */
  [data-palette="alt-2"] {
    --raw-palette-bg:       oklch(/* nilai palet alt-2 */);
    --raw-palette-accent-1: oklch(/* nilai palet alt-2 */);
  }
}
```

### D. Implementasi JavaScript (localStorage Sync)

```javascript
/**
 * Color Switcher — semua pengunjung, tersimpan di localStorage
 * Tidak perlu login. Preferensi per browser.
 */
const COLOR_SWITCHER = {
  // Inisialisasi saat halaman load
  init() {
    const saved = localStorage.getItem('app-palette') || 'primary';
    this.apply(saved);
  },

  // Terapkan palette ke <html> element
  apply(paletteKey) {
    document.documentElement.setAttribute('data-palette', paletteKey);
    localStorage.setItem('app-palette', paletteKey);
  },

  // Reset ke palet utama
  reset() {
    this.apply('primary');
  }
};

// REQUIRED: Panggil sebelum DOM render untuk mencegah flash of wrong palette
COLOR_SWITCHER.init();

// PHP/Blade equivalent:
// <script>document.documentElement.setAttribute('data-palette', localStorage.getItem('app-palette') || 'primary')</script>
// REQUIRED di <head> — sebelum CSS load
```

### E. Komponen UI Appearance Panel

```html
<!-- Appearance Panel — drawer/modal berisi dark mode + palette switcher -->
<div class="appearance-panel" role="dialog" aria-label="Pengaturan Tampilan">
  <!-- Bagian 1: Dark/Light Toggle -->
  <div class="appearance-section">
    <span>Mode Tampilan</span>
    <button class="theme-toggle" aria-label="Ganti mode gelap/terang"
            onclick="toggleTheme()">
      <!-- Icon sun/moon — ganti sesuai state -->
    </button>
  </div>

  <!-- Bagian 2: Palette Switcher -->
  <div class="appearance-section">
    <span>Warna Tema</span>
    <div class="palette-grid">
      <!-- AI REQUIRED generate dot swatch untuk setiap palet yang dikurasi -->
      <button class="palette-swatch"
              data-palette-key="primary"
              style="background: var(--raw-palette-accent-1)"
              aria-label="Palet Utama"
              onclick="COLOR_SWITCHER.apply('primary')">
      </button>
      <!-- Ulangi untuk alt-1, alt-2, dst -->
    </div>
  </div>
</div>
```

### F. Aturan Appearance Panel Trigger

| Jika | Tampilkan Appearance Panel via |
|---|---|
| Dark Mode aktif + Color Switcher aktif | Icon di navbar (palette icon) — buka drawer |
| Dark Mode aktif saja (no switcher) | Icon sun/moon toggle biasa |
| Color Switcher aktif saja (no dark mode) | Icon palette di navbar |
| Keduanya tidak aktif | Tidak ada tombol appearance |

---

## §12. MODERN CSS 2026 QUICK REFERENCE

*Fitur CSS yang REQUIRED dipertimbangkan AI saat generate komponen — menggantikan JavaScript-heavy solutions.*

| Fitur CSS | Menggantikan | Contoh Penggunaan | Browser Support |
|---|---|---|---|
| **Container Queries** `@container` | JS resize observer | Card layout responsif | Chrome 105+, Firefox 110+, Safari 16+ |
| **`:has()` selector** | JS class toggling | Form state, parent-child styling | Chrome 105+, Firefox 121+, Safari 15.4+ |
| **`text-wrap: balance`** | Manual line-break | Heading rapi | Chrome 114+, Firefox 121+, Safari 17.5+ |
| **View Transitions API** | GSAP page transition | Cross-page animation | Chrome 111+, Safari 18+ |
| **Scroll-driven Animations** | Intersection Observer | Parallax, progress bar | Chrome 115+, Firefox 110+ |
| **`light-dark()` function** | Manual dark mode | `color: light-dark(#000, #fff)` | Chrome 123+, Firefox 120+, Safari 17.5+ |
| **`color-mix()` function** | SASS darken/lighten | Tint/shade generation | Chrome 111+, Firefox 113+, Safari 16.2+ |
| **`@property`** | JS variable animation | Animasi CSS custom properties | Chrome 85+, Firefox 128+, Safari 16.4+ |
| **`oklch()`** | HEX/HSL | Perceptually uniform color | Chrome 111+, Firefox 113+, Safari 15.4+ |
| **`dvh/svh/lvh`** | `vh` iOS bug fix | Hero height fix iOS Safari | Chrome 108+, Firefox 101+, Safari 15.4+ |

### oklch() Browser Compatibility Fallback (REQUIRED)

```css
/* REQUIRED: Selalu sertakan HEX fallback sebelum oklch() */
/* Browser lama akan pakai baris pertama, browser modern pakai oklch() */
:root {
  /* Pattern: hex dulu, oklch override */
  --vibe-primary: #FF6B00;                    /* Fallback HEX — semua browser */
  --vibe-primary: oklch(65% 0.22 35);         /* Modern — Chrome 111+, FF 113+, Safari 15.4+ */

  --vibe-background: #111111;                 /* Fallback */
  --vibe-background: oklch(10% 0 0);          /* Modern */
}

/* ALTERNATIF: gunakan @supports untuk isolasi penuh */
@supports (color: oklch(0% 0 0)) {
  :root {
    --vibe-primary: oklch(65% 0.22 35);
    --vibe-background: oklch(10% 0 0);
  }
}
```

### dvh Viewport Unit Fallback (REQUIRED untuk Hero)

```css
/* REQUIRED: Pattern 2-line fallback untuk hero height */
.hero-section {
  min-height: 100vh;   /* Line 1: Fallback — semua browser */
  min-height: 100dvh;  /* Line 2: Override — browser support dvh (fix iOS Safari) */
}

/* FORBIDDEN: Gunakan h-screen / height: 100vh saja tanpa fallback dvh */
/* Alasan: iOS Safari 100vh = include address bar → layout jump saat scroll */
```

### View Transitions (dengan prefers-reduced-motion guard)

```css
/* REQUIRED: Selalu wrap View Transitions dalam prefers-reduced-motion guard */
@media (prefers-reduced-motion: no-preference) {
  @view-transition {
    navigation: auto;
  }

  ::view-transition-old(root) {
    animation: fade-out 0.15s ease;
  }
  ::view-transition-new(root) {
    animation: fade-in 0.15s ease;
  }
}
```

### :has() — State-Based Parent Styling

```css
/* Form validation state */
.form-group:has(input:invalid) {
  border-color: var(--vibe-error);
}

/* Dim cards saat salah satu di-hover */
.card-grid:has(.card:hover) .card:not(:hover) {
  opacity: 0.7;
  transition: opacity var(--vibe-transition);
}

/* ALWAYS tambahkan @supports guard untuk :has() */
@supports selector(:has(*)) {
  /* :has() rules di sini */
}
```

---

## §13. LOCAL SVG STYLING & oklch() INTEGRATION

Semua SVG brand dan ikon utama yang disimpan secara lokal wajib diintegrasikan dengan arsitektur warna oklch() agar warna aset dapat berubah secara dinamis sesuai state dan tema.

### A. Contoh Struktur SVG Lokal (Inline)
Untuk logo merk/brand atau ikon interaktif, disarankan merendernya secara inline atau sebagai komponen agar properti fill/stroke-nya dapat dikontrol via CSS. 

Contoh SVG logo yang diekstrak dapat dilihat di [brand-logo.svg](file:///c:/xampp/htdocs/brainvibes/config/skills/code-snippets/data/brand-logo.svg).

### B. CSS Styling dengan oklch()
Terapkan warna kustom dan transisi pada berkas CSS utama:

```css
@layer components {
  .brand-logo {
    width: 2.5rem;
    height: 2.5rem;
    color: var(--vibe-primary); /* Menentukan fill/stroke currentColor */
    transition: color 0.3s ease, transform 0.2s ease;
  }

  .brand-logo:hover {
    color: var(--vibe-accent-1);
    transform: scale(1.05);
  }
}
```

### C. Pemuatan via CSS Background (Static SVG File)
Jika SVG lokal dipanggil sebagai berkas latar belakang statis, warna di dalamnya harus di-hardcode ke oklch() yang sesuai atau dimanipulasi dengan filter. Namun, pemuatan inline sangat direkomendasikan untuk fleksibilitas visual yang dinamis.

---


