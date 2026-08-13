---
name: security-patterns
description: |
  Skill keamanan proaktif untuk Vibes Coding Workflow. Berisi:
  - Database vulnerability yang pernah ditemukan per proyek (learned vulnerabilities)
  - Pattern aman per stack (secure coding patterns)
  - Template dokumentasi audit keamanan (security-audit.md)
  Auto-aktif saat: "cek komponen", "cek kelengkapan", "verifikasi kode",
  "cek regulasi", "perbaiki keamanan", "fix vulnerability".
  Juga dibaca SILENT saat mode coding biasa untuk mencegah pengulangan vulnerability.
---

## Cara Kerja Skill Ini

### Kapan Dibaca AI

| Skenario | Trigger | Aksi |
|---|---|---|
| Saklar `cek komponen` aktif | User ketik saklar | Baca `data/secure-patterns.md` + `data/xampp-php-patterns.md` → gunakan sebagai SP compliance checklist (OWASP mapping) |
| Coding mode biasa (SILENT) | AI menulis kode auth/input/db/upload/api | Baca `data/known-vulns.md` → HINDARI pola yang pernah jadi vulnerability |
| Setelah fix vulnerability | AI selesai perbaiki vuln dari audit | Tulis entry baru ke `data/known-vulns.md` (dengan approval user) |
| Proyek baru (`awal baru`) | Knowledge Priming step | Baca `data/secure-patterns.md` → pre-populate todo.md dengan security best practices |

### Hierarki File Data

```
security-patterns/
├── SKILL.md                          ← File ini (instruksi)
├── data/
│   ├── known-vulns.md                ← Database vulnerability yang PERNAH ditemukan
│   ├── secure-patterns.md            ← Pattern coding aman per stack
│   └── audit-template.md             ← Template output security-audit.md
```

---

## §1. Format Dokumentasi Vulnerability (known-vulns.md)

Setiap vulnerability yang ditemukan saat compliance check atau fix WAJIB didokumentasikan
dengan format berikut di `data/known-vulns.md`:

