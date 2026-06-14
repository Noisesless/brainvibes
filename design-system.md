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

---

## §2. CSS TOKEN ARCHITECTURE

```css
/* ══════════════════════════════════════════
   ARSITEKTUR TOKEN WARNA ADAPTIF (TREN 2026)
   AI: Isi nilai berdasarkan palet yang dipilih saat wawancara
   ══════════════════════════════════════════ */

:root {
  /* BASE DNA PALET — Dikunci saat wawancara */
  --raw-palette-bg:       [Isi Hex Bg palet terpilih];
  --raw-palette-surface:  [Isi Hex Surface palet terpilih];
  --raw-palette-text:     [Isi Hex Text palet terpilih];
  --raw-palette-accent-1: [Isi Hex Accent1 palet terpilih];
  --raw-palette-accent-2: [Isi Hex Accent2 palet terpilih];

  /* GLOBAL TRANSITION ENGINE */
  --vibe-transition: all 0.2s ease-in-out;

  /* STATUS TOKEN (Universal — tidak berubah antar tema) */
  --vibe-error:   #FF3E3E;
  --vibe-success: #00E676;
  --vibe-warning: #FFD600;
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

### Font Family Options:
- **Sans-Serif Modern:** Inter | Geist (Google Fonts CDN)
- **Serif Elegan:** Playfair Display (Google Fonts CDN)
- **Official Clean:** Roboto | Open Sans (Google Fonts CDN)

**Implementasi — Contoh CDN Link Wajib di `<head>` Layout Utama:**

```html
<!-- Inter (Sans-Serif Modern — paling sering dipakai) -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- Playfair Display (Serif Elegan) -->
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">

<!-- Roboto (Official Clean) -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

<!-- Kombinasi populer: Inter (body) + Playfair Display (heading) -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
```

**CSS Global Wajib (REQUIRED ditulis eksplisit di `app.css` / `global.css`):**

```css
/* REQUIRED: Jangan andalkan default browser — deklarasikan eksplisit */
:root {
  --font-sans: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
  --font-serif: 'Playfair Display', Georgia, 'Times New Roman', serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
}

body {
  font-family: var(--font-sans);
  font-size: 1rem;       /* 16px — body text */
  font-weight: 400;
  line-height: 1.5;
  font-display: swap;    /* Anti-FOIT */
}

h1 { font-size: clamp(1.75rem, 4vw, 2.5rem); font-weight: 700; line-height: 1.25; }
h2 { font-size: 1.5rem;    font-weight: 600; line-height: 1.35; }
h3 { font-size: 1.25rem;   font-weight: 600; line-height: 1.4;  }
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
