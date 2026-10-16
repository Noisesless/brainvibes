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
2. **Buang kata instruksi:** buat, buatkan, bikin, tampilkan, tunjukkan, tambahkan, implementasi, fitur, halaman, page, untuk, agar, supaya, dapat, bisa, lengkap, modern, profesional, interaktif, responsive, CRUD, manajemen, management, dashboard yang, sistem informasi, menampilkan, mengelola, melihat, semua data, seluruh data, dengan grafik, dengan tabel.
3. **Tulis `[COPY TABLE]`** — satu baris per slot teks yang akan terlihat:

```
[COPY TABLE] Bahasa: [Indonesia] | Entitas: [transaksi] | Aksi: [ekspor, filter]
Slot       | Dari instruksi                      | Teks UI (jumlah kata)
h1         | "menampilkan data transaksi harian" | Transaksi Harian (2)
subtitle   | -                                   | Rekap per hari, terbaru di atas (6)
btn utama  | "ekspor"                            | Ekspor CSV (2)
empty      | -                                   | Belum ada transaksi (3)
```

4. **Echo Test:** kolom "Teks UI" FORBIDDEN memuat **2+ kata berurutan** yang sama dengan kolom "Dari instruksi" (diperketat dari 3+ kata).
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
intuitive, innovative, comprehensive, all-in-one, one-stop, ultimate, journey, ecosystem, exponential growth,
paradigm shift, synergistic, unrivaled, frictionless, end-to-end, holistic, mission-critical, hyper-scalable,
future-ready, reimagine, turnkey, robust ecosystem, bespoke, "smart" / "AI-powered" (kecuali fitur AI nyata).

**ID:** solusi terbaik / lengkap / cerdas / masa depan, terdepan, terbaik, inovatif, revolusioner, canggih,
komprehensif, luar biasa, sempurna, maksimal, optimal, tanpa ribet, tanpa batas, mudah dan cepat,
nikmati kemudahan, pengalaman terbaik / revolusioner, andalan, satu pintu, lebih dari sekadar, wujudkan, raih,
tingkatkan [X] Anda, teknologi mutakhir, pertumbuhan eksponensial, meningkatkan efisiensi operasional,
andal dan terpercaya, kelas dunia, terintegrasi penuh, tanpa kompromi, transformasi digital terdepan,
akurasi sempurna, ekosistem terpadu, klik di sini untuk, silakan masukkan, apakah Anda yakin ingin,
mengoptimalkan alur kerja, memfasilitasi kolaborasi, menganalisis secara komprehensif,
terpercaya / profesional / modern (sebagai klaim tanpa bukti).

**Pengecualian:** kata boleh muncul jika bagian dari nama fitur/produk nyata dari user atau didukung data
(mis. "Terintegrasi dengan Midtrans"). Klaim wajib punya fakta; tanpa fakta → hapus.

---

## 4.B Pattern Blocklist (Pola Kalimat Terlarang)
Blocklist kata saja tidak cukup karena AI mudah memparafrasekan ke sinonim. Aturan ini melarang POLA:

| # | Pola Terlarang | Contoh Salah | Perbaikan |
|---|---|---|---|
| P1 | Verba + "dengan mudah/cepat/aman" | "Kelola data dengan mudah" | "Data Pasien" (nomina saja) |
| P2 | "Untuk [aksi] yang lebih [adjektif]" | "Untuk monitoring yang lebih efisien" | "Monitoring" |
| P3 | "Solusi/Sistem/Platform [adjektif]" | "Sistem Terintegrasi", "Solusi Lengkap" | Nama domain spesifik |
| P4 | Heading > 5 kata yang berisi verba | "Mengelola Semua Transaksi Harian Anda" | "Transaksi Harian" |
| P5 | Subtitle yang berisi "Anda/kamu" | "Pantau perkembangan bisnis Anda" | "Ringkasan bulan ini" |
| P6 | Kata sifat komparatif tanpa baseline | "Lebih cepat", "Lebih akurat" | Hapus, atau sertakan data faktual |
| P7 | [Entitas] + "yang [klausa panjang]" | "Dashboard yang menampilkan semua data" | "Dashboard" |
| P8 | Imperatif + objek + klausa penjelas | "Lihat semua laporan Anda di sini" | "Laporan" |

---

