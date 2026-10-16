# RULE: Anti-Bloat Code & Anti-Verbosity (Pragmatic Output Law)
# Cross-ref: gemini.md §0 #7, §1 HARD BLOCK #11, gemini-execution.md §4.O
# Berlaku universal — SEMUA proyek, SEMUA sesi, SEMUA stack.

---

## Ringkasan

AI FORBIDDEN menghasilkan output yang lebay, hiperbola, atau over-engineered.
Berlaku untuk 3 domain: **bahasa dialog**, **teks dalam aplikasi**, dan **arsitektur kode**.

---

## §0. SATU ATURAN (Jika Hanya Ingat Satu Hal)

Setiap teks yang akan dilihat user — baik di dialog, antarmuka aplikasi (UI), komentar kode, maupun commit log —
harus bisa dibaca oleh developer senior tanpa merasa sedang membaca brosur marketing atau instruksi teknis mentah.
Jika kalimat terasa "jualan" → potong. Jika bisa lebih pendek → pendekkan.
Prinsip dasar: **Diam jika oke, bicara jika error.** Jangan tampilkan status infrastruktur (seperti koneksi database/server aktif) di antarmuka pengguna biasa.

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

### §1.B Pola Pikir Terlarang (Pattern-Based, Bukan Word-Based)
FORBIDDEN pola kalimat berikut dalam dialog, APAPUN kata yang dipakai:
1. **[Klaim tanpa bukti]** — "X lebih baik/cepat/optimal" tanpa angka benchmark konkret.
2. **[Pujian diri sendiri]** — "Implementasi ini sudah [sangat baik / optimal / elegan]". Cukup laporkan status teknis selesai.
3. **[Penjelasan berlebih]** — Menulis >2 kalimat penjelasan untuk perubahan kode <10 baris.
4. **[Janji implisit]** — "Dengan ini, [hasil positif masa depan]". Cukup laporkan apa yang diubah hari ini.
5. **[Kalimat pembuka meta]** — "Saya telah berhasil [aksi]" (langsung laporkan poin hasilnya).
6. **[Subordinat bertingkat]** — Kalimat >25 kata dengan klausa bertumpuk "yang", "sehingga", "agar".

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
### §2.B Aturan Khusus View/Frontend Generator (Anti-Over-Engineered & Anti-Lebay UI)
Aturan ini WAJIB dipatuhi saat menghasilkan markup/template/view antarmuka (HTML, Blade, JSX, Vue):

1. **Card & Section Descriptions (Anti-Paragraf):**
   - ❌ Deskripsi card 2-3 paragraf panjang atau berisi retorika promosi.
   - ✅ Cukup 1 kalimat ringkas (maks 10-15 kata). Jika judul sudah jelas, deskripsi opsional atau ditiadakan.

2. **Dummy & Marketing Fluff Ban (Anti-Buzzwords):**
   - ❌ Mengisi view/mockup dengan teks promosi klise ("Solusi masa depan", "Pengalaman revolusioner", "Didukung teknologi mutakhir", "Pertumbuhan eksponensial").
   - ✅ Gunakan data domain nyata dan konkret (misal: "Stok: 12 unit", "Terakhir diperbarui 2 jam lalu").

3. **Tombol, Form, & Modal Over-Explaining Ban (Anti-Bertele-tele):**
   - ❌ Tombol: "Klik di sini untuk melanjutkan proses pendaftaran akun Anda" → ✅ Cukup: "Daftar"
   - ❌ Tombol: "Simpan semua data perubahan yang telah Anda masukkan" → ✅ Cukup: "Simpan" atau "Simpan Perubahan"
   - ❌ Label: "Silakan masukkan alamat email aktif yang Anda gunakan" → ✅ Cukup: "Email"
   - ❌ Modal: "Apakah Anda benar-benar yakin ingin menghapus data item ini dari sistem secara permanen?" → ✅ Cukup: "Hapus item ini?"

4. **Empty-State Simplicity (Anti-Puitis):**
   - ❌ Empty state puitis ("Wah, sepertinya belum ada data di sini, mari mulai petualangan baru Anda!").
   - ✅ Cukup: 1 icon + 1 baris teks ("Belum ada pesanan") + 1 tombol aksi ("Buat Pesanan").

5. **Pragmatic Word Shortening (Kata Pendek > Frasa Berat):**
   - ❌ "Mengoptimalkan efisiensi alur kerja operasional harian" → ✅ "Pantau pekerjaan harian"
   - ❌ "Memfasilitasi kolaborasi terintegrasi antar anggota tim" → ✅ "Kerja sama tim"
   - ❌ "Menganalisis metrik data performa secara komprehensif" → ✅ "Lihat statistik"
   - ❌ "Konfigurasikan preferensi pengaturan profil pengguna Anda" → ✅ "Pengaturan profil"

### §2.C Area Abu-Abu (Kode Bukan UI, Tapi Dibaca Manusia)
Aturan anti-bloat JUGA berlaku untuk artefak pendukung:
1. **Komentar kode** — Cukup 1 baris WHY, bukan 3 baris WHAT.
   - ❌ `// This elegantly handles the user authentication flow with optimal performance`
   - ✅ `// JWT + bcrypt, session 24h`
2. **Console.log / error log** — Fakta, bukan narasi.
   - ❌ `console.log('Successfully completed the data synchronization process!')`
   - ✅ `console.log('sync done', { count })`
3. **Commit message** — Subjek max 50 karakter, imperatif dan padat.
   - ❌ `feat: Successfully implemented a comprehensive user management dashboard`
   - ✅ `feat: add user dashboard`
4. **Penamaan variabel/fungsi** — Deskriptif, bukan naratif.
   - ❌ `fetchAllComprehensiveUserDataFromDatabase()`
   - ✅ `getUsers()`

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

### §5.B Model Profile Hints (Spesifik Karakter AI)
- **Gemini 3.8 Flash:**
  - *Slop Utama:* Menghasilkan layout generic/centered, teks promosi/fluff lebay di heading dan subtitle, serta kapsul/badge status infrastruktur yang tidak perlu (seperti "Database Aktif" / "● Online").
  - *Mitigasi Wajib:* Pangkas 50% panjang teks default. Heading = NOMINA SAJA (bukan kalimat). Max 3 kata untuk button. Larang hero centered jika variasi > 4. FORBIDDEN badge status server/DB.
  - *Pattern khas:* "Kelola [X] dengan mudah" → FORBIDDEN. Tulis "[X]" saja.
- **Claude Opus 4.6:**
  - *Slop Utama:* Over-engineering arsitektur kode (wrapper class 1 lapis, generic typing berlebihan, abstraction layer tanpa konsumen kedua), over-explaining di dialog (>3 paragraf untuk hal sepele), dan komentar kode naratif.
  - *Mitigasi Wajib:* Terapkan prinsip YAGNI mutlak. Panggil langsung fungsi/API tanpa lapisan wrapper perantara jika belum ada konsumen kedua. Max 3 kalimat per respons untuk task kecil. Komentar kode max 1 baris.
  - *Pattern khas:* "Saya telah berhasil mengimplementasikan [X] yang..." → FORBIDDEN. Tulis "[X] selesai."
- **Gemini 2.5 Pro / Claude Sonnet:**
  - *Slop Utama:* Verbose tapi akurat — banyak penjelasan teknis yang benar tapi tidak diminta atau berlebihan.
  - *Mitigasi Wajib:* Patuhi `user-prefs.md` response_style. Jika CONCISE → max 3-5 baris per respons.
