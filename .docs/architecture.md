# Brainvibes — Architecture

## Makro Arsitektur

```
[User/Developer]
    ↓
[AI Agent — Gemini CLI / Antigravity IDE / OpenCode / Copilot]
    ↓
[Brainvibes System]
    ├── gemini.md          → Core instructions (≤22KB)
    ├── gemini-execution.md → Execution rules (view_file on-demand)
    ├── gemini-templates.md → Macro commands (view_file on-demand)
    ├── AGENTS.md          → Additional behavior rules
    ├── user-prefs.md      → User preferences (highest priority)
    ├── design-system.md   → CSS tokens & design DNA
    └── prd-template.md    → PRD blueprint
    ↓
[Project Workspace]
    ├── /src/              → Source code
    ├── /.docs/            → Documentation (7 files)
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
- `~/.config/opencode/AGENTS.md` → Load dari brainvibes gemini.md
- `~/.config/opencode/opencode.jsonc` → Skills + MCP registration
- `~/.gemini/` → Runtime files untuk Gemini CLI/Antigravity

### Layer 2: Project Context
- `app-context.md` → AI-optimized snapshot (≤100 baris)
- `handover.md` → Human-readable rolling buffer (100 baris)
- `prd.md` → Project requirements & CORE IDENTITY LOCK

### Layer 3: Skills & Knowledge
- `config/skills/` → 12 skills (ui-ux-pro-max, security-patterns, dll)
- `knowledge/` → 3 knowledge bases (error-solutions, retrospectives, stack-patterns)
- Symlink ke opencode via `brainvibes/skills/` dan `brainvibes/knowledge/`

## File Loading Protocol

| File | Kapan Dibaca | Metode | Max Size |
|---|---|---|---|
| `user-prefs.md` | Setiap sesi (silent) | Full read | ~5KB |
| `app-context.md` | Setiap sesi (silent) | Full read | ≤100 baris |
| `prd.md §1-§3` | Jika app-context tidak ada | Range read | Baris 1-100 |
| `todo.md` | Ambil task aktif | Grep `[/]` | Partial |
| `gemini-execution.md` | Saat koding aktif | View_file (section) | ~23KB |
| `gemini-templates.md` | Saat saklar aktif | View_file (section) | ~18KB |
| `design-system.md` | Saat setup CSS | Section specific | ~36KB |

## Token Efficiency Strategy

1. **Selective Context Loading** — Baca hanya yang dibutuhkan, bukan full file
2. **Range-Limited Reads** — Max 200 baris per view_file call
3. **Snapshot Over Log** — `app-context.md` overwrite (konstan ~3KB), bukan append
4. **On-Demand Loading** — `gemini-execution.md` & `gemini-templates.md` via view_file, bukan auto-load
5. **Symlink Architecture** — Skills & knowledge via symlink, tidak duplikasi file
