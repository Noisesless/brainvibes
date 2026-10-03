---
name: taste-skill-bridge-copy-rules
description: |
  Single source of truth untuk teks yang tampil di UI (heading, label, tombol, toast,
  empty state, placeholder, tooltip). Berisi Copy Gate (Gate 5B), batas kata, blocklist
  EN+ID, pola kalimat terlarang, dan regex lint. Dibaca setiap kali AI menulis visible text.
---

# COPY RULES — Teks UI (SSOT)

> Dibaca di visual task SEBELUM Gate 6. Konflik angka/blocklist di file lain → file ini menang.
> Aturan dialog AI ke user (bukan teks UI) tetap di `.agents/rules/anti-bloat-code.md §1`.

## 1. Penyebab Masalah

1. AI memakai kata-kata prompt user langsung sebagai teks UI ("Halaman untuk menampilkan...").
2. AI mengisi ruang kosong dengan kosakata marketing ("solusi terbaik", "seamless").

Larangan saja tidak cukup. Solusinya: **transformasi eksplisit (Copy Gate)** + **cek mekanis (lint)**.

---

## 2. COPY GATE (Gate 5B — Wajib, Sebelum Tulis Kode)

1. **Ekstrak** dari instruksi user: entitas (benda: transaksi, pasien, produk), aksi (tambah, ekspor), audience.
2. **Buang kata instruksi:** buat, bikin, tampilkan, halaman, fitur, untuk, agar, supaya, dapat, sistem, semua, lengkap, modern, profesional, interaktif, responsive, dashboard yang.
3. **Tulis `[COPY TABLE]`** — satu baris per slot teks yang akan terlihat:

```
[COPY TABLE] Bahasa: [Indonesia] | Entitas: [transaksi] | Aksi: [ekspor, filter]
Slot       | Dari instruksi                      | Teks UI (jumlah kata)
h1         | "menampilkan data transaksi harian" | Transaksi Harian (2)
subtitle   | -                                   | Rekap per hari, terbaru di atas (6)
btn utama  | "ekspor"                            | Ekspor CSV (2)
empty      | -                                   | Belum ada transaksi (3)
```

4. **Echo Test:** kolom "Teks UI" FORBIDDEN memuat 3+ kata berurutan yang sama dengan kolom "Dari instruksi".
5. Slot tanpa sumber di instruksi → tulis dari domain proyek (`prd.md §1`), bukan dari kosakata promosi.
6. Teks UI = **nomina entitas** atau **verba imperatif pendek**. Bukan kalimat penjelas.

**HARD BLOCK:** FORBIDDEN menulis heading/label/tombol/toast/placeholder sebelum `[COPY TABLE]` tercetak.
Tweak 1-2 string → boleh versi satu baris: `[Copy] "<lama>" → "<baru>" (n kata)`.

---

## 3. Batas Kata (SSOT)

| Elemen | Max | Contoh benar |
|---|---|---|
| Heading halaman app / section (h1-h3) | 5 | "Transaksi Harian" |
| Hero headline (landing) | 8 | "Kasir yang jalan tanpa internet" |
| Subtitle | 15 | "Rekap per hari, terbaru di atas" |
| Hero subtext | 20 | — |
| Card description | 25 | — |
| Button / nama field / tab | 3 | "Simpan", "Nama Pasien" |
| Placeholder | 5 | "Cari nama produk" |
| Tooltip | 8 | "Unduh laporan bulan ini" |
| Toast | 10 | "Data tersimpan" |
| Empty state: judul / teks | 5 / 15 | "Belum ada pesanan" / "Pesanan baru muncul di sini" |
| Pesan error field | 12 | "Email belum diisi" |
| Alert / banner | 20 | — |
| Modal: judul / isi | 5 / 30 | "Hapus pasien?" |

---

## 4. Blocklist Teks UI (EN + ID)

**EN:** unlock, empower, revolutionize/revolutionary, seamless, effortless, cutting-edge, state-of-the-art,
next-gen, next level, world-class, best-in-class, game-changing, elevate, transform your, unleash,
supercharge, streamline, leverage, harness, powerful, robust, stunning, beautiful, magical, delightful,
intuitive, innovative, comprehensive, all-in-one, one-stop, ultimate, journey, ecosystem, "smart" / "AI-powered" (kecuali fitur AI nyata).

**ID:** solusi terbaik / lengkap / cerdas, terdepan, terbaik, inovatif, revolusioner, canggih, komprehensif,
luar biasa, sempurna, maksimal, optimal, tanpa ribet, tanpa batas, mudah dan cepat, nikmati kemudahan,
pengalaman terbaik, andalan, satu pintu, lebih dari sekadar, wujudkan, raih, tingkatkan [X] Anda,
terpercaya / profesional / modern (sebagai klaim tanpa bukti).

**Pengecualian:** kata boleh muncul jika bagian dari nama fitur/produk nyata dari user atau didukung data
(mis. "Terintegrasi dengan Midtrans"). Klaim wajib punya fakta; tanpa fakta → hapus.

---

## 5. Pola Terlarang (Meta-Deskriptif & Bocor dari Brief)

