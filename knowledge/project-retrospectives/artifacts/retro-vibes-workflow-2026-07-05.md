# Retrospective — Vibes Coding Workflow V2.2 Setup — 2026-07-05

> Retrospective pertama: bukan dari proyek aplikasi, tapi dari proses penyusunan sistem konfigurasi Vibes Coding Workflow itu sendiri.

---

## Stack yang Dipakai
- Framework: Multi-stack (PHP Native + Next.js + Vanilla CSS)
- Database: N/A (ini proyek konfigurasi)
- CSS: oklch() token system
- Deploy target: Lokal (.gemini/ config directory)

---

## Keputusan Baik (Pertahankan di Proyek Berikutnya)
- **Separation of Concerns 3 Pilar:** Memisahkan gemini.md (hukum), design-system.md (visual), prd-template.md (formulir) mencegah rule leak dan mempermudah maintenance. Tidak pernah ada duplikasi aturan.
- **oklch() sebagai standar warna:** Perceptual color model yang konsisten — delta Lightness langsung terlihat efeknya, berbeda dari HSL yang non-linear.
- **Anti-Rule Leak Protocol:** Aturan hanya ada di SATU tempat, file lain hanya cross-reference. Ini mencegah inconsistency saat update.
- **app-context.md sebagai snapshot:** Token cost konstan ~3.000 token per sesi recovery, jauh lebih efisien dari membaca handover.md penuh.
- **UUPM sebagai skill external:** Data CSV yang kaya (1.4MB total) tersimpan di file terpisah, tidak membebani context window.
- **CSS @layer architecture:** 6 layer hierarkis mencegah specificity war yang biasa terjadi di proyek besar.

---

## Keputusan Buruk (Hindari)
- **Knowledge Items dibuat PLACEHOLDER tanpa data:** KI metadata.json dibuat tapi artifacts/ kosong — pipeline Knowledge Priming tidak efektif karena tidak ada apa-apa untuk di-prime.
  → **Alternatif:** Saat membuat KI, WAJIB isi minimal 3-5 entry per artifact file.
- **Lessons-Learned data tidak diisi setelah debug:** Setiap sesi debug menghasilkan solusi baru, tapi tidak ada yang dicatat ke fast-solutions.md atau anti-patterns.md.
  → **Alternatif:** Aktifkan habit /learn setelah setiap bug fix berhasil.

---

## Pattern Baru Ditemukan
- **Machine-Optimized Snapshot (app-context.md):** Format key=value ultra-compact yang bisa dibaca AI dalam <100 baris. Gunakan saat: setiap proyek yang akan punya banyak sesi kontinu.
- **UUPM Silent Pipeline:** AI menjalankan UUPM search.py secara diam-diam sebelum keputusan desain apapun, hasilnya langsung diterapkan tanpa user diminta memilih dari daftar panjang. Gunakan saat: setiap proyek baru yang butuh palet warna.
- **Stealth Fetch Engine:** Header kamuflase HTTP yang meniru browser manusia, menghindari 403 dari CDN gambar. Gunakan saat: setiap project yang fetch gambar dari Unsplash/Picsum/API eksternal.

---

## Error Menarik & Solusinya
- **oklch() transparan di Safari lama:** Semua elemen jadi invisible. Solusi: wajib fallback hex sebelum oklch() — Root cause: Safari < 15.4 tidak parse oklch().
- **Port 3000 conflict:** Dev server Next.js bentrok dengan service production aktif. Solusi: FORBIDDEN port 3000 dan 8000, wajib pakai 3100+ — Root cause: multiple services di mesin development.

---

## Estimasi vs Realita
| Fase | Estimasi | Realita | Alasan Gap |
|---|---|---|---|
| Setup 3 pilar | 2 jam | 4 jam | Iterasi cross-reference dan anti-rule leak butuh banyak revisi |
| UUPM integration | 1 jam | 3 jam | Pipeline scripts + 14 CSV data files + testing |
| KI Framework | 30 menit | 30 menit | Hanya metadata — data belum diisi (ini yang jadi masalah) |
| Lessons-Learned | 30 menit | 30 menit | Hanya framework — data baru diisi di sesi ini |
| Total | 4 jam | 8 jam | Estimasi terlalu optimis untuk level detail yang dihasilkan |

---

## Rekomendasi Stack untuk Tipe Proyek Ini
Jika proyek konfigurasi AI Coding Workflow diulang dari awal:
- Tetap gunakan Markdown-based config (bukan YAML/JSON) — AI lebih natural membaca Markdown.
- Prioritaskan mengisi DATA (KI, lessons-learned) bersamaan dengan membuat FRAMEWORK.
- Tambahkan automated sync checker yang bisa dijalankan via saklar untuk verifikasi cross-reference antar-file.

---

*Diisi saat analisa global setting 2026-07-05. Tersimpan di knowledge/project-retrospectives/artifacts/*
