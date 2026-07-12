---
name: git-workflow
description: |
  Protokol dan panduan untuk manajemen version control Git di Vibes Coding Workflow.
  Mencakup penamaan branch, conventional commits, perlindungan data sensitif, dan validasi commit.
  Aktif saat user meminta "commit", "push", "branch", "merge", "pull request", "git workflow".
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis pada skenario:

| Skenario | Contoh Trigger | Langkah Utama |
|---|---|---|
| Melakukan commit | "Commit perubahan", "Push ke git" | Sanitasi file + Conventional Commit |
| Membuat branch baru | "Buat branch baru", "Checkout branch" | Format: `type/deskripsi-singkat` |
| Persiapan PR / Merge | "Buat Pull Request", "Gabungkan branch" | Pre-PR Checklist |

---

## 🔒 Proteksi Keamanan Git (Wajib — Zero Leak)

Sebelum menjalankan `git commit`, AI **REQUIRED** melakukan pemeriksaan berikut secara senyap:
1. **Unstage file sensitif:** Pastikan file berikut tidak masuk ke stage (`git restore --staged <file>`):
   - `.env`, `.env.local`, `.env.production`
   - Berkas database lokal (seperti `*.db`, `*.sqlite`, `*.sql`)
   - Berkas instrumen AI (`prd.md`, `handover.md`, `todo.md`, `app-context.md`)
   - Folder debug/temp (`.scratchpad/`, `tmp/`)
2. **Pindai Secrets:** Periksa apakah file yang di-commit mengandung API Key, Password, atau token sensitif.

---

## 1. Aturan Penamaan Branch

Branch harus merepresentasikan tipe pekerjaan dengan format `tipe/deskripsi-singkat` (lowercase, gunakan hyphen):

| Tipe Branch | Tujuan | Contoh |
|---|---|---|
| `feat/` | Menambahkan fitur baru | `feat/auth-captcha` |
| `fix/` | Memperbaiki bug | `fix/port-conflict-3000` |
| `refactor/` | Optimasi struktur kode tanpa merubah fungsi | `refactor/clean-css-variables` |
| `docs/` | Mengubah dokumentasi | `docs/update-readme` |
| `perf/` | Optimasi performa | `perf/optimize-image-pipeline` |

---

## 2. Conventional Commits (Format Pesan Commit)

Pesan commit harus singkat, deskriptif, dan mengikuti spesifikasi Conventional Commits:

Format: `<tipe>(<scope>): <deskripsi-singkat-bahasa-inggris>`

### Tipe Commit
- **`feat`**: Fitur baru
- **`fix`**: Perbaikan bug
- **`refactor`**: Perubahan kode yang tidak merubah fungsi maupun memperbaiki bug
- **`docs`**: Perubahan dokumentasi saja
- **`style`**: Perubahan styling/format kode (spasi, semi-kolon, dll)
- **`perf`**: Optimasi performa
- **`chore`**: Maintenance bulanan, update dependensi, konfigurasi build

### Contoh Pesan Commit
- `feat(auth): implement case-insensitive captcha verification`
- `fix(server): resolve address already in use port conflict`
- `style(theme): refactor oklch color variables with hex fallback`
- `chore(deps): update prisma client dependency`

---

## 3. Alur Kerja Commit & Push (5 Tahap)

Setiap kali akan melakukan commit dan push, ikuti alur berikut:

1. **Tahap 1: Pre-flight Check (Lint & Build)**
   Pastikan kode terkompilasi dengan sukses (`npm run build` / lint checker pass).
2. **Tahap 2: Status Check**
   Jalankan `git status` untuk melihat daftar file yang berubah.
3. **Tahap 3: Git Sanitization**
   Unstage semua file sensitif (lihat bagian Proteksi Keamanan Git).
4. **Tahap 4: Commit**
   Gunakan conventional commit message.
5. **Tahap 5: Verification**
   Pastikan commit tidak mengandung file-file yang terlarang di repo.

---

## 4. Template Pull Request (PR)

Saat membuat dokumentasi PR atau mendeskripsikannya ke user, gunakan template berikut:

```markdown
## Deskripsi Perubahan
[Penjelasan singkat apa yang dirubah dan mengapa]

## Tipe Perubahan
- [ ] Fitur Baru (`feat`)
- [ ] Perbaikan Bug (`fix`)
- [ ] Refactoring (`refactor`)
- [ ] Dokumentasi (`docs`)

## Checklist Verifikasi
- [ ] Kode terkompilasi dengan sukses di lokal (Active Build compilation OK)
- [ ] Tidak ada file sensitif (.env, prd.md, dll) yang ikut ter-stage
- [ ] Semua image tag sudah memiliki `onerror` fallback
- [ ] Warna menggunakan format `oklch()` dengan fallback Hex
```