## 4.C TechLeak Expanded (Istilah Teknis Halus)
Selain regex §7, FORBIDDEN istilah teknis halus ini muncul di teks antarmuka (UI):

| Istilah Teknis Halus (❌ Terlarang di UI) | Padanan Ramah Pengguna (✅ Benar) |
|---|---|
| ID (sebagai header kolom tabel) | Nomor / No. / Kode |
| Session | Sesi (hanya jika konteks auth/keamanan relevan) atau hapus |
| Active/Inactive (sebagai status sistem backend) | Aktif / Nonaktif (hanya untuk data domain, bukan server) |
| Query, Request, Response, Endpoint | FORBIDDEN di teks UI |
| Null, Undefined, N/A, NaN | Kosong / Belum diisi / - |
| Timestamp | Waktu / Tanggal |
| Boolean (literal true/false atau 1/0 di UI) | Ya/Tidak atau icon status domain ✓/✗ |
| Database, Server, API | FORBIDDEN di pesan dialog/notifikasi pengguna biasa |
| Timeout, Connection Failed | "Gagal memuat. Coba lagi." (jangan sebut port/koneksi TCP) |
| Stack trace / error code (SQLSTATE, PDOException) | "Terjadi kesalahan. Coba lagi." |

---

## 4.D Infra Status Badge Ban (Kapsul Status Infrastruktur)
FORBIDDEN menambahkan badge/kapsul/pill yang menampilkan status infrastruktur di halaman end-user:

### FORBIDDEN (Contoh badge yang TIDAK BOLEH ada):
| Badge / Kapsul Terlarang | Mengapa Salah & Dilarang |
|---|---|
| `● Aktif` / `● Online` / `● Connected` (di pojok/header) | Status koneksi bukan urusan user. Jika error → tampilkan banner error. Jika normal → diam. |
| `✓ Database Aktif` / `Terhubung Database` | End-user tidak perlu tahu teknologi database. Ini urusan DevOps/backend. |
| `Server Online` / `API Ready` | Layar monitor infrastruktur, bukan antarmuka aplikasi produk. |
| `🔴 Live` / `● Realtime` | Kecuali benar-benar live websocket/SSE nyata — badge ini klaim kosong. |
| `✓ Terkoneksi` / `Sinkronisasi Aktif` | Jika sinkronisasi gagal → beri tahu langkah aksi. Jika berhasil → diam. |

### ATURAN KAPSUL/BADGE:
1. Badge status (termasuk warna hijau) HANYA boleh untuk status **data domain aplikasi** (misal status pesanan: "Lunas", "Dikirim"; status kehadiran: "Hadir").
2. Badge status FORBIDDEN untuk status **infrastruktur/koneksi/server/database**.
3. Jika ada error koneksi → tampilkan inline alert message, BUKAN badge hijau saat online dan merah saat offline.
4. Prinsip: **Diam jika oke, bicara jika error.**

---

## 4.E Anti Literal Prompt Echo (Pencegahan Salinan Mentah Instruksi)
Masalah paling persisten: AI menyalin teks instruksi user langsung ke halaman aplikasi.

### Kata Instruksi yang WAJIB Dibuang dari Teks UI:
`buat`, `buatkan`, `bikin`, `tampilkan`, `tunjukkan`, `tambahkan`, `implementasi`,
`fitur`, `halaman`, `page`, `untuk`, `agar`, `supaya`, `dapat`, `bisa`,
`lengkap`, `modern`, `profesional`, `interaktif`, `responsif`, `CRUD`,
`manajemen`, `management`, `dashboard yang`, `sistem informasi`,
`menampilkan`, `mengelola`, `melihat`, `semua data`, `seluruh data`,
`dengan grafik`, `dengan tabel`, `dengan fitur`.

### Prosedur (HARD BLOCK — bukan sekadar saran):
1. Ambil ENTITAS dari instruksi (nomina: pasien, transaksi, produk, stok).
2. BUANG semua kata instruksi di atas.
3. Heading = entitas saja, max 3-5 kata.
4. Jika instruksi = "buat dashboard manajemen stok barang dengan grafik" → `<h1>Stok Barang</h1>`. Titik.
5. FORBIDDEN subtitle yang mendeskripsikan apa yang halaman lakukan — halaman sudah menunjukkannya secara visual.

