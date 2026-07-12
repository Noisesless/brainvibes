---
name: accessibility-audit
description: |
  Panduan dan checklist audit aksesibilitas (WCAG 2.2 AA standards, screen readers, keyboard navigation).
  Aktif saat user meminta "audit aksesibilitas", "cek a11y", "accessibility audit", "screen reader test".
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis pada skenario:

| Skenario | Contoh Trigger | Langkah Utama |
|---|---|---|
| Cek aksesibilitas | "Cek a11y halaman ini", "Apakah ini aksesibel?" | Pindai elemen UI + Keyboard test |
| Audit warna/kontras | "Periksa kontras teks", "Warna ini cukup jelas?" | Hitung kontras oklch/hex |
| Screen reader fix | "Perbaiki pembaca layar", "Ikon tidak terbaca" | Tambahkan ARIA attributes |

---

## 1. WCAG 2.2 AA Checklist (Wajib Lolos)

### A. Alternatif Teks (Alt Text)
- [ ] Semua tag `<img>` memiliki atribut `alt`.
- [ ] Gambar informatif: `alt` berisi deskripsi gambar yang singkat dan jelas.
- [ ] Gambar dekoratif (ilustrasi latar belakang, pemanis): `alt=""` (kosong, tetapi atribut tetap ada).
- [ ] Ikon grafis tanpa teks pendamping: memiliki `aria-label` pada elemen induk atau tombolnya.

### B. Keyboard & Fokus (Navigasi Mandiri)
- [ ] Semua elemen interaktif (tombol, input, link, dropdown) dapat dijangkau menggunakan tombol `Tab`.
- [ ] Urutan fokus logis (mengikuti alur visual dari atas ke bawah, kiri ke kanan).
- [ ] Indikator fokus visual (`:focus-visible`) sangat jelas — **FORBIDDEN** menghilangkan outline tanpa pengganti visual.
- [ ] Fokus Terjebak (Focus Trap): Saat modal atau dialog terbuka, fokus keyboard wajib dikurung di dalam modal. Tombol `Tab` tidak boleh melompat ke konten di belakang modal.

### C. Kontras & Warna (Visual A11Y)
- [ ] Rasio kontras teks biasa (di bawah 18pt) minimal **4.5:1** terhadap warna latar belakangnya.
- [ ] Rasio kontras teks besar (18pt ke atas atau bold 14pt ke atas) minimal **3:1**.
- [ ] Informasi penting tidak boleh hanya disampaikan lewat warna (misal: "Kolom merah wajib diisi" → harus ditambahkan ikon atau teks "(Wajib)").

### D. Struktur Halaman & Semantik
- [ ] Gunakan elemen HTML5 semantik (`<header>`, `<nav>`, `<main>`, `<section>`, `<footer>`, `<aside>`).
- [ ] Hanya ada **satu** tag `<h1>` per halaman.
- [ ] Hierarki heading tertata secara linier (H1 → H2 → H3, dilarang melompat dari H1 langsung ke H4).
- [ ] Semua input form wajib terhubung dengan elemen `<label>` menggunakan atribut `for` (pada label) dan `id` (pada input).

---

## 2. Implementasi Ikon dan Tombol Ikon (Aria-Label)

Jika membuat tombol yang hanya berisi ikon (tanpa teks visual), wajib menambahkan `aria-label`:

```html
<!-- ❌ SALAH (Screen reader tidak tahu ini tombol apa): -->
<button class="btn-icon">
  <svg>...</svg>
</button>

<!-- ✅ BENAR: -->
<button class="btn-icon" aria-label="Tutup menu popup">
  <svg aria-hidden="true">...</svg> <!-- aria-hidden mencegah screen reader mengeja isi SVG -->
</button>
```

---

## 3. Protokol Audit Aksesibilitas (Langkah AI)

1. **Langkah 1: Struktur Semantik & Heading**
   Periksa outline dokumen HTML. Pastikan heading bertingkat rapi.
2. **Langkah 2: Uji Coba Navigasi Keyboard**
   Simulasikan penekanan tombol `Tab` pada halaman. Apakah fokus terlihat jelas? Apakah semua tombol interaktif bisa diklik dengan `Enter` atau `Space`?
3. **Langkah 3: Periksa Kontras**
   Gunakan rumus kontras warna pada palet terpilih. Jika kontras tidak masuk standar AA, rekomendasikan perubahan Lightness oklch() teks atau background.
4. **Langkah 4: Berikan Rekomendasi Solusi**
   Sajikan rekomendasi dalam format tabel: [Elemen, Masalah A11Y, Rekomendasi Perbaikan, Contoh Kode].
