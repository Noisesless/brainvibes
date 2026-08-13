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
| POST | `/mcp` | web_search | Local | (Deprecated/Removed) |
| POST | `/mcp` | sequential-thinking | Local | Chain-of-thought |
| POST | `/mcp` | time | Local | Get current time |
| POST | `/mcp` | fetch | Local | Fetch URL content |

### Brainvibes Internal Protocol

| Command | Trigger | Output | Status |
|---|---|---|---|
| `awal baru` | Wizard 10-poin | `prd.md`, `todo.md` | ✅ Active |
| Route Path | Action / Purpose | Handler / Dependency | Status |
|---|---|---|---|
| `awal baru` | Wizard 10-poin → prd.md → todo.md | `gemini-templates.md §2A`, `prd-template.md` | ✅ Active |
| `awal lanjut` | Resume project aktif | `app-context.md`, `gemini-templates.md §2B` | ✅ Active |
| `awal konversi` | Stack & legacy migration | `gemini-templates.md §2C`, `prd-template.md` | ✅ Active |
| `baca error` | YOLO debug pipeline | `gemini-templates.md §5`, `/.docs/issues.md` | ✅ Active |
| `tambah fitur` | Incremental feature add | `app-context.md §NEXT`, `prd.md §2` | ✅ Active |
| `lanjut dari sini` | Context recovery | `app-context.md`, `todo.md` | ✅ Active |
| `status proyek` | Quick brief 10-baris | `app-context.md` | ✅ Active |
| `analisa kualitas` | Code quality audit | `app-context.md`, `/.docs/quality_review.md` | ✅ Active |
| `cek komponen` | Component & OWASP compliance check | `security-patterns/data/`, `app-context.md` | ✅ Active |
| `pentest*` | DAST via Strix AI | `security-patterns/data/`, `pentest-strix/` | ✅ Active |
| `auto-sync` | Setiap 5 task selesai | Health check status | ✅ Active |
| `auto-docs` | Setiap 5 task selesai | `/.docs/` files update | ✅ Active |

## Middleware Chain

### Session Init Middleware

| Middleware | Applied To | Purpose |
|---|---|---|
| `read user-prefs.md` | Setiap sesi (silent) | Load user preferences (highest priority) |
| `read app-context.md` | Setiap sesi (silent) | Load AI snapshot (if exists) |
| `fallback prd.md` | Jika app-context missing | Load project requirements (§1-§3) |
| `grep todo.md` | Setiap sesi | Get active tasks without full read |
| `handover drift check` | Setiap sesi | Detect state mismatch |
| `context caching` | Setiap sesi | Check mtime checksum to skip re-reading |

### Execution Middleware

| Middleware | Applied To | Purpose |
|---|---|---|
| `pre-flight check (§3.B)` | Sebelum build | Linter + type-check + incremental verification |
| `security-aware (§3.C)` | Auth/db/input/upload/API | Silent read security & lessons-learned patterns |
| `visual gate (§4.G)` | CSS/style changes | Anti-slop enforcement, ESSENTIAL.md read |
| `ask-before-assume (§3.A)` | Ambiguous instructions | Clarify before acting |
| `technical debate (§0.5)` | User proposal | Challenge with factual data if needed |

### Commit Middleware

| Middleware | Applied To | Purpose |
|---|---|---|
| `pre-flight checklist` | Sebelum commit | Print selfcheck checklist, block if items missing |
| `auto-unstage .env*` | Sebelum commit | Protect credentials |
| `auto-unstage AI files` | Sebelum commit | handover.md, prd.md, app-context.md |
| `conventional commits` | Semua commit | Standardized messages |
| `git sanitation (§4M.G)` | Sebelum commit | Single-command optimized git commit |

## Route Status Legend

| Status | Meaning |
|---|---|
| ✅ Active | Fully implemented and tested |
| 🟡 Beta | Implemented but needs more testing |
| 🔴 Planned | Documented but not yet implemented |
| ⚪ Deprecated | Being phased out |

