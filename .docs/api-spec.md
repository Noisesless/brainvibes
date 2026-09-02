# Brainvibes — API Specification

## MCP Server Endpoints

### codebase-memory (Code Intelligence Graph)

**Binary:** `%USERPROFILE%\AppData\Local\Programs\codebase-memory-mcp\codebase-memory-mcp.exe`
**Version:** 0.10.5
**Type:** Local native binary (Pure C, zero runtime dependencies)
**Cache:** `~/.cache/codebase-memory-mcp/`
**Graph UI:** `http://localhost:9749` (built-in 3D visualization)

#### MCP Tools (15 tools)

| Tool | Purpose |
|---|---|
| `index_repository` | Index/re-index codebase into knowledge graph |
| `search_graph` | Structural search: regex name, label filter, degree, file scope |
| `search_code` | Graph-augmented grep over indexed files |
| `semantic_query` | Vector search (bundled Nomic embeddings, no API key) |
| `get_architecture` | Full architecture: languages, packages, entry points, routes, hotspots, layers, clusters |
| `trace_path` | Call chain tracing: caller/callee traversal (BFS, configurable depth) |
| `detect_changes` | Git diff impact mapping: uncommitted changes → affected symbols + risk |
| `manage_adr` | Architecture Decision Records: create, list, update |
| `get_dead_code` | Dead code detection: functions with zero callers |
| `cypher_query` | Cypher-like graph query: `MATCH (f:Function)-[:CALLS]->(g)` |
| `get_routes` | HTTP route extraction: REST endpoints as graph entities |
| `get_cross_service` | Cross-service linking: HTTP, gRPC, GraphQL, tRPC, Socket.IO |
| `get_clusters` | Louvain community detection: functional module clustering |
| `check_coverage` | Index coverage check per file/directory |
| `get_statistics` | Graph statistics: node/edge counts, language distribution |

#### Key Edge Types

| Edge | Meaning |
|---|---|
| `CALLS` | Function invocation at source site |
| `IMPORTS` | Module/package import |
| `DEFINES` | Symbol definition in file |
| `IMPLEMENTS` / `INHERITS` | Interface/class hierarchy |
| `HTTP_CALLS` / `ASYNC_CALLS` | Cross-service communication |
| `DATA_FLOWS` | Arg-to-param mapping + field access chains |
| `SIMILAR_TO` | MinHash near-clone detection (Jaccard scored) |

#### Configuration & Daemon Controls

| Setting / Command | Value / Purpose | Detail |
|---|---|---|
| `auto_index` | `true` | `codebase-memory-mcp config set auto_index true` |
| `auto_watch` | `true` | Background watcher for git-based change detection |
| `ui_enabled` | `true` | Enable built-in 3D visualization on port 9749 |
| `ui_port` | `9749` | Web UI port (`http://localhost:9749`) |
| `daemon start` | Background service | `codebase-memory-mcp daemon start` (keeps CBM daemon & UI warm) |
| `daemon status` | Health check | `codebase-memory-mcp daemon status` |
| `daemon stop` | Retire service | `codebase-memory-mcp daemon stop` |


---

### context7 (Library Documentation RAG)

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

---

## Internal API (Brainvibes Protocol)

### Lifecycle Hooks Contract (`hooks.json`)

| Hook Event | Matcher | Handler Script | Purpose |
|---|---|---|---|
| `PreInvocation` | (global) | `cbm-hook.ps1` | Fast socket check 127.0.0.1:9749 (<100ms) & start CBM daemon in hidden window if inactive |

### Automation Scripts

| Script | Purpose | Usage |
|---|---|---|
| `ensure-cbm-daemon.ps1` | Standalone socket checker & daemon launcher | `.\scripts\ensure-cbm-daemon.ps1` |
| `index-project.ps1` | Auto-daemon check + index repository AST | `.\scripts\index-project.ps1 -RepoPath "." -Mode full` |
| `cbm-hook.ps1` | Antigravity IDE JSON-compliant hook | Called automatically by IDE via `hooks.json` |
| `sync.ps1` | Global sync master → `~/.gemini/` + true sync MCP | `.\sync.ps1` |

### Session Init Flow
```
1. PreInvocation hook verifies CBM daemon on port 9749
2. Read user-prefs.md (silent)
3. Read app-context.md (silent, jika ada)
4. Fallback ke prd.md §1-§3 (jika app-context tidak ada)
5. Grep todo.md untuk task aktif
6. Self-healing handover check
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
| `cek komponen` | Component verification & compliance | `/.docs/security-audit.md` |
| `pentest` | DAST validation | `/.docs/security-audit.md` |
| `redesign` | Visual overhaul & layout intelligence | Source code, `app-context.md` |

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
Decision making (based on context + codebase-memory graph)
    ↓
Action execution (coding, fixing, deploying)
    ↓
State update (overwrite app-context.md, append handover.md)
```
