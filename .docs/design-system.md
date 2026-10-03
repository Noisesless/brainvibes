# Brainvibes — Design System (Visual 1 Source of Truth)

> **File Role:** Dokumen utama ke-9 di `/.docs/`. Bertindak sebagai Single Source of Truth untuk seluruh elemen visual, warna, tipografi, geometri, dan token komponen proyek ini.
> Setiap rendering halaman baru, fitur visual baru, atau redesign WAJIB mengacu ke spesifikasi dalam berkas ini agar konsisten 100%.

---

## 1. Visual DNA & Tokens

### Palette Tokens (Dark Theme Default)
```css
:root {
  /* RAW TOKENS */
  --vibe-background:  #0f172a;               /* oklch(20.8% 0.042 265.7) — Deep Slate */
  --vibe-surface:     #1e293b;               /* oklch(27.9% 0.041 260.0) — Surface Card */
  --vibe-surface-sub: #334155;               /* oklch(37.1% 0.038 258.3) — Elevated Surface */
  --vibe-text-main:   #f8fafc;               /* oklch(98.4% 0.003 247.9) — High Contrast Text */
  --vibe-text-sub:    #94a3b8;               /* oklch(71.5% 0.035 256.8) — Muted Label Text */
  --vibe-accent-1:    #38bdf8;               /* oklch(77.2% 0.134 227.4) — Sky Blue Cyan */
  --vibe-accent-2:    #818cf8;               /* oklch(67.3% 0.175 277.1) — Indigo Accent */
  
  /* SEMANTIC STATUS */
  --vibe-success:     #10b981;               /* Emerald Positive */
  --vibe-warning:     #f59e0b;               /* Amber Attention */
  --vibe-error:       #ef4444;               /* Rose Danger */
  
  /* INTERACTIVE & BORDER */
  --vibe-border:      rgba(255, 255, 255, 0.12);
  --vibe-divider:     rgba(255, 255, 255, 0.08);
  --vibe-input-bg:    rgba(255, 255, 255, 0.05);
  --vibe-hover:       rgba(255, 255, 255, 0.06);
  --vibe-focus-ring:  var(--vibe-accent-1);
  --vibe-overlay:     rgba(15, 23, 42, 0.75);
}
```

### Typography System
- **Heading Font:** `'Geist', -apple-system, BlinkMacSystemFont, sans-serif`
- **Body Font:** `'Inter', -apple-system, BlinkMacSystemFont, sans-serif`
- **Pairing Rule:** Wajib 2 font (Heading berbeda dari Body). Dilarang menggunakan Inter sendirian.
- **Scale:**
  - H1: `clamp(1.75rem, 4vw, 2.5rem)` | `font-weight: 700` | `line-height: 1.25` | `text-wrap: balance`
  - H2: `clamp(1.25rem, 3vw, 1.75rem)` | `font-weight: 600` | `line-height: 1.35` | `text-wrap: balance`
  - Body: `1rem` (16px) | `line-height: 1.6` | `text-wrap: pretty`
  - Caption/Meta: `0.875rem` (14px) | `line-height: 1.4`

### Geometry & Elevation
- **Border Radius:** `--radius-md: 8px` (Rounded System)
- **Shadow System:**
  - Passive Card: `0 1px 3px rgba(0, 0, 0, 0.3), 0 1px 2px rgba(0, 0, 0, 0.2)`
  - Hover Elevation: `0 10px 25px -5px rgba(0, 0, 0, 0.4), 0 8px 10px -6px rgba(0, 0, 0, 0.4)`
  - Modal / Dialog: `0 20px 25px -5px rgba(0, 0, 0, 0.6), 0 8px 10px -6px rgba(0, 0, 0, 0.6)`

---

---

## 2. Component Token Registry (§7B Integration — 32 Komponen)

> **Aturan Wajib:** Seluruh komponen visual WAJIB menggunakan token dari registri ini. Dilarang hardcoding nilai mentah.

### 2.1 Page Structure (4 Komponen)
- **Navbar:** Height `var(--nav-height, 64px)`, mobile `var(--nav-height-mobile, 56px)`, sticky top `z-index: 100`, blur `backdrop-filter: blur(12px)`.
- **Footer:** Padding atas/bawah `var(--footer-padding-y, 48px)`, border top `1px solid var(--vibe-border)`.
- **Sidebar:** Width `var(--sidebar-width, 260px)`, collapsed `var(--sidebar-collapsed, 68px)`, overlay mobile `z-index: 200`.
- **Hero:** Height minimum `min-h-[100dvh]`, max-width `var(--hero-max-width, 1200px)` (Laptop 1366 target), padding vertikal `clamp(48px, 8vw, 96px)`.