### Contoh Pelanggaran Nyata vs Benar:
| Instruksi User | ❌ Slop (Literal Copy) | ✅ Benar (Lugas & Profesional) |
|---|---|---|
| "buat dashboard manajemen stok barang" | Dashboard Manajemen Stok Barang | Stok Barang |
| "buatkan halaman untuk melihat riwayat transaksi" | Halaman untuk Melihat Riwayat Transaksi | Riwayat Transaksi |
| "buat fitur CRUD data pasien lengkap" | Fitur CRUD Data Pasien Lengkap | Data Pasien |
| "tampilkan statistik penjualan dengan grafik" | Menampilkan Statistik Penjualan dengan Grafik | Penjualan |
| "buat halaman admin untuk kelola user" | Halaman Admin untuk Kelola User | Pengguna |
| "bikin form input data karyawan baru" | Form Input Data Karyawan Baru | Karyawan Baru |

### Echo Test (Diperketat):
- Setelah tulis heading/subtitle → bandingkan dengan instruksi user.
- Jika **2+ kata berurutan** sama dengan instruksi (diturunkan dari 3+ kata) → GAGAL, tulis ulang.
- Test ini WAJIB dijalankan sebelum kode dikirim.

---

## 4.F Em-Dash Ban (Larangan Karakter Em-Dash di UI)
Merujuk data empiris `tasteskill v2`, em-dash (`—`) adalah penanda (tell) paling mencolok yang sering dihasilkan AI di teks web.
- **FORBIDDEN:** Penggunaan karakter em-dash (`—`) di seluruh antarmuka pengguna (headline, subtitle, pill, badge, button, caption, alt text).
- **Padanan:** Gunakan tanda hubung pendek/hyphen (`-`) jika memang diperlukan pemisah, atau restrukturisasi kalimat menjadi frasa lugas tanpa jeda dramatis.

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
Buzz        : (?i)unlock|empower|revolution|seamless|effortless|cutting-edge|state-of-the-art|next-gen|next level|world-class|best-in-class|game-chang|elevate|transform your|unleash|supercharge|streamline|powerful|stunning|all-in-one|one-stop|solusi (terbaik|lengkap|cerdas)|terdepan|inovatif|revolusioner|canggih|komprehensif|tanpa ribet|tanpa batas|luar biasa|sempurna|nikmati kemudahan|pengalaman terbaik
Meta        : (?i)halaman ini|section ini|di sini anda|berikut adalah|selamat datang di|fitur ini memungkinkan|kami menyediakan|platform kami|dirancang untuk|this page|this section|welcome to|we provide|designed to
TechLeak    : (?i)\(\s*(?:wib|wita|wit|utc|gmt)\b[^)]*\)|\b\d{1,2}[:.]\d{2}\s*(?:wib|wita|wit)\b|asia/jakarta|zona waktu|timezone|time zone|\breal-?time\b|diurutkan|sorted by|dienkripsi|encrypted|bcrypt|\bformat\s*:|\bresponsive\b|\bowasp\b
InfraBadge  : (?i)(database aktif|terhubung (ke )?database|server (online|aktif|ready)|api (ready|connected|aktif)|●\s*(aktif|online|connected|live)|sinkronisasi aktif|terkoneksi|db connected|connection (status|active|established))
PatternSlop : (?i)(dengan mudah|dengan cepat|dengan aman|yang lebih \w+|solusi \w+|sistem \w+|platform \w+|untuk (\w+ ){2,}yang|pantau \w+ anda|kelola \w+ anda|lihat semua)
EmDash      : —
Filler      : (?i)lorem ipsum|judul halaman|deskripsi singkat|your title|heading here|john doe|hero section|bento grid
Seru        : >[^<{]*![^<=]*<
```

Hit di komentar kode / nama class / data user asli = abaikan dan catat.

---

## 8. Output Marker

```
[COPY CHECK] Echo: ✅ | Blocklist: ✅ | Limit: ✅ | Meta: ✅ | TechLeak: ✅ | InfraBadge: ✅ | EmDash: ✅ | Lint: ✅ (0 hit)
```

Ada ❌ → perbaiki sebelum declare done. Jika ada yang diubah:
`[Pragmatic Check] Removed: [buzzword/literal-copy/tech-leak/infra-badge/em-dash] → Replaced: [versi lugas]`

