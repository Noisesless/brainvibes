# Known Vulnerabilities Database — Vibes Coding Workflow

*Diisi otomatis setelah setiap `analisa keamanan` → fix → user approve.*
*AI WAJIB baca file ini SILENT saat coding mode untuk mencegah pengulangan.*

---

## Format Entry

```
[VULN-NNN] [Judul]
Severity   : CRITICAL / HIGH / MEDIUM / LOW
OWASP      : [Kategori]
Stack      : [Stack]
Proyek Asal: [Nama proyek]
Tanggal    : [YYYY-MM-DD]

Lokasi:
  File     : [path]
  Baris    : [X-Y]
  Fungsi   : [nama]
  Konteks  : [deskripsi]

Kode Rentan (SEBELUM fix):
  [code block]

Vektor Serangan:
  [penjelasan]

Kode Aman (SETELAH fix):
  [code block]

Pelajaran:
  [insight]

Dampak ke File Lain:
  [daftar atau "Tidak ada"]
```

---

## Daftar Vulnerability

*Belum ada entry. Entry pertama akan dibuat saat `analisa keamanan` pertama kali dijalankan dan user menyetujui penyimpanan.*
