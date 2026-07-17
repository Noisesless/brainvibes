# Brainvibes — Dependency Graph

## 🔴 Critical Files (paling banyak di-import — JANGAN ubah tanpa review)

| File | Imported By (count) | Tipe |
|---|---|---|
| `gemini.md` | 5+ (AGENTS.md, opencode, .gemini, execution, templates) | Core instructions |
| `user-prefs.md` | 5+ (Semua sesi, execution, templates) | User preferences |
| `AGENTS.md` | 3+ (opencode, .gemini, execution) | Behavior rules |
| `design-system.md` | 3+ (UI components, visual gate) | Design tokens |
| `config/mcp_config.json` | 3+ (context7, filesystem, memory) | MCP servers |

## 🟡 High-Impact Files (ubah = efek luas)

| File | Depends On | Used By | Impact Level |
|---|---|---|---|
| `gemini-execution.md` | gemini.md, user-prefs.md | Execution workflow | High |
| `gemini-templates.md` | gemini.md, user-prefs.md | Macro commands | High |
| `prd-template.md` | gemini.md, design-system.md | PRD generation | High |
| `yasei-cli.ps1` | user-prefs.md, app-context.md | CLI subsystem | Medium |
| `sync.ps1` | - | Sync mechanism | Medium |
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
| `ui-ux-pro-max` | colors.csv, typography.csv, dll | Design intelligence |
| `taste-skill-bridge` | ui-ux-pro-max | Anti-slop bridge |
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

### Core Instructions Chain
```
user-prefs.md (highest priority)
    ↓
gemini.md (core instructions)
    ↓
AGENTS.md (extends gemini.md)
    ↓
gemini-execution.md (loaded on-demand)
    ↓
gemini-templates.md (loaded on-demand)
```

### Skills Chain
```
ui-ux-pro-max (base)
    ↓
taste-skill-bridge (depends on ui-ux-pro-max)
    ↓
visual gate enforcement (uses taste-skill-bridge)
```

### MCP Chain
```
mcp_config.json
    ↓
context7 (library docs)
    ↓
filesystem (file operations)
    ↓
memory (persistent state)
    ↓
web_search (real-time info)
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