| Pola | Contoh salah | Perbaikan |
|---|---|---|
| Kalimat pembuka meta | "Halaman ini menampilkan...", "Di sini Anda dapat...", "Berikut adalah..." | Hapus kalimat; langsung isi |
| Sapaan korporat | "Selamat datang di...", "Kami menyediakan...", "Platform kami..." | Hapus / sebut aksi |
| Heading berkalimat | "Menampilkan Semua Data Pasien" | "Data Pasien" |
| Istilah brief desain/teknis bocor | "Hero Section", "Bento Grid", "Dark Mode", "Visual DNA", "CRUD", "Sistem Informasi" | Pakai nama yang user-facing |
| Kebocoran instruksi teknis / timezone | "03 Okt 2026, 17:02 (WIB)", "Zona waktu: Asia/Jakarta", "Data realtime diurutkan terbaru", "Password dienkripsi bcrypt" | "03 Okt 2026, 17:02" (logika timezone diatur di backend/JS, DILARANG tempel "(WIB)" atau nama timezone di UI) |
| Placeholder generik | "Judul Halaman", "Deskripsi singkat", "Lorem ipsum", "John Doe" | Isi data domain realistis |
| Heading memakai kata sambung "yang" / "untuk" | "Dashboard yang Menampilkan..." | Nomina saja |
| Tanda seru dan emoji dekorasi | "Berhasil Disimpan!" 🎉 | "Data tersimpan" |
| Angka/testimoni karangan | "92% lebih cepat", "Trusted by 10.000+" | Hapus sampai ada data nyata |

### 5.B Anti-Kebocoran Teknis & Timezone (Technical Leak Ban)
Instruksi teknis adalah instruksi logika kode/backend, BUKAN teks tampilan layar:
1. **Timezone:** Instruksi "pakai waktu jakarta / WIB" berarti konfigurasi timezone server/client ke `Asia/Jakarta`. FORBIDDEN memunculkan label `(WIB)`, `(WITA)`, `(WIT)`, `WIB`, `Asia/Jakarta`, atau keterangan zona waktu pada header tabel, kolom waktu, subtitle, badge, maupun sel — kecuali aplikasi perbandingan zona waktu internasional (world clock).
2. **Sorting/Filter:** Instruksi "urutkan dari yang terbaru / descending" adalah query backend (`ORDER BY created_at DESC`). FORBIDDEN menulis "Data realtime, diurutkan terbaru" di bawah judul atau tabel.
3. **Security/Hashing:** Instruksi "enkripsi password bcrypt" adalah controller backend. FORBIDDEN menulis "Password dienkripsi bcrypt" di layar login/register.
4. **Metrik/Library:** FORBIDDEN memajang "Responsive", "Mobile Friendly", "REST API", "Lucide Icons", "OWASP compliant" di teks tampilan UI.

---

## 6. Suara & Konsistensi

- Satu bahasa per halaman, mengikuti audience di `prd.md §1`.
- Satu gaya sapaan (default: tanpa sapaan, label imperatif). Jangan campur "Anda" dan "kamu".
- Satu intent = satu label di seluruh app (selaras `DETAILED.md §4.5`).
- Pesan sistem = fakta + langkah berikut. Contoh: "Stok habis. Tambah stok dulu."
- Tombol aksi = verba + objek jika ambigu: "Simpan", "Hapus Pasien", "Ekspor CSV".

| Komponen | Salah | Benar |
|---|---|---|
| Log waktu / tabel | "17:02 (WIB)" / "Waktu (WIB)" | "17:02" / "Waktu" |
| Toast sukses | "Data berhasil disimpan dengan sukses!" | "Data tersimpan" |
| Error | "Oops! Terjadi kesalahan pada sistem." | "Gagal menyimpan. Coba lagi." |
| Empty state | "Belum ada data yang dapat ditampilkan saat ini" | "Belum ada transaksi" |
| Konfirmasi | "Apakah Anda yakin ingin menghapus data ini secara permanen?" | "Hapus pasien ini?" |
| Hero | "Unlock the power of seamless inventory management" | "Stok gudang, selalu akurat" |
| Placeholder | "Masukkan nama produk yang ingin dicari di sini" | "Cari produk" |

---

## 7. Lint Mekanis (Wajib Sebelum Declare Done)

Jalankan `grep_search` (`IsRegex: true`, `MatchPerLine: true`) pada file UI yang diubah
(`*.html, *.php, *.blade.php, *.jsx, *.tsx, *.vue, *.astro, *.svelte`). Hit = perbaiki, lalu cek ulang.

```
Buzz     : (?i)unlock|empower|revolution|seamless|effortless|cutting-edge|state-of-the-art|next-gen|next level|world-class|best-in-class|game-chang|elevate|transform your|unleash|supercharge|streamline|powerful|stunning|all-in-one|one-stop|solusi (terbaik|lengkap|cerdas)|terdepan|inovatif|revolusioner|canggih|komprehensif|tanpa ribet|tanpa batas|luar biasa|sempurna|nikmati kemudahan|pengalaman terbaik
Meta     : (?i)halaman ini|section ini|di sini anda|berikut adalah|selamat datang di|fitur ini memungkinkan|kami menyediakan|platform kami|dirancang untuk|this page|this section|welcome to|we provide|designed to
TechLeak : (?i)\(\s*(?:wib|wita|wit|utc|gmt)\b[^)]*\)|\b\d{1,2}[:.]\d{2}\s*(?:wib|wita|wit)\b|asia/jakarta|zona waktu|timezone|time zone|\breal-?time\b|diurutkan|sorted by|dienkripsi|encrypted|bcrypt|\bformat\s*:|\bresponsive\b|\bowasp\b
Filler   : (?i)lorem ipsum|judul halaman|deskripsi singkat|your title|heading here|john doe|hero section|bento grid
Seru     : >[^<{]*![^<=]*<
```

Hit di komentar kode / nama class / data user asli = abaikan dan catat.

---

## 8. Output Marker

```
[COPY CHECK] Echo: ✅ | Blocklist: ✅ | Limit: ✅ | Meta: ✅ | TechLeak: ✅ | Lint: ✅ (0 hit)
```

Ada ❌ → perbaiki sebelum declare done. Jika ada yang diubah:
`[Pragmatic Check] Removed: [buzzword/literal-copy/tech-leak] → Replaced: [versi lugas]`

