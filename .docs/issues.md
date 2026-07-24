# Brainvibes — Issues Tracker

## Open Issues

| ID | Issue | Severity | Status | Created |
|---|---|---|---|---|
| OPEN-001 | `taste-skill-bridge/SKILL.md` 36.5KB (bisa di-split) | Low | Open | 2026-07-17 |
| OPEN-002 | Belum ada test suite untuk validasi instructions | Low | Open | 2026-07-17 |
| OPEN-003 | `README.md` perlu update untuk `.docs/` folder baru | Low | Open | 2026-07-17 |

## Resolved Issues (FIFO max 10)

| ID | Issue | Fix | Resolved |
|---|---|---|---|
| RES-019 | Persona prompt noise & OpenCode sync bloat | Deleted persona sections (A9/LLM-Local) from gemini.md & user-prefs.md, cleaned up AGENTS.md duplication, and updated sync.ps1 to target .gemini exclusively | 2026-07-24 |
| RES-018 | Dispatch table & Session Init duplication & ambiguous references | Cleaned up duplicate Session Init block, renamed Dispatch Detail column to Templates Section, and merged duplicate §4H POINTER table rows | 2026-07-24 |
| RES-017 | `awal konversi` missing `prd-template.md` dependency | Added `prd-template.md` to WAJIB Load column for `awal konversi` in gemini.md & README.md | 2026-07-24 |
| RES-016 | Sub-heading collision di `gemini-execution.md` | Added parent section prefixes (§3.A-C, §4.A-J, §4K.A, §4L.A-B, §4M.A-I, §4N.A-I) to eliminate subheading ambiguity | 2026-07-24 |
| RES-015 | Stale line references (`#L` links) di `AGENTS.md` | Corrected line references in AGENTS.md for §4H (#L261), §4M.H (#L608), §4N (#L642), and §3C (#L92) | 2026-07-24 |
| RES-014 | todo.md v4.1.0 roadmap checklist finalization | Menyelesaikan seluruh 18 sub-tasks peningkatan produktivitas framework | 2026-07-18 |
| RES-013 | Productivity enhancements development | Mengintegrasikan Context Caching, Token Budget Tracker, Pre-Flight Checklist, dan Auto-Sync/Docs protocols | 2026-07-18 |
| RES-012 | Broken MCP web_search EOF loop | Penghapusan server MCP web_search yang tidak valid karena package npm 404 | 2026-07-18 |
| RES-011 | MCP config & skills sync missing in sync.ps1 | Penyalinan `opencode.jsonc` dan folder `config/skills` ke OpenCode | 2026-07-18 |
| RES-010 | prd-template.md monolith & duplicate rules | Perampingan prd-template, restrukturisasi Bab 4-11, pembersihan aturan duplikat visual rules & session protocol di `AGENTS.md`, `ESSENTIAL.md`, `SKILL.md` | 2026-07-18 |
| RES-009 | Section numbering collision & broken references | Koreksi section §4 alfabetis dan rujukan pointers di `gemini.md`, `design-system.md` | 2026-07-18 |

## Issue Categories

### Architecture
| Count | Status |
|---|---|
| 0 | Open |
| 3 | Resolved |

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
