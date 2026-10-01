# Brainvibes — Issues Tracker

## Open Issues

| ID | Issue | Severity | Status | Created |
|---|---|---|---|---|
| OPEN-002 | Belum ada test suite untuk validasi instructions | Low | Open | 2026-07-17 |

## Resolved Issues (FIFO max 10)

| ID | Issue | Fix | Resolved |
|---|---|---|---|
| RES-030 | Visual Registry 32-Component Expansion & 7-Tier Responsive Breakpoints | Perluasan `design-system.md §7B` dari 7 ke 32 token komponen UI (Page Structure, Data Display, Navigation, Feedback, Interactive, Media, Structural), integrasi STANDARD #8 & #9 di `gemini.md`, penambahan 7-tier responsive strategy mengutamakan laptop 1366×768 (PRIMARY TARGET) dan Android 3M (360/393/412px) di §10.E, serta audit cross-reference bebas konflik. | 2026-10-02 |
| RES-029 | Pragmatic Output & Anti-Bloat Code Enforcement | Implementasi Universal Law anti-verbositas/buzzword (`gemini.md §0 #7`, `§1 #11`), anti-literal-copy teks prompt ke UI (`§VISUAL #24`), panduan arsitektur YAGNI/dev+prod dynamic (`gemini-execution.md §4.O`), dan pembuatan aturan universal `anti-bloat-code.md` di `.agents/rules/` & `config/rules/` untuk PC global. | 2026-10-02 |
| RES-028 | Security Patterns & Rate Limiter Gap Closure | Penambahan 7 pattern baru (SP-024 s/d SP-030) di secure-patterns.md, SP-PHP-005 di xampp-php-patterns.md, upgrade 5-tier rate limiter bertingkat (SP-014, SP-015, SP-PHP-004), sinkronisasi OWASP Top 10:2025 di gemini-execution.md & audit-template.md, serta pembersihan file sampah & reindexing skill | 2026-09-15 |
| RES-027 | Dual-Platform Parity & Windows NTFS Compatibility | Pembuatan `.gitattributes` (LF untuk .sh, CRLF untuk .ps1), penambahan executable bit (100755) pada seluruh script Linux di Git, penanganan aman alias `GEMINI.md` (Windows NTFS case-insensitive crash fix di `sync.ps1`), parity cleanup legacy `mcpServers` di `sync.sh`, dan dynamic PATH resolution (`Get-Command`) di seluruh skrip helper Windows | 2026-09-07 |
| RES-026 | Dual-Platform Linux Support & Shell Automation | Implementasi `sync.sh` (Bash port sync.ps1), porting seluruh skrip otomasi (`cbm-hook.sh`, `ensure-cbm-daemon.sh`, `index-project.sh`), adaptasi path dinamis Linux di `hooks.json`, `mcp_config.json`, `user-prefs.md`, serta verifikasi instalasi paket Arch/AUR `codebase-memory-mcp-bin` | 2026-09-04 |
| RES-025 | Dynamic Local PC Paths & Settings Cleanup | Mengganti hardcoded user path (GBC_PC) dengan dynamic `$env:LOCALAPPDATA` / `ClasNet` pada semua script helper (`sync.ps1`, `ensure-cbm-daemon.ps1`, `cbm-hook.ps1`, `index-project.ps1`) dan MCP config, serta auto-clean blok legacy `mcpServers` di settings.json | 2026-09-02 |
| RES-024 | Overhaul Visual Pipeline & Component Tokens | Pemecahan `taste-skill-bridge/SKILL.md` 824 baris ke router 61 baris, pembuatan `CHEATSHEET.md` & `MODEL_HINTS.md` (anti-slop Gemini Flash), penambahan saklar `redesign` di `gemini.md`, implementasi §4K & §4I di `gemini-execution.md`, integrasi `ui-reasoning.csv` di UUPM, serta penetapan single source of truth komponen di `design-system.md §7B` | 2026-09-02 |
| RES-023 | Otomatisasi Daemon & UI `codebase-memory-mcp` (Port 9749) | Menambahkan Antigravity IDE lifecycle hook (`hooks.json` + `cbm-hook.ps1`), standalone helper (`ensure-cbm-daemon.ps1`), index automation (`index-project.ps1`), dan auto-start step 10 pada `sync.ps1` | 2026-08-16 |
| RES-022 | Integrasi `codebase-memory-mcp` & Lean MCP Stack (6→2) | Mengintegrasikan binary CBM v0.10.5 (AST graph intelligence, 15 tools, 3D UI), mengeliminasi 5 MCP server redundan (filesystem, memory, sequential-thinking, time, fetch), memperbarui seluruh .docs/ dan sync.ps1 true sync | 2026-08-16 |
| RES-021 | Phase 5 Security Gap Fix — Saklar `cek komponen` | Penambahan SP-019 (Error Handling), SP-020 (SSRF), SP-021 (IDOR), SP-022 (Open Redirect), multi-stack rule, npm/composer audit, Compliance Score (OWASP Top 10:2025 100% coverage) | 2026-08-14 |

## Issue Categories

### Architecture
| Count | Status |
|---|---|
| 0 | Open |
| 4 | Resolved |

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
