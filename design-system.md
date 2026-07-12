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

> **[REFERENSI SILANG]** Spesifikasi teknis 3 state navigasi (Guest / Member / Admin) ada di **`gemini.md §4A`** — bukan di file ini.
> `design-system.md` hanya menyimpan referensi visual. Logika implementasi navigasi sepenuhnya diatur oleh `gemini.md`.

---

## §10. MOBILE NAVIGATION & UX RULES (WAJIB DIIMPLEMENTASIKAN)

*AI REQUIRED mematuhi aturan mobile UX ini untuk SETIAP proyek yang memiliki navigasi. Mobile experience yang buruk = kegagalan produk.*

### A. Mobile Navigation Mode (Pilihan Wawancara)

AI REQUIRED menanyakan pilihan Mobile Navigation Mode saat wawancara, dan mencatatnya di `prd.md §4C`:

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

*Fitur opsional — aktifkan dengan memilih "Color Switcher: Aktif" saat wawancara. Dicatat di `prd.md §3H`.*

### A. Konsep Arsitektur

Appearance Panel = satu drawer/modal berisi 2 kontrol:
1. **Dark/Light Mode toggle** (sudah ada di §2)
2. **Palette Switcher** — 3–5 palet dikurasi AI, tersimpan di `localStorage`

### B. Aturan Kurasi AI (Wajib Dipatuhi)

- AI REQUIRED memilih **3–5 palet alternatif** dari 15 kluster `design-system.md §1` yang **harmonis** dengan palet utama
- Kriteria harmonis: sama vibrasi karakter (misal: semua dark/moody, atau semua clean/minimal)
- Palet utama dari wawancara = **default fallback** — tetap 🔒 IMMUTABLE
- Palet alternatif REQUIRED dicatat di `prd.md §3H` dengan alasan kurasi
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
Untuk logo merk/brand atau ikon interaktif, disarankan merendernya secara inline atau sebagai komponen agar properti fill/stroke-nya dapat dikontrol via CSS:

```html
<svg class="brand-logo" viewBox="0 0 100 100" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
  <!-- Gunakan currentColor agar fill mengikuti properti color CSS dari container -->
  <circle cx="50" cy="50" r="40" fill="currentColor" />
  <path d="M30 50 L70 50" stroke="var(--vibe-accent-1)" stroke-width="5" stroke-linecap="round" />
</svg>
```

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

## §14. ASTRO-SPECIFIC DESIGN SYSTEM EXAMPLES

Berikut adalah pola integrasi arsitektur token `oklch()`, `@layer`, dan Appearance Switcher di framework Astro 5+.

### A. Layout Utama (`src/layouts/Layout.astro`)

Layout utama wajib menginisialisasi tema di `<head>` sebelum konten dirender untuk menghindari kilatan visual kasar (Flash of Unthemed Content - FOUT):

```astro
---
// src/layouts/Layout.astro
import '../styles/global.css';

interface Props {
  title: string;
  description?: string;
}

const { title, description = "Deskripsi default aplikasi" } = Astro.props;
---

<!doctype html>
<html lang="id" data-theme="light" suppressHydrationWarning>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
    <title>{title}</title>
    <meta name="description" content={description} />
    
    <!-- Script Kritis Inisialisasi Tema (Inline & Pemblokir Sinkronis) -->
    <script is:inline>
      (function() {
        const theme = localStorage.getItem('theme') || 'light';
        document.documentElement.setAttribute('data-theme', theme);
        const palette = localStorage.getItem('app-palette') || 'primary';
        document.documentElement.setAttribute('data-palette', palette);
      })();
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  </head>
  <body>
    <slot />
  </body>
</html>
```

### B. Komponen SVG Inline Interaktif (`src/components/BrandLogo.astro`)

Mendukung modifikasi oklch secara dinamis melalui properti:

```astro
---
// src/components/BrandLogo.astro
interface Props {
  class?: string;
  size?: number;
}

const { class: className = "", size = 40 } = Astro.props;
---

<svg 
  class={`brand-logo ${className}`} 
  width={size} 
  height={size} 
  viewBox="0 0 100 100" 
  aria-hidden="true" 
  xmlns="http://www.w3.org/2000/svg"
>
  <!-- currentColor menggunakan properti color CSS induk -->
  <circle cx="50" cy="50" r="40" fill="currentColor" />
  <path d="M30 50 L70 50" stroke="var(--vibe-accent-1)" stroke-width="5" stroke-linecap="round" />
</svg>

<style>
  .brand-logo {
    display: inline-block;
    color: var(--vibe-primary);
    transition: var(--vibe-transition);
  }
  .brand-logo:hover {
    color: var(--vibe-secondary);
    transform: scale(1.05);
  }
</style>
```

### C. Astro View Transitions Integration

Gunakan `@view-transition` di CSS global. Jika menggunakan fitur View Transitions bawaan Astro, pastikan skrip inisialisasi tema berjalan kembali setelah transisi halaman:

```astro
---
// Layout.astro dengan Astro ViewTransitions
import { ClientRouter } from 'astro:transitions'; // Astro 5+ ClientRouter
---
<head>
  <!-- ... -->
  <ClientRouter />
  <script>
    // Jalankan kembali inisialisasi tema saat navigasi ClientRouter selesai
    document.addEventListener('astro:after-swap', () => {
      const theme = localStorage.getItem('theme') || 'light';
      document.documentElement.setAttribute('data-theme', theme);
    });
  </script>
</head>
```


