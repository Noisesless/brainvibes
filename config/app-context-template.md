<!--
  \u2554\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2557
  \u2551  APP-CONTEXT MASTER TEMPLATE \u2014 Antigravity IDE Global Config        \u2551
  \u2551  Path: C:\Users\GBC_PC\.gemini\config\app-context-template.md      \u2551
  \u2551  Format: MACHINE-OPTIMIZED v2.0 \u2014 sesuai gemini.md \u00a7APP-CONTEXT      \u2551
  \u2551  Tujuan: Template acuan AI saat generate app-context.md per proyek  \u2551
  \u2551  Target ukuran output: \u2264100 baris, \u22645 KB per proyek                 \u2551
  \u2551  Version: 2.1 (2026-07-16 \u2014 migrated to machine-optimized format)   \u2551
  \u255a\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u255d

  CARA GENERATE app-context.md:
  1. Baca prd.md \u00a71\u2013\u00a73 + todo.md + .env untuk mendapatkan data aktual proyek
  2. Isi semua placeholder [SEPERTI_INI] dengan nilai aktual (bukan template kosong)
  3. Simpan ke [PROJECT_ROOT]/app-context.md (di root proyek, BUKAN di /.docs/)
  4. Tambahkan app-context.md ke .gitignore proyek
  5. FORBIDDEN append \u2014 ini snapshot, wajib OVERWRITE penuh setiap update

  ATURAN PENULISAN (ZERO DEVIATION):
  - Max 100 baris total output
  - Max 1 baris per entry \u2014 FORBIDDEN multi-baris
  - FORBIDDEN tambah header baru di luar template \u2014 gunakan [LIMITS]
  - REQUIRED overwrite penuh setiap 5-6 task selesai (bukan append)
  - REQUIRED masuk .gitignore proyek

  TRIGGER GENERATE/UPDATE:
  - Akhir Fase 1     : AI generate pertama kali
  - Setiap 5-6 task  : AI overwrite bersamaan update handover.md
  - `awal lanjut`    : AI baca ini PERTAMA sebelum file lain
  - `lanjut dari sini`: AI baca ini untuk context recovery
-->

<!-- app-context.md v2.0 \u2014 MACHINE-OPTIMIZED CONTEXT SNAPSHOT -->
<!-- Last: [YYYY-MM-DDTHH:MM:SS+07:00] | Phase: [X]/[total] | Build: [OK|ERR] -->

## [APP]
name=[Nama Aplikasi] slug=[nama-slug] type=[web-app|saas|portal|e-commerce|company-profile]
stack=[framework]|[db]|[css] pkg=[npm|composer] port=[port] url=[http://localhost/slug]

## [PALETTE] IMMUTABLE
bg=[#hex] surface=[#hex] text=[#hex] accent1=[#hex] accent2=[#hex]
font_head=[Font Heading] font_body=[Font Body] radius=[Npx] nav=[model] theme=[mode]

## [STATE]
phase=[X] done=[N]/[total] last=[deskripsi task terakhir yang selesai]
build=[OK|ERROR:pesan singkat] issues=[0|N:deskripsi singkat]

## [VISUAL_GATE]
icon_lib=[phosphor|heroicons|lucide|tabler]
\ud83d\udd34 SVG mentah\u2192icon_lib | border logo\u2192as-is | hardcode hex\u2192var(--vibe-*)
\ud83d\udd34 font tunggal\u21922 font | bg:white hardcode\u2192var(--vibe-background)
\ud83d\udd34 spacing acak\u21928pt grid | campur icon lib\u2192ONE family
\ud83d\udd34 [Design Read]+Three Dials sebelum halaman baru
\ud83d\udd34 kontras text vs bg \u2265 4.5:1 | baca taste-skill sebelum visual
\ud83d\udd34 scratchpad_dom=[FORBIDDEN|ALLOWED] | browser_gate=[STRICT|RELAXED]

## [FLOWS]
<!-- Per-feature data flow \u2014 1 baris per fitur utama -->
[Login]=Form\u2192POST /auth/login\u2192verify\u2192JWT\u2192redirect /dashboard
[Register]=Form\u2192POST /auth/register\u2192validate\u2192hash\u2192insert\u2192redirect

## [PAGES] BUILT
<!-- Format: [path]=[NamaHalaman]=[public|member|admin]=[STABLE|WIP] -->
[/]=[Landing]=public=STABLE

## [PAGES] PENDING
<!-- Format: [path]=[NamaHalaman]=[akses]=[Fase-X] -->
[/dashboard]=[Dashboard]=member=Fase-4

## [SCHEMA]
<!-- Format: [table](col1,col2,col3,...) \u2014 1 baris per tabel -->
[users](id,name,email,password,role,created_at)

## [ADR]
<!-- Architecture Decision Record \u2014 1 baris per keputusan -->
[ADR-001] [keputusan diambil]: [alasan singkat 1 kalimat]

## [CREDS] DEV
<!-- Kredensial dev saja \u2014 JANGAN isi production creds di sini -->
admin=[email@dev.local]=[password_dev]

## [NEXT]
<!-- 3 task berikutnya yang akan dikerjakan -->
[ ] [task berikutnya 1]
[ ] [task berikutnya 2]
[ ] [task berikutnya 3]

## [LIMITS]
<!-- Known limitations dan workaround aktif saat ini -->
[LIM-001] [masalah aktif]: [workaround yang sedang dipakai]
