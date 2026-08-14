# Security Audit Template

*Template ini digunakan AI saat menjalankan saklar `cek komponen` (atau saat remediation).*
*Output ditulis ke `/.docs/security-audit.md` di root proyek.*

---

## Format Output

```markdown
# Security Audit — [Nama Proyek]

| Parameter | Nilai |
|---|---|
| Tanggal | [YYYY-MM-DD HH:MM] |
| Stack | [Framework + DB + Styling dari prd.md] |
| Scan Mode | Static / Manual / Hybrid |
| Total File Diperiksa | [N] |
| Auditor | AI (Antigravity IDE / CLI) |

---

## Ringkasan Temuan

| Severity | Jumlah | Status |
|---|---|---|
| 🔴 CRITICAL | [N] | [OPEN / FIXED] |
| 🟠 HIGH | [N] | [OPEN / FIXED] |
| 🟡 MEDIUM | [N] | [OPEN / FIXED] |
| ℹ️ INFO | [N] | [OPEN / FIXED] |

---

## 🔴 CRITICAL — Vulnerability Aktif (Harus Fix SEBELUM Deploy)

### [VULN-NNN] [Judul Vulnerability]

**Klasifikasi:**
| Parameter | Nilai |
|---|---|
| OWASP | [Kategori — Injection / Broken Auth / Data Exposure / dll] |
| Severity | CRITICAL |
| Attack Vector | [Network / Local / Adjacent] |
| Exploitability | [Mudah / Sedang / Sulit] |

**Lokasi Presisi:**
| Parameter | Nilai |
|---|---|
| File | `[path/relative/ke/root.php]` |
| Baris | [X-Y] |
| Fungsi/Method | `[nama_fungsi()]` atau `[route: POST /api/login]` |
| Konteks Bisnis | [Apa yang dilakukan kode ini dalam sistem — misal: "Handler login utama"] |

**Kode Rentan:**
```[lang]
// File: [path]
// Baris: [X-Y]
[kode bermasalah — max 15 baris, tandai baris rentan dengan ← VULNERABLE]
```

**Vektor Serangan:**
[Bagaimana attacker exploit — langkah-langkah konkret]

**Proof of Concept (Jika Applicable):**
```
[cURL command / payload / step-by-step reproduction]
```

**Rekomendasi Fix:**
```[lang]
// File: [path]
// Baris: [X-Y]
[kode yang sudah diperbaiki — tandai perubahan dengan // SECURITY FIX]
```

**Dampak ke File Lain (Dependency Map):**
| File | Alasan Terpengaruh | Perubahan yang Dibutuhkan |
|---|---|---|
| [path/file1.php] | [Import/call fungsi yang diubah] | [Apa yang harus diubah di file ini] |
| [path/file2.js] | [Menggunakan response dari endpoint yang diubah] | [Apa yang harus diubah] |
| Tidak ada | — | — |

**Status:** ⏳ OPEN / ✅ FIXED ([tanggal fix])

---

## 🟠 HIGH — Risiko Signifikan

### [VULN-NNN] [Judul]
[... format sama dengan CRITICAL ...]

---

## 🟡 MEDIUM — Best Practice Violation

### [VULN-NNN] [Judul]

**Lokasi:** `[path]` baris [X-Y]
**Kategori:** [OWASP kategori]
**Temuan:** [Deskripsi singkat]
**Rekomendasi:** [Aksi yang harus dilakukan]
**Status:** ⏳ OPEN / ✅ FIXED

---

## ℹ️ INFO — Saran Hardening (Opsional)

- [ ] [Saran 1] — File: `[path]`
- [ ] [Saran 2] — File: `[path]`

---

## Compliance Score (OWASP Top 10:2025)

| OWASP | Kategori | SP Checked | Implemented | Score |
|---|---|---|---|---|
| A01 | Broken Access Control | SP-006, SP-020, SP-021 | [N]/[total] | [0-1] |
| A02 | Security Misconfiguration | SP-008, SP-011~013 | [N]/[total] | [0-1] |
| A03 | Supply Chain Failures | SP-016 + dep audit | [N]/[total] | [0-1] |
| A04 | Cryptographic Failures | SP-004, SP-007, SP-009 | [N]/[total] | [0-1] |
| A05 | Injection | SP-001, SP-002 | [N]/[total] | [0-1] |
| A06 | Insecure Design | SP-014/015 | [N]/[total] | [0-1] |
| A07 | Authentication Failures | SP-004, session hardening | [N]/[total] | [0-1] |
| A08 | Software Integrity | SP-017 | [N]/[total] | [0-1] |
| A09 | Logging Failures | SP-018 | [N]/[total] | [0-1] |
| A10 | Exceptional Conditions | SP-019 | [N]/[total] | [0-1] |
| | | | **Total** | **[X]/10** |

**Rating:** 🟢 EXCELLENT (9-10) / 🟡 GOOD (7-8) / 🟠 FAIR (5-6) / 🔴 POOR (<5)

> Scoring: per kategori = (jumlah SP implemented / jumlah SP checked). Total = rata-rata semua kategori × 10.

---

## Log Perbaikan

| VULN-ID | Tanggal Fix | File Diubah | Verifikasi |
|---|---|---|---|
| VULN-001 | [YYYY-MM-DD] | [path1, path2] | ✅ Tested / ⏳ Pending |

---

## Catatan untuk Sesi Berikutnya

[Catatan AI tentang area yang belum sempat di-audit atau perlu re-check]
```

---

## Aturan Penggunaan Template

1. **Setiap temuan WAJIB punya Lokasi Presisi** — File + Baris + Fungsi + Konteks
2. **Setiap temuan CRITICAL/HIGH WAJIB punya Dependency Map** — file apa yang terpengaruh
3. **Setiap temuan CRITICAL/HIGH WAJIB punya Rekomendasi Fix** dengan kode contoh
4. **Status tracking WAJIB diupdate** saat fix diterapkan
5. **Log Perbaikan di akhir** — ringkasan semua fix untuk traceability
6. **VULN-ID harus unik per proyek** — format: VULN-001, VULN-002, ...
7. **VULN-ID yang sudah di-fix dan di-approve** bisa di-copy ke `security-patterns/data/known-vulns.md`
   sebagai learned vulnerability untuk proyek-proyek selanjutnya
