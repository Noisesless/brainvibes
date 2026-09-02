# Brainvibes — Dependency Graph

## 🔴 Critical Files (paling banyak di-import — JANGAN ubah tanpa review)

| File | Imported By (count) | Tipe |
|---|---|---|
| `gemini.md` | 4+ (AGENTS.md, .gemini, execution, templates) | Core instructions |
| `user-prefs.md` | 5+ (Semua sesi, execution, templates) | User preferences |
| `AGENTS.md` | 2+ (.gemini, execution) | Behavior rules |
| `design-system.md` | 3+ (UI components, visual gate) | Design tokens |
| `config/mcp_config.json` | 2 (codebase-memory, context7) | MCP servers |
| `config/hooks.json` / `.agents/hooks.json` | 1+ (Antigravity IDE lifecycle) | Lifecycle hooks config |

## 🟡 High-Impact Files (ubah = efek luas)

| File | Depends On | Used By | Impact Level |
|---|---|---|---|
| `gemini-execution.md` | gemini.md, user-prefs.md | Execution workflow | High |
| `gemini-templates.md` | gemini.md, user-prefs.md | Macro commands | High |
| `prd-template.md` | gemini.md, design-system.md | PRD generation | High |
| `sync.ps1` | scripts/ensure-cbm-daemon.ps1 | Sync mechanism (core, config, knowledge, CBM) | High |
| `scripts/cbm-hook.ps1` | codebase-memory-mcp.exe | Antigravity IDE PreInvocation hook | High |
| `scripts/index-project.ps1` | scripts/ensure-cbm-daemon.ps1 | Indexing AST graph + UI assurance | Medium |
| `scripts/ensure-cbm-daemon.ps1` | codebase-memory-mcp.exe | CBM daemon background health guard | Medium |
| `yasei-cli.ps1` | user-prefs.md, app-context.md | CLI subsystem | Medium |
| `app-context-template.md` | gemini.md | Context snapshot | Medium |


## 🟢 Leaf Files (aman diubah — minimal dependency)

| File | Purpose |
|---|---|
| `config/projects/*.json` | Project registry (UUID-based) |
| `LICENSE` | MIT License |
| `.gitignore` | Git ignore rules |
| `README.md` | Project documentation |

### Skills (Leaf — isolated)

| Skill | Dependencies | Purpose |
|---|---|---|
| `ui-ux-pro-max` | 14 datasets (colors, typography, styles, ui-reasoning, landing, dll) | Design intelligence (Search / Direct-Read) |
| `taste-skill-bridge` | ui-ux-pro-max, SKILL.md (router), ESSENTIAL, DETAILED, REFERENCE, CHEATSHEET, MODEL_HINTS | Anti-slop bridge & model overrides |
| `security-patterns` | known-vulns.md, secure-patterns.md | Security rules |
| `code-snippets` | auth-patterns.md, form-patterns.md | Reusable snippets |
| `database-patterns` | - | Schema design |
| `lessons-learned` | anti-patterns.md, fast-solutions.md | Knowledge base |
| `pentest-strix` | strix-usage-guide.md | DAST validation |
| `accessibility-audit` | - | WCAG 2.2 AA |
| `performance-audit` | - | Core Web Vitals |
| `deployment-checklist` | - | Pre-deploy checklist |
| `git-workflow` | - | Conventional commits |
| `quick-scaffold` | - | File boilerplate generator |

### Knowledge Bases (Leaf — isolated)

| Knowledge | Dependencies | Purpose |
|---|---|---|
| `error-solutions` | css-oklch-compat.md, dll | Error troubleshooting |
| `project-retrospectives` | retro templates | Post-mortem analysis |
| `vibes-stack-patterns` | nextjs-patterns.md, dll | Proven code patterns |

## Import Chain Analysis

### Core Instructions Chain & Silent Dependencies
```
user-prefs.md (highest priority — silent read)
    ↓
gemini.md (core instructions, §VISUAL RULES [18 ban + 5 enforcement], §SESSION PROTOCOL, Dispatch Table [11 saklar])
    ↓
AGENTS.md (extends gemini.md — deep links to gemini-execution.md #L92, #L261, #L608, #L642)
    ↓
gemini-execution.md (loaded on-demand — §3.A-C, §4.A-J, §4K visual pipeline, §4I self-check, §4L-§4N)
    ↓
gemini-templates.md (loaded on-demand — macro commands §2A-§2K, §5 YOLO, §6A git)
    ↓
design-system.md (loaded on-demand — §1-§13 design DNA, §7B Component Token Registry)
```

### Skills Chain
```
ui-ux-pro-max (14 datasets + Direct-Read + ui-reasoning layout intel)
    ↓
taste-skill-bridge (router v2.0 → ESSENTIAL / DETAILED / CHEATSHEET / MODEL_HINTS)
    ↓
visual gate enforcement (uses taste-skill-bridge + design-system.md §7B)
```

### MCP & Lifecycle Hook Chain
```
Antigravity IDE (User Turn / Invocations)
    ↓
hooks.json (PreInvocation)
    ↓
scripts/cbm-hook.ps1 (<100ms socket check)
    ↓
codebase-memory daemon (port 9749 background listener & 3D UI)
    ↓
mcp_config.json
    ├── codebase-memory (code intelligence graph — AST, call chain, routes)
    └── context7 (library docs RAG)
```

## Circular Dependencies

| Check | Result |
|---|---|
| gemini.md ↔ AGENTS.md | ✅ No circular (AGENTS.md extends, tidak replace) |
| gemini-execution.md ↔ gemini-templates.md | ✅ No circular (loaded independently) |
| ui-ux-pro-max ↔ taste-skill-bridge | ✅ No circular (one-way dependency) |
| user-prefs.md ↔ gemini.md | ✅ No circular (user-prefs dibaca dulu) |

## File Role Definitions

| File | Role | Load Method | Priority |
|---|---|---|---|
| `user-prefs.md` | User preferences | Full read (silent) | HIGHEST |
| `app-context.md` | AI snapshot | Full read (silent) | HIGH |
| `gemini.md` | Core instructions | Full read | HIGH |
| `prd.md` | Project requirements | Range read (if needed) | MEDIUM |
| `todo.md` | Task checklist | Grep (partial) | MEDIUM |
| `gemini-execution.md` | Execution details | View_file (section) | ON-DEMAND |
| `gemini-templates.md` | Templates | View_file (section) | ON-DEMAND |
| `design-system.md` | Design tokens | Section read | ON-DEMAND |
