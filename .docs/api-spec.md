# Brainvibes — API Specification

## MCP Server Endpoints

### context7
| Method | Route | Purpose | Auth |
|---|---|---|---|
| POST | `/mcp` | Query library documentation | API Key (X-Context7-Client-IDE) |

**Request:**
```json
{
  "method": "tools/call",
  "params": {
    "name": "resolve_library_id",
    "arguments": { "libraryName": "next.js" }
  }
}
```

**Response:**
```json
{
  "libraryId": "next.js",
  "frames": [
    { "name": "get_started", "content": "..." }
  ]
}
```

### filesystem
| Method | Route | Purpose | Auth |
|---|---|---|---|
| POST | `/mcp` | File operations (read, write, search) | Local process |

**Allowed Directories:**
- `C:\XAMPP\htdocs`
- `C:\Users\GBC_PC\.gemini`

### memory
| Method | Route | Purpose | Auth |
|---|---|---|---|
| POST | `/mcp` | Persistent memory operations | Local process |

**Memory File:** `C:\Users\GBC_PC\.gemini\brainvibes-memory.json`

### web_search
| Method | Route | Purpose | Auth |
|---|---|---|---|
| POST | `/mcp` | Internet search (real-time info) | Local process |

**Trigger:** `web_search_enabled = true` di `user-prefs.md`

### sequential-thinking
| Method | Route | Purpose | Auth |
|---|---|---|---|
| POST | `/mcp` | Chain-of-thought reasoning | Local process |

### time
| Method | Route | Purpose | Auth |
|---|---|---|---|
| POST | `/mcp` | Get current time (Asia/Jakarta) | Local process |

### fetch
| Method | Route | Purpose | Auth |
|---|---|---|---|
| POST | `/mcp` | Fetch URL content | Local process |

## Internal API (Brainvibes Protocol)

### Session Init Flow
```
1. Read user-prefs.md (silent)
2. Read app-context.md (silent, jika ada)
3. Fallback ke prd.md §1-§3 (jika app-context tidak ada)
4. Grep todo.md untuk task aktif
5. Self-healing handover check
```

### Macro Command Triggers

| Command | Trigger | Output File |
|---|---|---|
| `awal baru` | Wizard 10-poin | `prd.md`, `todo.md` |
| `awal lanjut` | Resume project | `app-context.md` |
| `awal konversi` | Stack migration | `prd.md`, `todo.md`, `/.legacy/` |
| `baca error` | YOLO debug | `/.docs/issues.md` |
| `tambah fitur` | Incremental add | `prd.md`, `todo.md`, `app-context.md` |
| `lanjut dari sini` | Context recovery | `app-context.md`, `handover.md` |
| `status proyek` | Quick brief | Console output (10 baris) |
| `analisa kualitas` | Code audit | `/.docs/quality_review.md` |
| `analisa keamanan` | Security scan | `/.docs/security-audit.md` |
| `pentest` | DAST validation | `/.docs/security-audit.md` |

## Data Flow: AI → Project

```
AI Agent (read instructions)
    ↓
Brainvibes config (gemini.md, user-prefs.md, dll)
    ↓
Project files (prd.md, todo.md, app-context.md)
    ↓
Source code (src/, public/, dll)
    ↓
Output (build, deploy, commit)
```

## Data Flow: Project → Brainvibes

```
Project state (app-context.md, handover.md)
    ↓
AI Agent (read snapshot)
    ↓
Decision making (based on context)
    ↓
Action execution (coding, fixing, deploying)
    ↓
State update (overwrite app-context.md, append handover.md)
```
