# Brainvibes — Issues Tracker

## Open Issues

| ID | Issue | Severity | Status | Created |
|---|---|---|---|---|
| OPEN-002 | Belum ada test suite untuk validasi instructions | Low | Open | 2026-07-17 |

## Resolved Issues (FIFO max 10)

| ID | Issue | Fix | Resolved |
|---|---|---|---|
| RES-027 | Dual-Platform Parity & Windows NTFS Compatibility | Pembuatan `.gitattributes` (LF untuk .sh, CRLF untuk .ps1), penambahan executable bit (100755) pada seluruh script Linux di Git, penanganan aman alias `GEMINI.md` (Windows NTFS case-insensitive crash fix di `sync.ps1`), parity cleanup legacy `mcpServers` di `sync.sh`, dan dynamic PATH resolution (`Get-Command`) di seluruh skrip helper Windows | 2026-09-07 |
| RES-026 | Dual-Platform Linux Support & Shell Automation | Implementasi `sync.sh` (Bash port sync.ps1), porting seluruh skrip otomasi (`cbm-hook.sh`, `ensure-cbm-daemon.sh`, `index-project.sh`), adaptasi path dinamis Linux di `hooks.json`, `mcp_config.json`, `user-prefs.md`, serta verifikasi instalasi paket Arch/AUR `codebase-memory-mcp-bin` | 2026-09-04 |
| RES-025 | Dynamic Local PC Paths & Settings Cleanup | Mengganti hardcoded user path (GBC_PC) dengan dynamic `$env:LOCALAPPDATA` / `ClasNet` pada semua script helper (`sync.ps1`, `ensure-cbm-daemon.ps1`, `cbm-hook.ps1`, `index-project.ps1`) dan MCP config, serta auto-clean blok legacy `mcpServers` di settings.json | 2026-09-02 |
| RES-024 | Overhaul Visual Pipeline & Component Tokens | Pemecahan `taste-skill-bridge/SKILL.md` 824 baris ke router 61 baris, pembuatan `CHEATSHEET.md` & `MODEL_HINTS.md` (anti-slop Gemini Flash), penambahan saklar `redesign` di `gemini.md`, implementasi §4K & §4I di `gemini-execution.md`, integrasi `ui-reasoning.csv` di UUPM, serta penetapan single source of truth komponen di `design-system.md §7B` | 2026-09-02 |
| RES-023 | Otomatisasi Daemon & UI `codebase-memory-mcp` (Port 9749) | Menambahkan Antigravity IDE lifecycle hook (`hooks.json` + `cbm-hook.ps1`), standalone helper (`ensure-cbm-daemon.ps1`), index automation (`index-project.ps1`), dan auto-start step 10 pada `sync.ps1` | 2026-08-16 |
| RES-022 | Integrasi `codebase-memory-mcp` & Lean MCP Stack (6→2) | Mengintegrasikan binary CBM v0.10.5 (AST graph intelligence, 15 tools, 3D UI), mengeliminasi 5 MCP server redundan (filesystem, memory, sequential-thinking, time, fetch), memperbarui seluruh .docs/ dan sync.ps1 true sync | 2026-08-16 |
| RES-021 | Phase 5 Security Gap Fix — Saklar `cek komponen` | Penambahan SP-019 (Error Handling), SP-020 (SSRF), SP-021 (IDOR), SP-022 (Open Redirect), multi-stack rule, npm/composer audit, Compliance Score (OWASP Top 10:2025 100% coverage) | 2026-08-14 |
| RES-020 | Pembatalan integrasi OpenCode & Cross-Memory | Menghapus opencode.jsonc, session-hook.ps1, cross-memory-implementation-plan.md, §A8/§A8B di gemini-execution.md, section [CROSS_MEMORY] di user-prefs.md, serta membersihkan mcp_config.json & sync.ps1 | 2026-08-02 |
| RES-019 | Persona prompt noise & OpenCode sync bloat | Deleted persona sections (A9/LLM-Local) from gemini.md & user-prefs.md, cleaned up AGENTS.md duplication, and updated sync.ps1 to target .gemini exclusively | 2026-07-24 |
| RES-018 | Dispatch table & Session Init duplication & ambiguous references | Cleaned up duplicate Session Init block, renamed Dispatch Detail column to Templates Section, and merged duplicate §4H POINTER table rows | 2026-07-24 |
| RES-017 | `awal konversi` missing `prd-template.md` dependency | Added `prd-template.md` to WAJIB Load column for `awal konversi` in gemini.md & README.md | 2026-07-24 |

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
