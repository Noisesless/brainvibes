# RULE: Anti-Bloat Code & Anti-Verbosity (Pragmatic Output Law)
# Cross-ref: gemini.md §0 #7, §1 HARD BLOCK #11, gemini-execution.md §4.O
# Berlaku universal — SEMUA proyek, SEMUA sesi, SEMUA stack.

---

## Ringkasan

AI FORBIDDEN menghasilkan output yang lebay, hiperbola, atau over-engineered.
Berlaku untuk 3 domain: **bahasa dialog**, **teks dalam aplikasi**, dan **arsitektur kode**.

---

## §1. Anti-Verbosity & Anti-Buzzword (Dialog AI → User)

### FORBIDDEN Words & Phrases (Blocklist Dialog):
- ❌ "powerful", "robust", "enterprise-grade", "state-of-the-art", "cutting-edge"
- ❌ "blazingly fast", "lightning fast", "incredibly", "amazingly", "stunning"
- ❌ "game-changing", "revolutionary", "world-class", "next-gen", "best-in-class"
- ❌ "seamless", "effortless", "magical", "delightful", "beautiful"
- ❌ "leverage", "utilize" (gunakan "use" / "pakai")
- ❌ "ecosystem", "paradigm", "synergy" (kecuali konteks teknis presisi)
- ❌ "unlock the full potential", "take it to the next level"
- ❌ Emoji berlebihan (max 1-2 per respons, bukan hiasan setiap kalimat)
- ❌ Bahasa Indonesia: "luar biasa", "sempurna", "spektakuler", "fenomenal", "revolusioner", "super canggih", "next level"

> Blocklist untuk **teks di UI aplikasi** (lebih panjang, EN+ID) ada di `taste-skill-bridge/COPY_RULES.md §4`.

### REQUIRED Gaya Bicara:
- ✅ Lugas, langsung ke poin. Seperti senior dev bicara ke rekan kerja.
- ✅ Jika perlu memuji: "sudah jalan", "selesai", "oke" — bukan "luar biasa sekali!"
- ✅ Kalimat pendek. Hindari subordinat bertingkat.
- ✅ Fakta > opini. Angka > adjektiva.

### Contoh Pelanggaran vs Benar:
```
❌ "Saya telah berhasil mengimplementasikan fitur login yang powerful dan robust 
    dengan arsitektur yang sangat scalable!"
✅ "Login selesai. Pakai JWT + bcrypt, session 24h."

❌ "Ini adalah solusi yang incredibly elegant dan akan transform 
    keseluruhan user experience Anda!"
✅ "Form sudah diperbaiki. Validasi client-side + server-side aktif."
```

---

## §2. Anti-Literal Copy (Teks dalam Aplikasi)

### Masalah:
AI menelan mentah-mentah instruksi user lalu menjadikannya teks UI di aplikasi.

> **SSOT:** `taste-skill-bridge/COPY_RULES.md` — Copy Gate (`[COPY TABLE]`), batas kata, blocklist, lint regex.
> Bagian ini ringkasan; jika ada beda angka, COPY_RULES.md menang.

### Prosedur (bukan hanya larangan):
1. Ambil **entitas + aksi** dari instruksi user.
2. Buang kata instruksi (buat, tampilkan, halaman, fitur, untuk, lengkap...).
3. Tulis teks UI dari entitas/aksi itu di `[COPY TABLE]` sebelum menulis kode.

### FORBIDDEN:
- ❌ Copy-paste instruksi user sebagai heading/label/placeholder/tooltip di app.
- ❌ Menuliskan deskripsi fitur yang terlalu verbose sebagai subtitle halaman.
- ❌ Membuat teks UI yang berbunyi seperti requirements document.
- ❌ Placeholder/tooltip yang lebih panjang dari 8 kata tanpa alasan UX.
- ❌ Hero subtitle > 15 kata. Deskripsi card > 25 kata. Toast message > 10 kata.

### REQUIRED:
- ✅ Teks UI harus ditulis seperti produk nyata — ringkas, natural, sesuai konteks.
- ✅ Heading: max 3-5 kata. Subtitle: max 10-15 kata.
- ✅ Gunakan bahasa end-user, bukan bahasa developer/requirements.
- ✅ Jika instruksi user = "buat halaman untuk menampilkan semua data transaksi penjualan harian"
  → heading: "Transaksi Harian" (bukan "Halaman untuk Menampilkan Semua Data Transaksi Penjualan Harian")

### Contoh Pelanggaran vs Benar:
```
User: "buat dashboard yang menampilkan statistik lengkap penjualan bulanan"

❌ <h1>Dashboard yang Menampilkan Statistik Lengkap Penjualan Bulanan</h1>
   <p>Halaman ini menampilkan statistik lengkap dari data penjualan bulanan 
      yang mencakup grafik, tabel, dan ringkasan komprehensif</p>

✅ <h1>Penjualan Bulanan</h1>
   <p>Ringkasan performa bulan ini</p>
```

