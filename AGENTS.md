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

## TASTE-SKILL-BRIDGE AUTO-TRIGGER

Ketika kata kunci berikut terdeteksi dalam request user, AI REQUIRED
membaca `%USERPROFILE%\.gemini\config\skills\taste-skill-bridge\SKILL.md`
dan menjalankan STEP 0 (Brief Inference) + STEP 1 (Three Dials):

**Trigger keywords (case-insensitive, Bahasa Indonesia & English):**
- buat halaman / create page / build page
- redesign / ubah desain / tampilan baru / new design
- landing page / hero section / home page
- portfolio / profile page
- UI baru / new UI / update tampilan
- halaman login / auth page / register page
- frontend / front-end / tampilan

**Output WAJIB (1 baris) sebelum kode apapun:**
```
[Design Read] Reading this as: [X] untuk [Y], vibe [Z], dials: V=[n] M=[n] D=[n]
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

Referensi lengkap: `gemini.md §4K F` + `taste-skill-bridge SKILL.md §4`

---

## SKILLS REGISTRY (Auto-Discovery)

| Skill Name | Path | Auto-Trigger Keywords |
|---|---|---|
| `ui-ux-pro-max` | `config\skills\ui-ux-pro-max\` | awal baru, redesign, buat halaman |
| `taste-skill-bridge` | `config\skills\taste-skill-bridge\` | redesign, buat halaman, UI baru, landing page |
| `lessons-learned` | `config\skills\lessons-learned\` | baca error, pernah coba, jangan ulangi |
| `code-snippets` | `config\skills\code-snippets\` | buat form, buat navbar, buat modal, buat toast |
| `database-patterns` | `config\skills\database-patterns\` | desain database, migration, seeder, query |
| `git-workflow` | `config\skills\git-workflow\` | commit, push, branch, merge, PR |
| `accessibility-audit` | `config\skills\accessibility-audit\` | audit a11y, screen reader, WCAG, cek a11y |
| `performance-audit` | `config\skills\performance-audit\` | audit performa, lighthouse, LCP, web vitals |
| `deployment-checklist` | `config\skills\deployment-checklist\` | deploy, hosting, production, go live |
| `security-patterns` | `config\skills\security-patterns\` | analisa keamanan, scan keamanan, cek vulnerability, security audit, perbaiki keamanan, fix vulnerability |

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