### 2.2 Data Display (5 Komponen)
- **Table:** Default, Striped, dan Borderless varian. Cell padding `12px 16px`, header padding `14px 16px`, sticky header `z-index: 10`.
- **Pagination:** Item size `36px` (`var(--radius-md)`), active page bg `var(--vibe-accent-1)`, gap `6px`.
- **Badge / Tag:** Solid, Outline, dan Soft variants. Height `22px-28px`, padding `2px 8px`, border-radius `var(--radius-md)`.
- **Empty State:** Max-width `420px`, icon size `56px`, gap vertikal `16px`.
- **Skeleton / Shimmer:** Shimmer animation `1.5s infinite`, bg `var(--vibe-surface-sub)`.

### 2.3 Navigation (3 Komponen)
- **Tabs:** Underline & Pill variants. Tab item padding `10px 18px`, active underline `2px solid var(--vibe-accent-1)`.
- **Breadcrumb:** Separator `/` atau chevron, font-size `13px`, current page color `var(--vibe-text-main)`.
- **Stepper:** Step indicator `32px`, connector line `2px solid var(--vibe-border)`, active step `var(--vibe-accent-1)`.

### 2.4 Feedback (4 Komponen)
- **Alert / Banner:** Info, Success, Warning, Error variants. Padding `14px 16px`, border-left `4px solid [status-color]`.
- **Progress Bar:** Height `6px-12px`, track bg `var(--vibe-surface-sub)`, fill `var(--vibe-accent-1)` (transition `width 0.3s ease`).
- **Tooltip:** Max-width `260px`, padding `6px 10px`, font-size `12px`, z-index `300`.
- **Toast:** Max-width `360px`, fixed bottom-right `16px`, auto-dismiss `4000ms`, max 3 stacked.

### 2.5 Interactive (7 Komponen)
- **Button:** SM (`32px`), MD (`40px`), LG (`48px`), XL (`56px`). Variants: Primary, Secondary, Ghost, Danger.
- **Form / Input:** Height `40px`, padding `10px 14px`, focus-ring `0 0 0 3px rgba(56, 189, 248, 0.25)`.
- **Card:** Padding default `24px` (`--space-lg`), compact `16px` (`--space-md`), hover lift `translateY(-2px)`.
- **Modal / Dialog:** Width SM (`400px`), MD (`560px`), LG (`720px`), full mobile `calc(100vw - 32px)`, backdrop-blur `4px`.
- **Dropdown / Menu:** Min-width `180px`, item height `36px`, item padding `8px 12px`, elevation `var(--shadow-lg)`.
- **Accordion:** Header height `48px`, expand icon rotasi `180deg`, content padding `16px`.
- **Search Bar:** Input with icon prefix, height `40px-44px`, clear button suffix.

### 2.6 Media (3 Komponen)
- **Avatar:** XS (`24px`), SM (`32px`), MD (`40px`), LG (`48px`), XL (`64px`). Radius circle / `var(--radius-md)`.
- **Thumbnail / Image:** Aspect ratio `16:9`, `4:3`, `1:1`, object-fit `cover`, fallback background skeleton.
- **Icon:** Library: Phosphor / Lucide (ONE family). Scales: XS (`14px`), SM (`16px`), MD (`20px`), LG (`24px`), XL (`32px`).

### 2.7 Structural (6 Komponen)
- **Divider:** 1px `var(--vibe-divider)`, margin vertikal `16px-32px`.
- **Link:** Hover underline / color transition, external link indicator icon.
- **Code Block:** Background `#0b1120`, font-family `monospace`, padding `16px`, copy button top-right.
- **Blockquote:** Border-left `3px solid var(--vibe-accent-1)`, padding-left `16px`, font-style italic.
- **List:** Disc / decimal / checkmark custom bullets, item gap `8px`.
- **Spacing Semantic Map (8-Point Grid):** `--space-xs` (4px), `--space-sm` (8px), `--space-md` (16px), `--space-lg` (24px), `--space-xl` (32px), `--space-2xl` (48px), `--space-3xl` (64px).

---

## 3. Responsive Breakpoint Strategy (Android 3M + Laptop-First 1366×768)

> **Prinsip Utama:** Desain selalu mengutamakan resolusi **1366×768** (standar mayoritas laptop pasar global) sebagai target primary, lalu pastikan responsif sempurna di **Android 3M** (3 viewport mobile terpopuler).

