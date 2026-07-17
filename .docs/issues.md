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
| RES-001 | `gemini-execution.md` tidak ada di `.gemini` | Copy dari brainvibes | 2026-07-17 |
| RES-002 | `gemini-templates.md` tidak ada di `.gemini` | Copy dari brainvibes | 2026-07-17 |
| RES-003 | `yasei-cli.ps1` tidak ada di `.gemini` | Copy dari brainvibes | 2026-07-17 |
| RES-004 | Opencode tidak punya AGENTS.md dari brainvibes | Copy gemini.md → AGENTS.md | 2026-07-17 |
| RES-005 | Skills tidak ter-register di opencode.jsonc | Add 12 skills + MCP config | 2026-07-17 |
| RES-006 | Tidak ada web_search MCP server | Add web_search ke mcp_config.json | 2026-07-17 |
| RES-007 | brainvibes tidak punya `.docs/` folder | Create 7 documentation files | 2026-07-17 |
| RES-008 | README.md belum update v4.1.0 | Update version, features, changelog | 2026-07-17 |

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
