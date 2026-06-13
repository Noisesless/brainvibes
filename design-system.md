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
   FORBIDDEN menggunakan #000000 atau #121212 murni */
[data-theme="dark"] {
  --vibe-background:  [Generate: Versi midnight tergelap dari rona bg palet asli];
  --vibe-surface:     [Generate: Satu tingkat lebih terang dari background gelap];
  --vibe-text-main:   [Generate: Versi cerah kontras tinggi senada palet asli];
  --vibe-text-muted:  rgba(255, 255, 255, 0.6);
  --vibe-primary:     var(--raw-palette-accent-1);
  --vibe-secondary:   var(--raw-palette-accent-2);
}
```

### Contoh Kasus Konkret Penerapan Tema:
| Palet | Light Mode `--vibe-background` | Dark Mode `--vibe-background` |
|---|---|---|
| Cyber Industrial (Bg #111111) | `#111111` (DNA asli gelap) | `#090909` (lebih gelap) |
| Sage Balance (Bg #F4F7F5) | `#F4F7F5` (DNA asli terang) | `#1B2921` (midnight hijau sage) |
| Cloud Dancer (Bg #F1F5F9) | `#F1F5F9` (DNA asli) | `#0D1117` (midnight slate) |

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

**Implementasi:** Suntikkan CDN link di `<head>` layout utama. Set `font-family` secara eksplisit di CSS global — FORBIDDEN mengandalkan default browser.

---

## §4. SHADOW & ELEVATION SYSTEM

```css
/* Soft (Pasif/Idle) */
box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);

/* Hover/Glow (Aktif — REQUIRED kombinsasi dengan transition + translate) */
box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
transition: all 0.2s ease-in-out;
transform: translateY(-4px); /* hover:-translate-y-1 */
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

| Status | Warna | Penggunaan |
|---|---|---|
| Success | Hijau bersaturasi tinggi | Aktif, terverifikasi, berhasil |
| Warning | Kuning/oranye konsisten | Menunggu, pending, perhatian |
| Danger | Merah tegas | Gagal, blokir, admin-only |

Geometri badge mengikuti setting Geometri Box dari wawancara (Sharp/Rounded/Pill).

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

### State: GUEST (Belum Login)
- Tampilkan: Logo, Menu Publik (Home, About, Gallery), Tombol `Login`
- Sembunyikan: Admin Panel, Dashboard, Settings, Logout

### State: LOGGED_IN_USER (Member Aktif)
- Tombol Login → **Avatar Dropdown** (bentuk sesuai wawancara: `rounded-full` atau `rounded-md`, aspek 1:1)
- Dropdown berisi: Profil Saya, Pengaturan Akun, Logout

### State: ADMIN / SUPER ADMIN
- Semua elemen LOGGED_IN_USER + menu `Admin Panel` / `User Management` di posisi strategis
