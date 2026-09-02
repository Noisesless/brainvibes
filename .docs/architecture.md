# Brainvibes — Architecture

## Makro Arsitektur

```
[User/Developer]
    ↓
[AI Agent — Gemini CLI / Antigravity IDE / Cursor / Copilot]
    ├── Lifecycle Hooks (hooks.json) → cbm-hook.ps1 (PreInvocation auto-start daemon)
    ↓
[Brainvibes System]
    ├── gemini.md          → Core instructions (≤22KB)
    ├── gemini-execution.md → Execution rules (view_file on-demand)
    ├── gemini-templates.md → Macro commands (view_file on-demand)
    ├── AGENTS.md          → Additional behavior rules
    ├── user-prefs.md      → User preferences (highest priority)
    ├── design-system.md   → CSS tokens & design DNA
    ├── prd-template.md    → PRD blueprint
    └── scripts/           → ensure-cbm-daemon.ps1, index-project.ps1, cbm-hook.ps1
    ↓
[MCP Layer — 2 servers]
    ├── codebase-memory    → AST knowledge graph (15 tools, 158 bahasa) + 3D UI (:9749)
    └── context7           → Library documentation RAG
    ↓
[Project Workspace]
    ├── /src/              → Source code
    ├── /.docs/            → Documentation (9 files)
    ├── /.legacy/          → Legacy code (konversi mode)
    ├── app-context.md     → AI snapshot (≤100 baris)
    ├── handover.md        → Human-readable log (100 baris)
    ├── prd.md             → Project requirements
    └── todo.md            → Task checklist
```

## Layer Separation

### 1. Presentation Layer
- UI components, pages, routes
- CSS tokens (`var(--vibe-*)`)
- Icon libraries (phosphor > tabler > radix)
- Font pairing (heading + body)

### 2. Logic Layer
- API endpoints, server actions
- Business logic, controllers
- Middleware chain
- Auth/session management

### 3. Data Layer
- Database schema (MySQL/PostgreSQL)
- ORM models, migrations
- Cache layer (Redis jika perlu)
- File storage (upload dirs)

## Data Flow Pattern

```
User Input → Presentation → Logic → Data → Response
     ↓           ↓            ↓        ↓          ↓
   UI/Events  Components   API      DB/Cache   JSON/HTML
```

## Brainvibes Integration Layers

### Layer 1: Global Config
- `~/.gemini/` → Runtime files untuk Gemini CLI/Antigravity

### Layer 2: Project Context
- `app-context.md` → AI-optimized snapshot (≤100 baris)
- `handover.md` → Human-readable rolling buffer (100 baris)
- `prd.md` → Project requirements & CORE IDENTITY LOCK

### Layer 3: Skills & Knowledge
- `config/skills/` → 12 skills (ui-ux-pro-max dengan Direct-Read & 14 dataset, taste-skill-bridge router v2.0, security-patterns, dll)
- `knowledge/` → 3 knowledge bases (error-solutions, retrospectives, stack-patterns)

## File Loading Protocol

| File | Kapan Dibaca | Metode | Size |
|---|---|---|---|
| `user-prefs.md` | Setiap sesi (silent) | Full read | ~6KB (98 lines) |
| `app-context.md` | Setiap sesi (silent) | Full read | ≤100 baris |
| `prd.md §1-§3` | Jika app-context tidak ada | Range read | Baris 1-100 |
| `todo.md` | Ambil task aktif | Grep `[/]` | Partial |
| `gemini-execution.md` | Saat koding aktif / visual pipeline | View_file (§3.A-C, §4.A-J, §4K, §4I, etc.) | ~52KB (930 lines) |
| `gemini-templates.md` | Saat saklar aktif | View_file (section) | ~26KB (418 lines) |
| `design-system.md` | Saat setup CSS / render komponen | Section specific (§1-§13, §7B) | ~44KB (1160 lines) |
| `taste-skill-bridge/SKILL.md` | Saat redesign / buat halaman | Full read (router) → ESSENTIAL/DETAILED | ~2.5KB (61 lines) |

## Token Efficiency Strategy

1. **Selective Context Loading** — Baca hanya yang dibutuhkan, bukan full file
2. **Range-Limited Reads** — Max 200 baris per view_file call
3. **Snapshot Over Log** — `app-context.md` overwrite (konstan ~3KB), bukan append
4. **On-Demand Loading** — `gemini-execution.md` & `gemini-templates.md` via view_file, bukan auto-load
5. **Symlink Architecture** — Skills & knowledge via symlink, tidak duplikasi file
6. **Graph-First Query** — `codebase-memory-mcp` structural query (~3.4K tokens) menggantikan file-grep (~412K tokens) untuk analisis arsitektur, call chain, dan routes
7. **Lean MCP Stack** — 2 server (dari 6) mengurangi startup overhead dan tool definition tokens
8. **Daemon Persistence & Hook Auto-Start** — Background daemon CBM pada port 9749 dijaga selalu warm via `PreInvocation` hook (`cbm-hook.ps1`), mengeliminasi startup cold-boot per perintah CLI/tool.