```css
:root {
  /* 7-Tier Responsive Breakpoints */
  --bp-android-sm:    360px;   /* Android SM: Samsung Galaxy A-series, Xiaomi Redmi entry */
  --bp-android-md:    393px;   /* Android MD: Google Pixel 7/8, Samsung Galaxy S23/S24 */
  --bp-android-lg:    412px;   /* Android LG: Samsung Galaxy S24 Ultra, Pixel Pro */
  --bp-tablet:        768px;   /* Tablet: iPad Mini, Tablet portrait */
  --bp-laptop:        1366px;  /* ★ PRIMARY TARGET: 1366×768 laptop standard */
  --bp-desktop:       1440px;  /* Desktop: 1440p standard display */
  --bp-wide:          1920px;  /* Wide: Full HD 1080p desktop monitor */

  /* Container Max Widths */
  --container-mobile: 100%;
  --container-tablet: 720px;
  --container-laptop: 1200px;  /* ★ Content container utama pada layar 1366 */
  --container-desktop: 1320px;
  --container-wide:   1600px;
}
```

### Adaptation Rules:
1. **Laptop 1366×768 (PRIMARY TARGET):** Container max-width `1200px` dengan padding horizontal `24px` atau `32px`. Tampilan utama aplikasi didesain proporsional tanpa zoom out/in.
2. **Android 3M (360/393/412px):** Single-column stack, font heading `clamp()`, touch target minimum `44×44px`, horizontal scroll terisolasi pada tabel (`overflow-x: auto`), modal full-bleed margin `16px`.
3. **Container Queries:** Gunakan `@supports (container-type: inline-size)` untuk adaptasi lokal komponen independen dari viewport window.

---

## 4. Section Rhythm & Layout Constraints

### 5 Section Treatments (Anti-Monotoni)
- `[A] AIRY`: Latar `--vibe-background`, banyak whitespace, max-width `65ch` / `72rem`
- `[B] DENSE`: Grid rapat, latar `--vibe-surface`, cards dengan gap `16px`
- `[C] FULL-BLEED`: Melebar ke 100vw, escape container tanpa clip
- `[D] DARK-MOMENT`: Latar kontras lebih pekat/solid aksen, teks terang
- `[E] MEDIA-HEAVY`: Didominasi visual/grafik/diagram, teks ringkas

**Aturan Rhythm:**
- Dilarang 3 section berturut-turut dengan treatment sama.
- Selalu variasikan lebar container dan intensitas visual dari atas ke bawah.
- Bentuk card: Utamakan Bento Matrix, Staggered Step Grid, atau Split Offset (larangan default 3-kolom simetris identik).

---

## 5. Microcopy & Anti-Tech-Leak Standards (§7C Integration)

> **SSOT Teks UI:** `config/skills/taste-skill-bridge/COPY_RULES.md` & `design-system.md §7C`.
> Seluruh teks yang tampil pada antarmuka pengguna wajib berupa nomina entitas atau verba imperatif pendek yang diturunkan dari `[COPY TABLE]`.

### Prinsip Utama Teks Antarmuka:
1. **Anti-Kebocoran Teknis (Anti-Tech-Leak):** Instruksi teknis backend/JS (seperti waktu lokal Jakarta, urutan query, algoritma hashing) adalah logika kode, BUKAN teks tampilan layar.
   - ❌ **Dilarang:** `<th>Waktu (WIB)</th>`, `<td>17:02 (WIB)</td>`, `<span>Zona waktu Asia/Jakarta</span>`, `<p>Data realtime diurutkan terbaru</p>`, `<small>Password dienkripsi bcrypt</small>`.
   - ✅ **Wajib:** `<th>Waktu</th>`, `<td>17:02</td>`, `<td>03 Okt 2026, 17:02</td>`. Format waktu diatur di backend/JS tanpa label zona waktu mentah.
2. **Anti-Literal-Copy & Echo Test:** Dilarang menyalin teks instruksi user mentah menjadi teks antarmuka. Minimal ada transformasi menjadi frasa produk nyata.
3. **Batas Kata:** Heading halaman max 5 kata (hero headline max 8), subtitle max 15 kata, tombol max 3 kata, toast max 10 kata, placeholder max 5 kata.
4. **Verifikasi Pre-Flight:** Wajib menjalankan filter regex `COPY_RULES.md §7` dan mencetak marker `[COPY CHECK]` sebelum menyatakan task UI selesai.


