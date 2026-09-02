<!-- WORKSPACE COPY — jika file ini sudah di-load sebagai global rule, AI gunakan cached copy -->
# AGENTS.md — Global AI Behavior Rules (Antigravity IDE)
# Path: %USERPROFILE%\.gemini\AGENTS.md
# Berlaku untuk: Gemini CLI | Antigravity IDE | Cursor | Copilot (semua sesi, semua proyek)
# Rules ini MENAMBAH, bukan menggantikan, gemini.md

---

## SESSION INIT PROTOCOL (Tambahan gemini.md §SESSION PROTOCOL)
AI REQUIRED mematuhi urutan Prioritas Baca Awal (Step -1 s/d Step 2) di `gemini.md §SESSION PROTOCOL`.
*AI FORBIDDEN membaca prd.md penuh, handover.md penuh, atau design-system.md di session init.*

---

## §LOAD PROTOCOL (ON-DEMAND FILES LOADING)
AI REQUIRED mematuhi load protocol berikut untuk menghemat token dan context window:
- **`gemini.md` (Core):** Dibaca sistem di awal sesi. Jangan di-load ulang secara penuh.
- **`gemini-execution.md`:** Wajib di-load via `view_file` (ambil section spesifik) saat AI mulai menulis kode, konfigurasi backend, setup database, atau memproses upload file.
- **`gemini-templates.md`:** Wajib di-load via `view_file` hanya saat saklar makro (`awal baru`, `awal konversi`, `baca error`) dipicu, saat membuat `todo.md`, update `handover.md`, atau melakukan git commit.
- **Auto-Ignore Legacy:** → Lihat `gemini-execution.md §3.A` (Auto Workspace Verification).

---

## BROWSER TOOL GATE & RULE PRIORITY (Cross-Reference)
- **Browser Tool Gate:** Spesifikasi lengkap Browser Tool Gate dan Proteksi Absolut Scratchpad DOM diatur sepenuhnya di [gemini-execution.md §4.H](file:///c:/xampp/htdocs/brainvibes/gemini-execution.md) (anchor:4H). AI wajib menulis log `[Browser Gate] Alasan: ...` sebelum memanggil `browser_subagent`.
- **Rule Priority System:** Aturan kepatuhan (Critical, Important, Nice-to-have) diatur sepenuhnya di [gemini-execution.md §4M.H](file:///c:/xampp/htdocs/brainvibes/gemini-execution.md) (anchor:4M.H).

---

## SKILLS REGISTRY (Auto-Discovery)
| Skill Name | Path | Auto-Trigger Keywords | Read Protocol |
|---|---|---|---|
| `ui-ux-pro-max` | `config/skills/ui-ux-pro-max/` | awal baru, redesign, buat halaman | Baca ESSENTIAL.md (50 baris) → DETAILED.md jika complex |
| `taste-skill-bridge` | `config/skills/taste-skill-bridge/` | redesign, buat halaman, UI baru, landing page, ubah bentuk, ubah tampilan, ubah layout, perbaiki halaman, redesign visual, ubah visual | **WAJIB baca ESSENTIAL.md PENUH** → DETAILED.md jika complex → REFERENCE.md untuk pre-flight |
| `lessons-learned` | `config/skills/lessons-learned/` | baca error, pernah coba, jangan ulangi | Baca SKILL.md deskripsi → data/anti-patterns.md jika trigger |
| `code-snippets` | `config/skills/code-snippets/` | buat form, buat navbar, buat modal, buat toast | Baca SKILL.md deskripsi → data/ jika perlu snippet |
| `database-patterns` | `config/skills/database-patterns/` | desain database, migration, seeder, query | Baca SKILL.md deskripsi → data/ jika perlu pattern |
| `git-workflow` | `config/skills/git-workflow/` | commit, push, branch, merge, PR | Baca SKILL.md deskripsi → data/ jika perlu workflow |
| `accessibility-audit` | `config/skills/accessibility-audit/` | audit a11y, screen reader, WCAG, cek a11y | Baca SKILL.md deskripsi → checklist jika audit |
| `performance-audit` | `config/skills/performance-audit/` | audit performa, lighthouse, LCP, web vitals | Baca SKILL.md deskripsi → checklist jika audit |
| `deployment-checklist` | `config/skills/deployment-checklist/` | deploy, hosting, production, go live | Baca SKILL.md deskripsi → checklist jika deploy |
| `security-patterns` | `config/skills/security-patterns/` | cek komponen, cek kelengkapan, verifikasi kode, cek regulasi, perbaiki keamanan, fix vulnerability | Baca SKILL.md deskripsi → data/known-vulns.md + data/secure-patterns.md |
| `pentest-strix` | `config/skills/pentest-strix/` | **pentest, pentest cepat, pentest mendalam, pentest api, pentest auth, dast, dynamic scan, strix scan** | Baca SKILL.md deskripsi → docker jika pentest |
| `quick-scaffold` | `config/skills/quick-scaffold/` | buat komponen, buat model, buat controller, buat form, scaffold, generate file | Baca SKILL.md deskripsi → data/ jika perlu scaffold |


*Mekanisme Smart Skill Integration (SSI) diatur sepenuhnya di [gemini-execution.md §4N](file:///c:/xampp/htdocs/brainvibes/gemini-execution.md) (anchor:4N).*

---

## SECURITY-AWARE CODING & WEB SEARCH (Cross-Reference)
- **Security-Aware Coding:** Ketika menulis kode auth/db/input/upload/API, AI wajib secara SILENT membaca `security-patterns` data. Detail di [gemini.md §1 STANDARD #5](file:///c:/xampp/htdocs/brainvibes/gemini.md) dan [gemini-execution.md §3.C](file:///c:/xampp/htdocs/brainvibes/gemini-execution.md) (anchor:3C).
- **Web Search Protocol:** Protokol pencarian informasi web diatur di [gemini.md §1 HARD BLOCK #9](file:///c:/xampp/htdocs/brainvibes/gemini.md).
