---
name: lessons-learned
description: |
  Activates when AI detects repeated problems, anti-patterns, or when user
  asks to check if a solution was tried before. Contains battle-tested solutions
  from real Vibes Coding projects and anti-patterns to avoid. Prevents AI from
  re-suggesting approaches that have already failed.
  Triggers on: "jangan ulangi", "pernah error", "cek dulu pernah coba",
  "pattern yang berhasil", "hindari", "lessons learned", "baca error".
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis saat:

| Skenario | Trigger | Aksi |
|---|---|---|
| Mode debug aktif | Saklar `baca error` | Cek `anti-patterns.md` sebelum coba solusi |
| User minta konfirmasi | "cek dulu pernah coba ini" | Scan `fast-solutions.md` |
| Komponen yang berulang | "buat login form lagi" | Cek `fast-solutions.md` untuk pattern siap pakai |
| Hindari jebakan stack | Mulai proyek baru | Baca `stack-gotchas.md` untuk stack terpilih |
| Akhir fase 8 | Proyek selesai | Generate retrospective ke `knowledge/project-retrospectives/` |

## Protokol Baca Sebelum Debug (REQUIRED)

Saat `baca error` aktif, SEBELUM mengusulkan solusi apapun:
1. Baca `data/anti-patterns.md` — pastikan solusi yang akan dicoba BUKAN dari daftar gagal
2. Baca `data/fast-solutions.md` — mungkin sudah ada solusi siap pakai
3. Baca `data/stack-gotchas.md` — mungkin ini jebakan stack yang sudah dikenal

Jika solusi ditemukan di `fast-solutions.md` → gunakan langsung tanpa reinventing the wheel.
Jika solusi ada di `anti-patterns.md` → FORBIDDEN menggunakan, propose alternatif.

## Cara Mengisi Data Skill Ini

### Jalur 1: /learn (Tercepat — Saat Koding)
Setelah bug berhasil diselesaikan, user ketik:
```
/learn [Masalah X] di [framework/OS] diselesaikan dengan [solusi].
Penyebab root: [penjelasan]. Jangan coba [pendekatan yang gagal].
```
Tersimpan otomatis ke `implicit/*.pb` — dibaca AI di sesi berikutnya.

### Jalur 2: Reminder Pasif (Zero Effort)
AI mendeteksi pola koreksi secara otomatis (gemini.md §1 GATE poin 5)
dan mencetak reminder di akhir batch task. User cukup baca atau abaikan.

### Jalur 3: Kurasi Manual (Saat Santai)
User minta AI menuliskan entry terstruktur ke file `data/` yang sesuai.
Contoh: "tambahkan ke stack-gotchas soal path OpenSID"

## Aturan Keamanan Data Skill

1. **FORBIDDEN** AI menulis ke file `data/*.md` secara otomatis tanpa instruksi eksplisit user
2. **FORBIDDEN** AI menghapus atau menimpa entry yang sudah ada tanpa konfirmasi
3. **FORBIDDEN** AI menambahkan entry duplikat — cek dulu apakah sudah ada entry serupa
4. Sebelum menulis entry baru, AI REQUIRED cetak preview ke user:
   ```
   [SKILL ENTRY PREVIEW]
   File target: data/stack-gotchas.md
   Entry baru:
     [SG-XXX] [deskripsi]
     Stack: [stack]
     Workaround: [solusi]
   Tulis? (Y/skip)
   ```
5. Jika user ketik Y atau "lanjut" → tulis. Jika diabaikan → jangan tulis.
