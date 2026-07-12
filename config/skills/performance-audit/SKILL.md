---
name: performance-audit
description: |
  Panduan dan checklist audit performa web (Core Web Vitals, bundle optimization, caching).
  Aktif saat user meminta "audit performa", "perbaiki loading", "lighthouse", "web vitals", "speed test".
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis pada skenario:

| Skenario | Contoh Trigger | Langkah Utama |
|---|---|---|
| Optimasi loading | "Halaman ini lambat", "Percepat loading" | Identifikasi bottlenecks + Asset optimization |
| Lighthouse Audit | "Audit lighthouse", "Cek Core Web Vitals" | Checklist Core Web Vitals |
| Optimasi bundle | "Bundle file terlalu besar", "Optimasi build" | Dynamic import / code splitting |

---

## 1. Checklist Core Web Vitals (Target: Lolos Audit)

### 🔴 LCP (Largest Contentful Paint) — Target: ≤ 2.5s
- [ ] Hero Image (LCP) menggunakan `<link rel="preload">` dengan `fetchpriority="high"`.
- [ ] Image format menggunakan **WebP** / **AVIF** (hindari PNG/JPG besar).
- [ ] Image compression di-set ke quality 80%.
- [ ] Menghindari JavaScript pemblokir render di `<head>` (gunakan `defer` atau `async`).
- [ ] CSS kritikal di-inline jika memungkinkan, CSS non-kritikal di-load asinkron.

### 🟡 CLS (Cumulative Layout Shift) — Target: ≤ 0.1
- [ ] Semua tag `<img>` dan `<iframe>` memiliki atribut `width` dan `height` eksplisit.
- [ ] Aspect ratio di-set di CSS: `aspect-ratio: attr(width) / attr(height)`.
- [ ] Web fonts menggunakan `font-display: swap` untuk mencegah FOIT/FOUT.
- [ ] Menghindari penyisipan konten dinamis (seperti iklan atau widget) di atas konten yang sudah dirender tanpa reservasi space (min-height).

### 🟢 INP (Interaction to Next Paint) — Target: ≤ 200ms
- [ ] Meminimalkan Long Tasks di main thread (> 50ms). Pecah task besar menggunakan `setTimeout` atau `requestIdleCallback`.
- [ ] Menghindari blocking event listeners.
- [ ] Optimasi React state updates (gunakan `useTransition` atau `useDeferredValue` untuk update non-urgen).

---

## 2. Optimasi Berkas & Bundle (Bundle Optimization)

### Next.js / React
- [ ] Gunakan Dynamic Imports (`next/dynamic` atau React `lazy`) untuk komponen berat (seperti chart, editor, modal).
- [ ] Analisis ukuran bundle menggunakan `@next/bundle-analyzer`.
- [ ] Pastikan package external (seperti lodash, lucide-react) di-import secara modular:
  `import { map } from 'lodash-es'` (bukan `import _ from 'lodash'`).
- [ ] Minimalkan library client-side — pindahkan kalkulasi data berat ke Server Components.

### PHP Native / HTML
- [ ] Gunakan penggabungan berkas CSS/JS dan minifikasi (minified files).
- [ ] Manfaatkan HTTP caching via `.htaccess`:
  ```apache
  <IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType image/webp "access plus 1 year"
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
  </IfModule>
  ```
- [ ] Aktifkan kompresi Gzip / Brotli di server.

---

## 3. Protokol Audit Performa (Langkah AI)

1. **Langkah 1: Identifikasi Baseline**
   Minta user data performa saat ini (skor Lighthouse atau Chrome DevTools Network tab screenshot).
2. **Langkah 2: Periksa Media / Gambar**
   Pindai halaman aktif untuk mencari gambar berukuran > 500KB atau berformat PNG.
3. **Langkah 3: Periksa JavaScript / CSS Blocking**
   Identifikasi tag `<script>` tanpa `defer`/`async` di dalam `<head>`.
4. **Langkah 4: Berikan Rekomendasi Konkret**
   Buat laporan dalam bentuk tabel perbaikan (masalah, file terdampak, solusi, estimasi dampak).
