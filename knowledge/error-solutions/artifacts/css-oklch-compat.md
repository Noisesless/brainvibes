# Error Solutions — CSS oklch() Compatibility

*Solusi untuk masalah kompatibilitas browser dengan format warna oklch() yang digunakan di Vibes Coding Workflow.*

---

## [ES-OKLCH-001] Warna Tidak Muncul di Safari < 15.4

**Gejala:** Background/text tidak muncul (transparan) di Safari versi lama.
**Penyebab:** oklch() tidak didukung di Safari < 15.4 (2022), Chrome < 111, Firefox < 113.
**Solusi:**
```css
/* REQUIRED: Fallback hex SEBELUM oklch() */
:root {
  --raw-palette-bg: #0F172A;          /* Fallback untuk browser lama */
  --raw-palette-bg: oklch(15% 0.03 250); /* Modern browser override */
}

/* Untuk properti individual: */
.card {
  background: #1E293B;               /* Fallback */
  background: oklch(20% 0.03 250);   /* Modern */
}
```
**Aturan:** Setiap deklarasi oklch() REQUIRED punya fallback hex di baris sebelumnya.

---

## [ES-OKLCH-002] @property Tidak Didukung di Firefox < 128

**Gejala:** CSS custom property animation (`transition: --vibe-primary 0.3s`) tidak bekerja di Firefox.
**Penyebab:** `@property` CSS baru didukung penuh di Firefox dari versi 128 (Juli 2024).
**Solusi:**
```css
/* Deklarasikan @property untuk animasi (progressive enhancement): */
@property --vibe-primary {
  syntax: '<color>';
  inherits: true;
  initial-value: oklch(55% 0.25 275);
}

/* Fallback: gunakan transition pada property standard: */
.button {
  background: var(--vibe-primary);
  transition: background 0.3s ease; /* Ini bekerja di SEMUA browser */
  /* transition: --vibe-primary 0.3s ease; ← hanya di browser yg support @property */
}
```

---

## [ES-OKLCH-003] color-mix() Tidak Bekerja di Browser Lama

**Gejala:** `color-mix(in oklch, var(--vibe-primary) 80%, black)` tidak dirender.
**Penyebab:** `color-mix()` baru didukung dari Chrome 111, Safari 16.2, Firefox 113.
**Solusi:**
```css
/* Fallback: pre-compute warna yang di-mix */
.hover-darken {
  background: #4a4aff;                                        /* Pre-computed fallback */
  background: color-mix(in oklch, var(--vibe-primary) 80%, black); /* Modern */
}

/* Alternatif tanpa color-mix — gunakan opacity trick: */
.hover-darken {
  background: var(--vibe-primary);
  filter: brightness(0.8); /* Efek gelap 20% tanpa color-mix */
}
```

---

## [ES-OKLCH-004] light-dark() Function Belum Widely Supported

**Gejala:** `color: light-dark(#000, #fff)` tidak bekerja.
**Penyebab:** `light-dark()` CSS masih experimental (Chrome 123+, Firefox 120+, Safari belum).
**Solusi:**
```css
/* JANGAN gunakan light-dark() untuk production — terlalu baru */
/* Gunakan data-theme attribute approach dari design-system.md §2: */
[data-theme="light"] { --vibe-text-main: oklch(15% 0.02 250); }
[data-theme="dark"]  { --vibe-text-main: oklch(90% 0.02 250); }
```

---

## [ES-OKLCH-005] Konversi HEX ke oklch() — Tool dan Rumus

**Gejala:** Tidak tahu cara konversi hex ke oklch() yang akurat.
**Penyebab:** oklch menggunakan perceptual model yang berbeda dari RGB.
**Solusi:**
```
Tools konversi:
1. https://oklch.com — Visual picker + converter (PALING AKURAT)
2. npx oklch [hex] — CLI converter
3. https://colorjs.io/apps/convert/ — Batch converter

Konversi manual rough:
oklch(Lightness% Chroma Hue)
- Lightness: 0% = hitam, 100% = putih
- Chroma: 0 = abu-abu, 0.4 = maksimum saturasi
- Hue: 0-360 derajat (0=merah, 120=hijau, 240=biru)

Contoh dari design-system.md §1:
#FF6B00 (Orange) → oklch(65% 0.22 35)
#635BFF (Purple) → oklch(55% 0.25 275)
#00BFA5 (Teal)   → oklch(68% 0.15 175)
```

---

## [ES-OKLCH-006] Kontras Ratio Tidak Memenuhi WCAG AA saat Pakai oklch()

**Gejala:** Teks tidak cukup kontras di atas background — terutama warna accent.
**Penyebab:** oklch Lightness tidak langsung korelasi dengan kontras rasio WCAG.
**Solusi:**
```
Aturan praktis kontras oklch:
- Text di atas background GELAP (L < 30%): text harus L > 75%
- Text di atas background TERANG (L > 70%): text harus L < 25%
- Minimum delta Lightness: 50% antara text dan background

Tool verifikasi:
- https://www.siegemedia.com/contrast-ratio
- Chrome DevTools → Inspect element → Color picker → shows contrast ratio
```

---

## [ES-OKLCH-005] Fallback Pattern Wajib untuk Semua --vibe-* Token (v3.1.0)

**Masalah:** Design system Brainvibes menggunakan oklch() agresif sebagai token utama.
Browser lama (Safari < 15.4, Chrome < 111) tidak bisa render -- semua warna menjadi transparan.

**Solusi WAJIB -- Template CSS Token dengan Dual Fallback:**
`
:root {
  /* PATTERN WAJIB: hex fallback dulu, oklch override modern */

  /* Background */
  --vibe-background: #0F172A;
  --vibe-background: oklch(15% 0.03 250deg);

  /* Surface (card, panel) */
  --vibe-surface: #1E293B;
  --vibe-surface: oklch(20% 0.025 250deg);

  /* Text */
  --vibe-text-main: #F8FAFC;
  --vibe-text-main: oklch(98% 0.005 250deg);

  --vibe-text-muted: #94A3B8;
  --vibe-text-muted: oklch(65% 0.02 250deg);

  /* Primary accent */
  --vibe-primary: #6366F1;
  --vibe-primary: oklch(60.2% 0.189 264.4deg);

  /* Secondary accent */
  --vibe-secondary: #8B5CF6;
  --vibe-secondary: oklch(56% 0.195 290deg);

  /* Semantic */
  --vibe-error:   #EF4444;
  --vibe-success: #22C55E;
  --vibe-warning: #F59E0B;

  /* System */
  --vibe-border: #334155;
  --vibe-border: oklch(28% 0.02 250deg);
}
`

**Aturan:**
- WAJIB tulis hex fallback SEBELUM oklch() di baris berikutnya (bukan setelahnya)
- Browser membaca CSS berurutan -- jika oklch tidak dimengerti, gunakan nilai sebelumnya
- FORBIDDEN hanya menulis oklch() tanpa fallback

**Deteksi via @supports (opsional tapi direkomendasikan):**
`
@supports not (color: oklch(0% 0 0)) {
  :root {
    --vibe-primary: #6366F1;
    /* override hanya untuk browser non-oklch */
  }
}
`

**Browser yang tidak support oklch():**
- Safari < 15.4 (iOS < 15.4, macOS Monterey < 12.3)
- Chrome < 111 (March 2023)
- Firefox < 113 (May 2023)
- Semua IE (tidak ada dukungan sama sekali)
