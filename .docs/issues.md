# Brainvibes — Issues Tracker

## Open Issues

| ID | Issue | Severity | Status | Created |
|---|---|---|---|---|
| OPEN-002 | Belum ada test suite untuk validasi instructions | Low | Open | 2026-07-17 |

## Resolved Issues (FIFO max 10)

| ID | Issue | Fix | Resolved |
|---|---|---|---|
| RES-034 | Upgrade Integrasi UUPM v2.15.0 & tasteskill v2 | Sinkronisasi metadata dataset UUPM v2.15.0 (1,934 Google Fonts, 1,260 stack guidelines across 22 stacks, 79 styles, BM25 routing) serta integrasi aturan empiris tasteskill v2 (studi 247 situs kurasi: larangan hairline dividers/1px outline boxes, larangan resting shadows, larangan asisten palet, larangan mutlak karakter em-dash di UI, pengetatan checklist gambar riil ≥4, dan rasio kontras headline ≥4.3) ke dalam taste-skill-bridge, COPY_RULES, dan gemini.md §VISUAL | 2026-10-16 |
| RES-033 | Anti-Slop Refinement, Infra Badge Ban & Anti-Prompt Echo | Implementasi Pre-Write Slop Filter §4.O.0 (3 filter mental blocking), larangan kapsul status infrastruktur §4.D ("Database Aktif", "● Online"), pencegahan salinan prompt mentah §4.E dengan Echo Test diperketat (2+ kata berurutan), Pattern Blocklist §4.B, TechLeak expanded §4.C, area abu-abu §2.C (komentar/log/commit), dan integrasi lint regex InfraBadge & PatternSlop | 2026-10-16 |
| RES-032 | Penambahan Saklar `update docs` & SSOT Docs Sync | Penambahan saklar mandiri `update docs` (6 alias populer) di AGENTS.global.md, gemini.md §2, dan gemini-templates.md §2L untuk full bootstrap/sync 9 file .docs/ dari scan codebase, sinkronisasi SSOT 20-item SEO checklist ke deployment-checklist/SKILL.md, serta pembaruan rute dan dependensi sistem | 2026-10-15 |
| RES-031 | Antigravity IDE Stateless Optimization & Tiered Visual Gate | Eliminasi double-load AGENTS.md (workspace pointer 3 baris), pembersihan instruksi memory cache/timer stateless di gemini.md & gemini-execution.md, Tiered Visual Gate di §4.K.1, anti-bloat view generator di anti-bloat-code.md §2.B & COPY_RULES.md §4, model hints, dan sekuensial §4.A-§4.O tanpa duplikasi section | 2026-10-13 |
| RES-030 | Visual Registry 32-Component Expansion & 7-Tier Responsive Breakpoints | Perluasan `design-system.md §7B` dari 7 ke 32 token komponen UI (Page Structure, Data Display, Navigation, Feedback, Interactive, Media, Structural), integrasi STANDARD #8 & #9 di `gemini.md`, penambahan 7-tier responsive strategy mengutamakan laptop 1366×768 (PRIMARY TARGET) dan Android 3M (360/393/412px) di §10.E, serta audit cross-reference bebas konflik. | 2026-10-02 |
| RES-029 | Pragmatic Output & Anti-Bloat Code Enforcement | Implementasi Universal Law anti-verbositas/buzzword (`gemini.md §0 #7`, `§1 #11`), anti-literal-copy teks prompt ke UI (`§VISUAL #24`), panduan arsitektur YAGNI/dev+prod dynamic (`gemini-execution.md §4.O`), dan pembuatan aturan universal `anti-bloat-code.md` di `.agents/rules/` & `config/rules/` untuk PC global. | 2026-10-02 |
| RES-028 | Security Patterns & Rate Limiter Gap Closure | Penambahan 7 pattern baru (SP-024 s/d SP-030) di secure-patterns.md, SP-PHP-005 di xampp-php-patterns.md, upgrade 5-tier rate limiter bertingkat (SP-014, SP-015, SP-PHP-004), sinkronisasi OWASP Top 10:2025 di gemini-execution.md & audit-template.md, serta pembersihan file sampah & reindexing skill | 2026-09-15 |
| RES-027 | Dual-Platform Parity & Windows NTFS Compatibility | Pembuatan `.gitattributes` (LF untuk .sh, CRLF untuk .ps1), penambahan executable bit (100755) pada seluruh script Linux di Git, penanganan aman alias `GEMINI.md` (Windows NTFS case-insensitive crash fix di `sync.ps1`), parity cleanup legacy `mcpServers` di `sync.sh`, dan dynamic PATH resolution (`Get-Command`) di seluruh skrip helper Windows | 2026-09-07 |
| RES-026 | Dual-Platform Linux Support & Shell Automation | Implementasi `sync.sh` (Bash port sync.ps1), porting seluruh skrip otomasi (`cbm-hook.sh`, `ensure-cbm-daemon.sh`, `index-project.sh`), adaptasi path dinamis Linux di `hooks.json`, `mcp_config.json`, `user-prefs.md`, serta verifikasi instalasi paket Arch/AUR `codebase-memory-mcp-bin` | 2026-09-04 |
| RES-025 | Dynamic Local PC Paths & Settings Cleanup | Mengganti hardcoded user path (GBC_PC) dengan dynamic `$env:LOCALAPPDATA` / `ClasNet` pada semua script helper (`sync.ps1`, `ensure-cbm-daemon.ps1`, `cbm-hook.ps1`, `index-project.ps1`) dan MCP config, serta auto-clean blok legacy `mcpServers` di settings.json | 2026-09-02 |

## Issue Categories

### Architecture
| Count | Status |
|---|---|
| 0 | Open |
| 5 | Resolved |

### Documentation
| Count | Status |
|---|---|
| 1 | Open |
| 2 | Resolved |

### Integration
| Count | Status |
|---|---|
| 0 | Open |
| 3 | Resolved |

### Performance
| Count | Status |
|---|---|
| 1 | Open |
| 0 | Resolved |

## Severity Legend

| Severity | Meaning | Response Time |
|---|---|---|
| 🔴 Critical | Breaking change, system down | Immediate |
| 🟡 High | Major feature broken | Within 24h |
| 🟢 Medium | Minor issue, workaround exists | Within 1 week |
| 🔵 Low | Enhancement, cosmetic | Next release |

## FIFO Policy

- Max 10 RESOLVED issues retained
- Oldest resolved issues archived jika melebihi 10
- Semua OPEN issues selalu dipertahankan
- Issues baru ditambahkan di atas list