```markdown
[VULN-NNN] [Judul vulnerability singkat]
Severity   : CRITICAL / HIGH / MEDIUM / LOW
OWASP      : [Kategori OWASP — Injection / Auth / Data Exposure / dll]
Stack      : [Stack yang terdampak — PHP Native / Laravel / Next.js / Semua]
Proyek Asal: [Nama proyek tempat vulnerability ditemukan]
Tanggal    : [YYYY-MM-DD]

Lokasi:
  File     : [path/relative/ke/root/proyek.php]
  Baris    : [X-Y]
  Fungsi   : [nama_fungsi() atau route handler]
  Konteks  : [deskripsi 1 baris — apa yang dilakukan kode ini]

Kode Rentan (SEBELUM fix):
  ```[lang]
  [kode asli yang bermasalah — max 15 baris, fokus pada baris rentan]
  ```

Vektor Serangan:
  [Bagaimana attacker bisa exploit ini — 1-3 kalimat]

Kode Aman (SETELAH fix):
  ```[lang]
  [kode setelah diperbaiki — max 15 baris, baris yang berubah ditandai // FIXED]
  ```

Pelajaran:
  [Apa yang harus diingat AI agar tidak mengulangi — 1-2 kalimat]

Dampak ke File Lain:
  [Daftar file yang JUGA terpengaruh saat fix diterapkan, atau "Tidak ada" jika isolated]
  - [path/file1.php] — [alasan kenapa terpengaruh]
  - [path/file2.js] — [alasan kenapa terpengaruh]
```

### Aturan Dokumentasi

1. **WAJIB mencatat SEMUA file yang terpengaruh** — ini mencegah AI merusak kode lain saat fixing
2. **WAJIB mencantumkan kode SEBELUM dan SESUDAH** — AI bisa belajar pattern transformasi
3. **WAJIB mencantumkan vektor serangan** — AI memahami MENGAPA ini berbahaya, bukan hanya APA
4. **Konteks fungsi WAJIB ada** — AI tahu peran kode ini dalam sistem, bukan hanya lokasi
5. **FORBIDDEN** menulis entry tanpa contoh kode — documentation without code = useless

---

## §2. Format Secure Patterns (secure-patterns.md)

Pattern coding aman yang harus SELALU digunakan AI, terorganisir per stack.

```markdown
[SP-NNN] [Nama pattern]
Stack    : [Stack yang berlaku]
Kategori : [Input / Auth / Database / Upload / API / Config / Headers]

Pattern Aman:
  ```[lang]
  [kode pattern yang BENAR — reusable snippet]
  ```

Anti-Pattern (FORBIDDEN):
  ```[lang]
  [kode yang SALAH — apa yang harus dihindari]
  ```

Alasan: [Mengapa pattern aman diperlukan — 1 kalimat]
```

---

## §3. Format Output Security Audit (audit-template.md)

Saat `cek komponen` dijalankan dan menemukan gap kritis, output WAJIB menggunakan format
di `data/audit-template.md`. Format ini dirancang agar:

1. **AI bisa FIX tanpa merusak** — setiap temuan punya lokasi presisi + konteks ketergantungan
2. **AI bisa BELAJAR** — setiap temuan bisa di-convert ke entry `known-vulns.md`
3. **User bisa PRIORITAS** — severity jelas, dampak terukur

---

## §4. Protokol Fix Vulnerability (WAJIB DIIKUTI)

Saat AI memperbaiki vulnerability dari `security-audit.md`:

### 4A. Pre-Fix Checklist (SEBELUM menulis kode)
1. Baca entry vulnerability di `security-audit.md` — pahami LOKASI + KONTEKS
2. Baca "Dampak ke File Lain" — identifikasi SEMUA file yang perlu disentuh
3. Baca `data/known-vulns.md` — cek apakah vulnerability serupa pernah ditemukan dan sudah ada pattern fix-nya
4. Baca `data/secure-patterns.md` — gunakan pattern aman yang sudah terbukti

### 4B. Fix Rules (SAAT menulis kode)
1. **FORBIDDEN** mengubah file yang TIDAK terdaftar di "Dampak ke File Lain"
2. **REQUIRED** gunakan pattern dari `secure-patterns.md` jika tersedia untuk kategori ini
3. **REQUIRED** test bahwa fungsi asli masih bekerja setelah fix (no regression)
4. **REQUIRED** tandai baris yang diubah dengan komentar `// SECURITY FIX: [VULN-NNN]`

### 4C. Post-Fix Documentation (SETELAH fix selesai)
1. AI REQUIRED menawarkan untuk menyimpan vulnerability ke `data/known-vulns.md`:
   ```
   [SECURITY LEARN] Vulnerability VULN-NNN telah diperbaiki.
   Simpan ke security-patterns/data/known-vulns.md? (Y/skip)
   ```
2. Jika user approve → tulis entry dengan format §1
3. Jika vulnerability mengungkap pattern baru → tawarkan juga ke `data/secure-patterns.md`
4. **FORBIDDEN** AI menulis ke data files tanpa approval user (konsisten dengan lessons-learned)

---

## §5. Integrasi dengan Coding Mode Biasa (SILENT READ)

Saat AI menulis kode dalam mode koding biasa (BUKAN `cek komponen`):

1. **SILENT READ** `data/known-vulns.md` — cek apakah kode yang sedang ditulis
   mirip dengan vulnerability yang pernah ditemukan
2. Jika MIRIP → AI REQUIRED gunakan pattern aman dari `data/secure-patterns.md`
   TANPA melaporkan ke user (ini coding habit, bukan audit)
3. Jika pattern aman tidak tersedia → AI gunakan best practice umum
   dari gemini.md §1 STANDARD poin 5 (Security-Aware Coding)

### Sinyal Similarity untuk Silent Read
AI mencocokkan kode yang sedang ditulis dengan `known-vulns.md` berdasarkan:
- Nama fungsi/method yang sama
- Stack yang sama
- Kategori OWASP yang sama
- Pattern kode yang mirip (string concat di query, innerHTML, eval, dll)

Jika ≥2 sinyal cocok → terapkan pattern aman secara otomatis.

---

## §6. Aturan Keamanan Data Skill (Identik dengan lessons-learned)

1. **FORBIDDEN** AI menulis ke `data/*.md` tanpa instruksi eksplisit user
2. **FORBIDDEN** AI menghapus/menimpa entry existing tanpa konfirmasi
3. **FORBIDDEN** AI menambahkan entry duplikat — cek dulu apakah VULN-ID sudah ada
4. Sebelum menulis entry baru, AI REQUIRED cetak preview:
   ```
   [SECURITY ENTRY PREVIEW]
   File target: data/known-vulns.md
   Entry baru:
     [VULN-NNN] SQL Injection di login handler
     Severity: CRITICAL | OWASP: Injection | Stack: PHP Native
     File: auth/login.php:45-52
   Tulis? (Y/skip)
   ```
5. Numbering: VULN-001, VULN-002, ... (auto-increment dari entry terakhir)