### §2.A Anti-Kebocoran Instruksi Teknis & Timezone (Technical Leak)
Instruksi teknis adalah arahan eksekusi logika kode/backend, BUKAN teks tampilan layar end-user:
- **Timezone:** User minta "buat log aktivitas dengan local time jakarta":
  - ❌ `<th>Waktu (WIB)</th>` atau `<td>17:02 (WIB)</td>` atau `<span>Zona waktu Asia/Jakarta</span>`
  - ✅ `<th>Waktu</th>` dan `<td>17:02</td>`. Format waktu diatur di backend/JS, FORBIDDEN menempelkan `(WIB)`.
- **Sorting/Urutan:** User minta "urutkan data dari yang paling baru":
  - ❌ `<p>Data realtime diurutkan terbaru</p>`
  - ✅ Cukup render tabel/list yang sudah terurut via query backend / sorting JS.
- **Keamanan/Enkripsi:** User minta "enkripsi password pakai bcrypt":
  - ❌ `<small>Password aman dienkripsi bcrypt</small>`
  - ✅ Cukup `<label>Kata Sandi</label>`.
- **Fitur Teknis Lainnya:** FORBIDDEN memajang "Responsive layout", "Mobile friendly", "REST API", "Lucide icons", atau "OWASP compliant" sebagai teks di antarmuka aplikasi.

---

## §3. Anti-Over-Engineering (Arsitektur & Kode)

### FORBIDDEN:
- ❌ Abstraksi tanpa konsumen kedua (YAGNI). Jangan buat base class/interface jika hanya 1 implementasi.
- ❌ Design pattern demi pattern. Factory/Strategy/Observer hanya jika ada kebutuhan nyata.
- ❌ Wrapper function yang hanya memanggil 1 fungsi lain tanpa logic tambahan.
- ❌ Config file untuk hal yang hanya dipakai 1 tempat.
- ❌ Type system berlebihan: generic 3+ level, union type > 5 varian, tanpa kebutuhan nyata.
- ❌ Folder structure > 4 level deep untuk proyek < 20 file.
- ❌ Env variable untuk nilai yang tidak berubah antar environment.
- ❌ Comment yang menjelaskan hal yang sudah jelas dari nama fungsi/variabel.
- ❌ Custom hook/utility untuk operasi 1-2 baris yang hanya dipakai sekali.
- ❌ Error boundary/fallback berlapis untuk fitur non-kritis.

### REQUIRED:
- ✅ **YAGNI First:** Tulis kode untuk kebutuhan saat ini. Refactor nanti saat ada konsumen kedua.
- ✅ **Flat > Nested:** Prefer flat structure. Nesting hanya saat grouping sudah > 7 file.
- ✅ **Inline > Extract:** Logika < 5 baris yang hanya dipakai 1 tempat → inline, jangan extract.
- ✅ **Direct > Indirect:** Panggil langsung, jangan buat layer perantara tanpa alasan.
- ✅ **Readable > Clever:** Kode yang bisa dibaca junior dev > kode yang "elegant" tapi cryptic.

### Metric Pragmatis:
| Ukuran Proyek | Max Folder Depth | Max Abstraction Layer | Pattern Boleh |
|---|---|---|---|
| < 10 file | 2 | 1 (langsung) | Tidak perlu |
| 10-30 file | 3 | 2 (controller + model) | MVC basic |
| 30-100 file | 4 | 3 (presentation + logic + data) | MVC + Service |
| > 100 file | Sesuai kebutuhan | Sesuai kebutuhan | Justified only |

---

## §4. Dynamic Dev/Prod (Environment-Aware Coding)

### REQUIRED:
- ✅ Kode harus jalan di dev DAN prod tanpa ubah source code — hanya beda `.env`.
- ✅ Gunakan environment variable HANYA untuk hal yang benar-benar beda antar environment:
  - DB host/credentials, API keys, base URL, debug mode, log level.
- ✅ Default value yang masuk akal untuk development (fail-open di dev, fail-secure di prod).
- ✅ Conditional logic dev/prod: max 3 tempat per proyek (biasanya: logger, error display, CORS).

### FORBIDDEN:
- ❌ `if (process.env.NODE_ENV === 'development')` tersebar di > 5 file.
- ❌ Env variable untuk setiap magic number/string.
- ❌ Build config berbeda drastis antara dev dan prod (kecuali minification/sourcemap).
- ❌ Feature flag system untuk proyek < 50 file (cukup `if/else` biasa).

---

## §5. Enforcement & Self-Check

Sebelum submit kode/respons, AI WAJIB self-check:
1. **Dialog:** Apakah ada buzzword dari §1 blocklist? → Hapus, ganti kata lugas.
2. **Teks UI:** Apakah `[COPY TABLE]` sudah dicetak? Apakah ada 3+ kata berurutan yang sama dengan instruksi user, atau kata dari blocklist? → Ringkaskan, jalankan lint `COPY_RULES.md §7`.
3. **Arsitektur:** Apakah ada abstraksi tanpa konsumen kedua? → Inline/hapus.
4. **Environment:** Apakah ada conditional dev/prod yang bisa diganti env variable? → Refactor.

Output wajib jika ada perbaikan:
```
[Pragmatic Check] Removed: [buzzword/over-abstraction/literal-copy] → Replaced: [versi lugas]
```
