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

## 2. Component Token Registry (§7B Integration)

### Button System
- **Heights:** SM: `32px` | MD: `40px` | LG: `48px` | XL: `56px`
- **Paddings:** SM: `8px 16px` | MD: `10px 24px` | LG: `14px 32px`
- **Radius:** `var(--radius-md, 8px)`
- **Variants:**
  - `primary`: bg `var(--vibe-accent-1)`, text `var(--vibe-background)`, hover lift `translateY(-1px)`
  - `secondary`: bg `transparent`, border `1.5px solid var(--vibe-accent-1)`, text `var(--vibe-accent-1)`
  - `ghost`: bg `transparent`, text `var(--vibe-text-sub)`, hover bg `var(--vibe-hover)`
  - `danger`: bg `var(--vibe-error)`, text `#ffffff`

### Icon System
- **Library:** Lucide Icons / Phosphor Icons (ONE family per project)
- **Scale:** XS: `14px` | SM: `16px` | MD: `20px` (default) | LG: `24px` | XL: `32px` | Hero: `48px`
- **Rule:** Dilarang hand-roll raw SVG. Ikon dekoratif wajib `aria-hidden="true"`.

### Modal & Dialog
- **Widths:** SM: `400px` | MD: `560px` | LG: `720px` | Full: `calc(100vw - 48px)`
- **Padding:** `var(--space-lg, 24px)`
- **Overlay:** `var(--vibe-overlay)` dengan backdrop-blur `4px`
- **Radius:** `calc(var(--radius-md) * 1.5)` (12px)

### Toast & Notification
- **Width:** `360px` (Max mobile: `calc(100vw - 32px)`)
- **Position:** Fixed bottom-right `16px`
- **Auto-dismiss:** `4000ms`
- **Stack limit:** Maksimal 3 toast visible bersamaan

### Form Elements
- **Input Height:** `40px` | Padding: `10px 14px` | Font Size: `14px` minimum
- **Input BG:** `var(--vibe-input-bg)` | Border: `1.5px solid var(--vibe-border)`
- **Focus Ring:** `0 0 0 3px rgba(56, 189, 248, 0.25)`
- **Labels:** Size `13px`, weight `500`, color `var(--vibe-text-sub)`

### Card System
- **Padding:** Default `24px` (`--space-lg`), Compact `16px` (`--space-md`)
- **Background:** `var(--vibe-surface)`
- **Border:** `1px solid var(--vibe-border)`
- **Hover Lift:** `translateY(-2px)` dengan transisi `all 0.2s ease-in-out`

### Spacing Semantic Map (8-Point Grid)
| Token | Value | Peruntukan |
|---|---|---|
| `--space-xs` | `4px` | Gap ikon ke teks, micro-spacing |
| `--space-sm` | `8px` | Gap elemen dalam card, badge padding |
| `--space-md` | `16px` | Gap form field, compact padding |
| `--space-lg` | `24px` | Card padding, modal padding |
| `--space-xl` | `32px` | Section grid gap, container margin |
| `--space-2xl` | `48px` | Section gap vertikal kecil |
| `--space-3xl` | `64px` | Section padding atas/bawah utama |

---

## 3. Section Rhythm & Layout Constraints

### 5 Section Treatments (Anti-Monotoni)
- `[A] AIRY`: Latar `--vibe-background`, banyak whitespace, max-width `65ch` / `72rem`
- `[B] DENSE`: Grid rapat, latar `--vibe-surface`, cards dengan gap `16px`
- `[C] FULL-BLEED`: Melebar ke 100vw, escape container tanpa clip
- `[D] DARK-MOMENT`: Latar kontras lebih pekat/solid aksen, teks terang
- `[E] MEDIA-HEAVY`: Didominasi visual/grafik/diagram, teks ringkas

**Aturan Rhythm:**
- Dilarang 3 section berturut-turut dengan treatment sama.
- Selalu variasikan lebar container dan intensitas visual dari atas ke bawah.
