# Brainvibes — Routes Map

## Frontend Routes (Pages)

Brainvibes adalah sistem konfigurasi, bukan aplikasi web, jadi tidak memiliki routes frontend tradisional. Namun, brainvibes mendefinisikan routes untuk proyek yang dibuat dengannya.

## API Routes (Endpoints)

### MCP Server Endpoints

| Method | Route Path | Handler | Auth | Purpose |
|---|---|---|---|---|
| POST | `/mcp` | context7 | API Key | Query library docs |
| POST | `/mcp` | filesystem | Local | File operations |
| POST | `/mcp` | memory | Local | Persistent memory |
| POST | `/mcp` | web_search | Local | Internet search |
| POST | `/mcp` | sequential-thinking | Local | Chain-of-thought |
| POST | `/mcp` | time | Local | Get current time |
| POST | `/mcp` | fetch | Local | Fetch URL content |

### Brainvibes Internal Protocol

| Command | Trigger | Output | Status |
|---|---|---|---|
| `awal baru` | Wizard 10-poin | `prd.md`, `todo.md` | ✅ Active |
| `awal lanjut` | Resume project | `app-context.md` | ✅ Active |
| `awal konversi` | Stack migration | `prd.md`, `/.legacy/` | ✅ Active |
| `baca error` | YOLO debug | `/.docs/issues.md` | ✅ Active |
| `tambah fitur` | Incremental add | `prd.md`, `todo.md` | ✅ Active |
| `lanjut dari sini` | Context recovery | `app-context.md` | ✅ Active |
| `status proyek` | Quick brief | Console (10 baris) | ✅ Active |
| `analisa kualitas` | Code audit | `/.docs/quality_review.md` | ✅ Active |
| `analisa keamanan` | Security scan | `/.docs/security-audit.md` | ✅ Active |
| `pentest` | DAST validation | `/.docs/security-audit.md` | ✅ Active |

## Middleware Chain

### Session Init Middleware

| Middleware | Applied To | Purpose |
|---|---|---|
| `read user-prefs.md` | Setiap sesi | Load user preferences (highest priority) |
| `read app-context.md` | Setiap sesi | Load AI snapshot (if exists) |
| `fallback prd.md` | Jika app-context missing | Load project requirements |
| `grep todo.md` | Setiap sesi | Get active tasks |
| `handover drift check` | Setiap sesi | Detect state mismatch |

### Execution Middleware

| Middleware | Applied To | Purpose |
|---|---|---|
| `pre-flight check` | Sebelum build | Linter + type-check |
| `security-aware trigger` | Auth/db/input/upload | Silent read security patterns |
| `visual gate` | CSS/style changes | Anti-slop enforcement |
| `ask-before-assume` | Ambiguous instructions | Clarify before acting |
| `technical debate` | User proposal | Challenge with data if needed |

### Commit Middleware

| Middleware | Applied To | Purpose |
|---|---|---|
| `auto-unstage .env*` | Sebelum commit | Protect credentials |
| `auto-unstage AI files` | Sebelum commit | handover.md, prd.md, app-context.md |
| `conventional commits` | Semua commit | Standardized messages |
| `git sanitation` | Sebelum commit | Clean metadata |

## Route Status Legend

| Status | Meaning |
|---|---|
| ✅ Active | Fully implemented and tested |
| 🟡 Beta | Implemented but needs more testing |
| 🔴 Planned | Documented but not yet implemented |
| ⚪ Deprecated | Being phased out |
