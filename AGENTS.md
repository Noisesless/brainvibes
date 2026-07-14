# AGENTS.md — Global AI Behavior Rules (Antigravity IDE)
# Path: C:\Users\GBC_PC\.gemini\AGENTS.md
# Berlaku untuk: Antigravity IDE (semua sesi, semua proyek)
# Rules ini MENAMBAH, bukan menggantikan, gemini.md

---

## SESSION INIT PROTOCOL (Tambahan gemini.md §3A)

### Prioritas Baca Awal (Urutan Wajib — Setiap Sesi Baru)

```
Step -1 : Baca user-prefs.md     → %USERPROFILE%\.gemini\user-prefs.md  [SILENT]
Step  0 : Baca app-context.md    → [workspace]/app-context.md           [SILENT, jika ada]
Step  1 : Baca prd.md §1-§3     → jika app-context.md tidak ada         [SILENT]
Step  2 : Ambil task aktif       → grep [/] di todo.md                  [SILENT]
```

FORBIDDEN: Membaca prd.md penuh, handover.md penuh, atau design-system.md
di session init — hanya baca yang dibutuhkan (selective context loading §3A.4).

---

## VISUAL OUTPUT GATE — TASTE-SKILL & ANTI-SLOP ENFORCEMENT
(PROTECTED BY gemini.md §1 HARD BLOCK #7)

🔴 HARD BLOCK: SETIAP kali AI akan menulis/mengedit kode yang menyentuh LAYER VISUAL
(CSS, style, class, komponen UI, ikon, warna, font, spacing, layout, gambar, animasi),
aturan berikut BERLAKU OTOMATIS — tanpa peduli apa kalimat perintah user:

### Untuk SEMUA perubahan visual (besar maupun kecil):
1. Gunakan CSS token `var(--vibe-*)` — FORBIDDEN hardcode hex/rgb/hsl
2. Gunakan icon library proyek — FORBIDDEN ikon SVG mentah/hand-rolled
3. FORBIDDEN memberi border/outline/stroke pada logo — logo as-is tanpa dekorasi
4. FORBIDDEN `font-family: Inter` tunggal — wajib 2 font (heading + body)
5. FORBIDDEN `background: white` / `color: black` hardcode
6. FORBIDDEN spacing acak (13px, 19px) — gunakan kelipatan 8pt grid
7. FORBIDDEN mencampur lebih dari 1 icon library dalam satu proyek
8. Patuhi seluruh 16 aturan Anti-AI-SLOP di gemini.md §4K F
9. AI REQUIRED memberikan rekomendasi style singkat yang sesuai Visual DNA proyek
   (dari `prd.md §3 CORE IDENTITY LOCK` atau `handover.md §4 Karakter Visual`)
   SEBELUM menulis kode perubahan visual

**Output WAJIB sebelum kode (untuk perubahan visual kecil):**
```
[Visual Gate] Perubahan: [deskripsi singkat] — token: [CSS token yang digunakan] — sesuai Visual DNA: ✅
```

### Untuk pembuatan halaman/komponen BARU, REDESIGN, atau PENYESUAIAN VISUAL DNA — tambahan wajib:

Trigger skenario ini aktif jika request mengandung salah satu sinyal:
```
Sinyal EKSPLISIT  : buat halaman, redesign, UI baru, landing page, buat komponen baru
Sinyal EDIT       : perbaiki halaman, edit tampilan, ubah layout, update tampilan,
                    update konten halaman, perbaiki artikel, buat artikel, halaman berita
Sinyal VDNA       : sesuai visual dna, sesuai vdna, visual dna, vdna,
                    samakan visual, konsistensi visual, ikuti desain halaman utama,
                    ikuti style halaman lain, perbaiki agar konsisten
```

Jika salah satu sinyal di atas terdeteksi → WAJIB:
1. Panggil `view_file` pada `%USERPROFILE%\.gemini\config\skills\taste-skill-bridge\SKILL.md`
2. Jalankan **STEP 0.E Visual DNA Inheritance Protocol** — baca halaman utama dulu, ekstrak DNA tokens
3. Baca Visual DNA proyek dari `prd.md §3` atau `handover.md §4`
4. Keluarkan baris `[Design Read]` + `[DNA Source]` + Three Dials + `[Style Rec]` SEBELUM kode apapun
5. Jalankan UUPM Pipeline (search.py jika Python aktif, atau jika diblokir/gagal, lakukan Direct-Read Fallback dengan membaca berkas CSV UUPM `colors.csv`, `styles.csv`, `typography.csv` di bawah `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\` menggunakan tool `view_file` atau `grep_search` untuk menentukan token visual secara manual).

**Output WAJIB sebelum kode (untuk pembuatan/redesign/VDNA alignment):**
```
[Design Read] Reading this as: [X] untuk [Y], vibe [Z], dials: V=[n] M=[n] D=[n]
[DNA Source] Inheriting from: [file halaman utama] — tokens: [daftar token]
[Style Rec] Rekomendasi: [style sesuai Visual DNA] — sumber: [UUPM/design-system.md/prd.md]
```


---

## USER-PREFS DEFAULTS (Fallback jika user-prefs.md tidak ditemukan)

Jika `user-prefs.md` tidak ada, gunakan defaults ini:
- Port: Vite=5173, Next.js=3100, PHP=8080
- Package Manager: npm
- Font: Inter + 1 heading font dari typography.csv UUPM
- Geometry: Rounded 8px
- Dark Mode: Dynamic Toggle Switch
- Output Mode: COMPACT
- context7 auto-trigger: next.js, laravel, tailwindcss, react, astro

---

## ANTI-SLOP ENFORCEMENT (Selalu Aktif di Semua Output UI)

1. FORBIDDEN `font-family: Inter` tunggal → wajib 2 font (heading + body)
2. FORBIDDEN Centered hero jika VARIANCE > 4 → pakai Split/Asymmetric
3. FORBIDDEN `h-screen` pada hero → REQUIRED `min-h-[100dvh]`
4. FORBIDDEN `background: white` hardcode → `var(--vibe-background)`
5. FORBIDDEN `border-radius: 8px` hardcode → `var(--radius-md)` CSS token
6. FORBIDDEN Eyebrow > 1 per 3 section → kurangi atau hapus
7. FORBIDDEN > 2 consecutive zigzag layout → break dengan layout berbeda
8. FORBIDDEN Warna `#6C63FF`, `#4CAF50`, `#2196F3` tanpa UUPM recommendation
9. FORBIDDEN halaman tanpa CSS containment (`max-width`, `overflow-wrap`, `img max-width`) → deklarasikan di awal task
10. FORBIDDEN menunda fix tipografi dengan alasan container belum ada → buat container DULU, fix tipografi BERSAMAAN

**Typography + Containment adalah UNCONDITIONAL:**
```
Jika menemukan: font tunggal, tidak ada max-width, img overflow, pre overflow
→ Wajib fix SEKARANG, dalam task yang sama, tanpa tunggu instruksi eksplisit
→ Alasan ❌ "belum di-declare", "bukan scope task", "tunggu layout" = INVALID
```

Referensi lengkap: `gemini.md §4K F` + `taste-skill-bridge SKILL.md §3.B + §4.1 + §4.10`

---

## SKILLS REGISTRY (Auto-Discovery)

| Skill Name | Path | Auto-Trigger Keywords |
|---|---|---|
| `ui-ux-pro-max` | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\` | awal baru, redesign, buat halaman |
| `taste-skill-bridge` | `%USERPROFILE%\.gemini\config\skills\taste-skill-bridge\` | redesign, buat halaman, UI baru, landing page, perbaiki halaman, buat artikel, halaman berita, template post, edit tampilan, ubah layout, sesuai visual dna, sesuai vdna, visual dna, vdna, samakan visual, konsistensi visual, update tampilan |
| `lessons-learned` | `%USERPROFILE%\.gemini\config\skills\lessons-learned\` | baca error, pernah coba, jangan ulangi |
| `code-snippets` | `%USERPROFILE%\.gemini\config\skills\code-snippets\` | buat form, buat navbar, buat modal, buat toast |
| `database-patterns` | `%USERPROFILE%\.gemini\config\skills\database-patterns\` | desain database, migration, seeder, query |
| `git-workflow` | `%USERPROFILE%\.gemini\config\skills\git-workflow\` | commit, push, branch, merge, PR |
| `accessibility-audit` | `%USERPROFILE%\.gemini\config\skills\accessibility-audit\` | audit a11y, screen reader, WCAG, cek a11y |
| `performance-audit` | `%USERPROFILE%\.gemini\config\skills\performance-audit\` | audit performa, lighthouse, LCP, web vitals |
| `deployment-checklist` | `%USERPROFILE%\.gemini\config\skills\deployment-checklist\` | deploy, hosting, production, go live |
| `security-patterns` | `%USERPROFILE%\.gemini\config\skills\security-patterns\` | analisa keamanan, scan keamanan, cek vulnerability, security audit, perbaiki keamanan, fix vulnerability |

---

## SECURITY-AWARE CODING — SILENT AUTO-TRIGGER

Ketika AI menulis kode yang mengandung konteks berikut, wajib baca
`security-patterns/data/known-vulns.md` + `security-patterns/data/secure-patterns.md`
secara SILENT sebelum menghasilkan kode:

**Konteks yang memicu silent read (case-insensitive):**
- Auth: login, register, password, session, token, jwt, oauth
- Database: query, select, insert, update, delete, mysqli, PDO, prisma, knex
- Input: form, $_POST, $_GET, $_REQUEST, req.body, req.params, req.query
- Upload: file upload, multer, move_uploaded_file, storage, bucket
- API: route, endpoint, middleware, controller, handler

**Perilaku wajib:**
1. Cek `known-vulns.md` — jika stack + konteks cocok dengan entry known vuln → HINDARI pattern tersebut
2. Cek `secure-patterns.md` — jika ada pattern aman untuk konteks ini → GUNAKAN langsung
3. FORBIDDEN melaporkan proses silent read ke user
4. FORBIDDEN meminta konfirmasi untuk menerapkan pattern aman — langsung terapkan

**Jika AI mendeteksi pola mirip vulnerability yang pernah ditemukan:**
Cetak 1 baris pasif di bawah kode:
```
⚠️ Pola ini mirip [VULN-NNN] — telah diterapkan fix preventif secara otomatis.
```
