# 🧠 BrainVibes — AI Coding Agent System Instructions

> **Vibes Coding Workflow v2.2** — A production-grade AI coding agent instruction system designed for Gemini CLI, Antigravity IDE, Cursor, Copilot, and any LLM-based coding agent.

[![Version](https://img.shields.io/badge/version-2.2-blueviolet?style=flat-square)](https://github.com/Noisesless/brainvibes)
[![Language](https://img.shields.io/badge/language-Bahasa%20Indonesia%20%2B%20English-orange?style=flat-square)](#dual-language-protocol)
[![Files](https://img.shields.io/badge/files-3%20core%20files-success?style=flat-square)](#architecture)
[![Palettes](https://img.shields.io/badge/palettes-15%20master%20themes-ff69b4?style=flat-square)](#design-system)

---

## 📖 What is BrainVibes?

BrainVibes is a **system instruction framework** that transforms any AI coding agent into a disciplined, intelligent, and consistent software development partner. It enforces:

- ✅ **Zero-interruption execution** — AI executes without waiting for unnecessary input
- ✅ **Fail-fast security scans** — 5-layer security gate before every build
- ✅ **Single responsibility per file** — no rule leaks between system files
- ✅ **Bilingual operation** — all user interaction in Bahasa Indonesia, all code in English
- ✅ **Proactive intelligence** — AI validates every instruction against `prd.md` before acting

---

## 🗂️ Architecture — 3-File System

| File | Role | Contains |
|---|---|---|
| [`gemini.md`](./gemini.md) | **Brain / OS** — Universal laws for ALL projects, ALL sessions | Protocols, FORBIDDEN/REQUIRED rules, macro switches, behavior engine |
| [`prd-template.md`](./prd-template.md) | **Project Spec Form** — Per-project data filled during interview | App name, palette choice, features, pages, DB schema, blueprint manifest |
| [`design-system.md`](./design-system.md) | **Visual Database** — Color & component reference, loaded on-demand | 15 master palettes, CSS tokens, typography hierarchy, spacing, z-index |

> **Anti-Rule-Leak Law:** `prd-template.md` contains ONLY per-project data + cross-references. ALL behavior rules live exclusively in `gemini.md`. Violations = **Rule Leak Fatal Error**.

---

## 🎮 Macro Switches (Saklar Utama)

Trigger any mode by starting your message with the exact switch phrase:

| Switch | Mode | Description |
|---|---|---|
| `awal baru` | 🚀 **New Project Wizard** | 10-point interview → PRD generation → 8-phase todo.md |
| `awal lanjut` | 🔄 **Smart Continuity** | Silent recovery from `prd.md` + `todo.md` + `handover.md` |
| `awal konversi` | 🔀 **Stack Migration** | 7-point wizard + Legacy System Audit (10 tables) → 9-phase migration plan |
| `tambah fitur` | ➕ **Incremental Feature Add** | Add features to active project without re-interview |
| `baca error` | 🐛 **YOLO Debug Mode** | Global scan → `issues.md` → Mandor approval gate before touching code |
| `lanjut dari sini` | ♻️ **Context Recovery** | Reconstruct mid-session state from `todo.md` + `handover.md` |
| `status proyek` | 📊 **Quick Project Brief** | 10-line max progress report (phase, %, compile status, open issues) |
| `analisa kualitas` | 🔍 **Code Quality Audit** | Code smell scanner (DRY, complexity, file size, magic numbers) |

---

## 🚀 `awal baru` — New Project Wizard

When triggered, the AI conducts a 10-point structured interview and generates a complete `prd.md` + `todo.md`:

### AI Stack Intelligence Gate (Automatic Complexity Analysis)

Before locking the PRD, AI automatically detects project complexity signals and recommends additional stack:

| Signal | Recommendation |
|---|---|
| ML/AI, NLP, Computer Vision | Python + FastAPI microservice |
| Complex financial calculations | Python + Pandas/NumPy |
| Heavy background jobs | Redis + BullMQ / Celery |
| Real-time chat / live notifications | WebSocket (Socket.io / Ably) |
| Full-text search > 100K records | Elasticsearch / Meilisearch |
| Multi-tenant / subdomain split | Microservices + API Gateway |
| Large file uploads > 50MB | S3-compatible storage (MinIO / R2) |
| > 10,000 concurrent users | Redis Cache + CDN + Load Balancer |

### 8-Phase Standard Project Structure

```
Phase 1  │ Foundation & Environment Setup
Phase 2  │ Core Architecture & Design System
Phase 3  │ Guest Layer (Public / Unauthenticated)
Phase 4  │ Member Layer (Authenticated / Protected)
Phase 5  │ Admin Layer (Privileged Control Panel)
Phase 6  │ Backend Service Layer (Business Logic & Data Integrity)
Phase 7  │ API, Webhooks & Third-Party Integrations
Phase 8  │ Polish, SEO, A11Y & Deploy Prep
```

> **Zero Generic Placeholder Rule:** Every page from the PRD Blueprint Manifest MUST be a specific named task in `todo.md`. FORBIDDEN: `"Halaman lain sesuai wawancara"`. REQUIRED: individual named tasks per page.

---

## 🔀 `awal konversi` — Legacy System Migration

Triggers a full **Legacy System Audit** before any migration starts. AI generates `/.docs/legacy-audit.md` mapping 10 dimensions of the existing system:

| # | Audit Dimension | Output Columns |
|---|---|---|
| 1 | **Routes Map** | Path, Method, Controller@Method, Auth, Middleware |
| 2 | **Controller Inventory** | All controllers + every method inside |
| 3 | **Model/ORM Inventory** | Model, table name, file path, inter-model relations |
| 4 | **View/Template Inventory** | View name, file path, rendering controller, partials used |
| 5 | **Database Schema (DDL)** | Every table: columns, types, indexes, foreign keys |
| 6 | **API Endpoints** | Method, path, controller, auth type, response format |
| 7 | **Webhooks** | Inbound/outbound, trigger event, handler |
| 8 | **Third-Party Integrations** | Service, SDK/library, config keys |
| 9 | **File Upload Directories** | Path, allowed formats, size limits |
| 10 | **Active Pages Map** | All frontend pages + URL + auth requirement + status |

**9-Phase Migration Structure:**
- Fase 1–3: New stack setup
- Fase 4–6: Feature migration
- Fase 7–8: Data migration & testing
- Fase 9: Legacy purge (dry-run + written approval required)

**Strangler Fig Protocol:** Old system STAYS RUNNING throughout migration. AI FORBIDDEN to kill legacy system before new system passes all 5 security scan layers.

---

## 🛡️ 5-Layer Security Gate

Executed before every build. Each layer must PASS before proceeding to the next:

| Layer | Name | Tool | Pass Condition |
|---|---|---|---|
| **L1** | Linter & Formatter | `eslint --max-warnings=0` / `prettier --check` / `pint --test` | Zero warnings, zero errors |
| **L2** | Type Safety | `tsc --noEmit --strict` | Zero type errors |
| **L3** | SAST (Static Analysis) | Grep for `eval(`, `innerHTML =`, `exec(`, raw SQL | Zero dangerous patterns |
| **L4** | Form Input Guard | Read every form/endpoint — validate length, sanitize, rate-limit | All forms & endpoints secured |
| **L5** | Auth Integrity | Check every protected route for active middleware/guard | All routes protected |

```
Status 5 Lapisan Scan:
  L1 Linter       : PASSED / FAILED
  L2 Type Safety  : PASSED / FAILED
  L3 SAST         : CLEAN / RISK
  L4 Input Guard  : SECURED / EXPOSED
  L5 Auth         : VERIFIED / BROKEN
```

---

## 🎨 Design System — 15 Master Palettes (2026 Trend)

| # | Cluster Name | Background | Accent 1 | Accent 2 | Vibe |
|---|---|---|---|---|---|
| 1 | Cyber Industrial | `#111111` | `#FF6B00` | `#00FFC2` | Ultra Dark |
| 2 | Quiet Luxury | `#FDFBF7` | `#4A1525` | `#0D3B30` | Warm Premium |
| 3 | Electric SaaS | `#0F172A` | `#635BFF` | `#00E5E5` | Modern Tech |
| 4 | Acid Streetwear | `#0A0A0A` | `#DFFF00` | `#7000FF` | Creative Studio |
| 5 | Cloud Dancer | `#F1F5F9` | `#008080` | `#94A3B8` | Clean Minimalist |
| 6 | Deep Burgundy | `#1A0B10` | `#8B002A` | `#D4AF37` | Luxury Corporate |
| 7 | Carbon Mint | `#161719` | `#00FF9F` | `#37474F` | Edgy Portfolio |
| 8 | Dopamine Burst | `#0A051B` | `#EF5777` | `#FFA801` | Vibrant Startup |
| 9 | Nordic Earth | `#F9F6F0` | `#A47864` | `#708090` | Organic Minimal |
| 10 | Titanium Stealth | `#0D0E10` | `#788896` | `#FF3E3E` | Tech Hardware |
| 11 | Oceanic Jade | `#051C24` | `#00BFA5` | `#00E5FF` | Fintech & Biotech |
| 12 | Soft Velvet | `#FAF7F5` | `#3A223A` | `#E0A96D` | Premium E-Commerce |
| 13 | Crimson Oxide | `#121214` | `#E60000` | `#8E9AA6` | Automotive & MX |
| 14 | Sage Balance | `#F4F7F5` | `#4F6F52` | `#D2E0D6` | Wellness & Lifestyle |
| 15 | Neon Midnight | `#03030C` | `#FF007F` | `#7B2CBF` | Cyberpunk Aesthetic |

**Hue-Locking Rule:** Dark mode MUST preserve the original palette hue — rotating to a deep tonal variant. FORBIDDEN: converting to `#000000` or `#FFFFFF` regardless of mode.

---

## 🔐 Secure Upload Pipeline (5 Mandatory Stages)

Every file upload in any project generated by this system goes through:

```
Stage 1 → Pre-Upload Validation   (MIME type via Magic Bytes, NOT file extension)
Stage 2 → UUID Hashing            (FORBIDDEN saving original filename from user)
Stage 3 → EXIF Strip              (Remove GPS, device, author metadata)
Stage 4 → WebP Compression        (Auto-crop 1:1 center-focused + resize + convert)
Stage 5 → JSON DB Storage         (Save all size variants path to database)
```

Output format: `[uuid]_[timestamp].webp` — e.g., `a3f8b2c1-9d4e_1718352000000.webp`

---

## 🌐 Anti-Bot HTTP Client (Stealth Fetch Engine)

All external HTTP requests made by generated projects use a human-behavior simulation wrapper:

- 🎭 Randomized User-Agent rotation (desktop + mobile pool)
- ⏱️ Adaptive delay with jitter (1.5–4.5s base + random offset)
- 🍪 Cookie jar persistence with session fingerprint
- 🗜️ Accept-Encoding + Accept-Language headers matching real browsers
- 🔄 Exponential backoff retry on rate-limit (429) responses
- 🚫 Zero `fetch()` or `axios` bare calls in generated code

---

## ♿ Accessibility & Performance Standards

### WCAG 2.1 AA Compliance (Enforced)
- Color contrast ratio ≥ 4.5:1 (text vs background)
- All interactive elements keyboard-navigable (Tab order)
- Focus indicator visible on `:focus-visible`
- Skip-to-content link on all pages
- All images have descriptive `alt` text
- Modal/drawer traps focus when open (no keyboard escape leak)
- ARIA labels on icon-only buttons

### Performance Budget (Hard Limits)
| Metric | Limit |
|---|---|
| First Contentful Paint (FCP) | < 1.5s |
| Largest Contentful Paint (LCP) | < 2.5s |
| Total JavaScript bundle | < 200KB gzipped |
| Image formats | WebP only (JPEG/PNG as fallback) |
| Third-party scripts | Max 3 per page |

---

## 🔒 Git Commit Protocol (5-Stage Sanitization)

Every commit generated by this system follows strict sanitization:

```bash
# Stage 1: Unstage ALL sensitive files first
git reset HEAD .env* handover.md prd.md todo.md issues.md *.sqlite /.scratchpad/

# Stage 2: Stage only source files
git add [specific files only — NEVER git add .]

# Stage 3: Verify staged diff (no secrets)
git diff --staged --stat

# Stage 4: Conventional commit
git commit -m "feat|fix|refactor|docs|chore: [scope] description"

# Stage 5: Post-commit verification
git log --oneline -1
git status  # must be clean
```

**Files permanently blocked from commits (`.gitignore` enforced):**
`.env`, `.env.*`, `prd.md`, `todo.md`, `handover.md`, `issues.md`, `*.sqlite`, `/.scratchpad/`, `*secret*`, `*.key`, `*.pem`

---

## 📐 Universal Laws (Hard Blocks)

| Category | Law |
|---|---|
| 🔴 HARD | **Zero-Interruption** — No confirmation prompts during execution |
| 🔴 HARD | **Anti-Destructive DB** — FORBIDDEN `migrate:fresh` on live data |
| 🔴 HARD | **Anti-Looping** — After 3 failed attempts, MUST rollback |
| 🔴 HARD | **No-Truncation** — FORBIDDEN `// rest of code...` comments |
| 🔴 HARD | **Core Identity Lock** — FORBIDDEN changing 🔒 IMMUTABLE values in `prd.md` |
| 🟡 GATE | **Mandor Approval** — STOP before modifying code during `baca error` mode |
| 🟡 GATE | **Legacy Purge Gate** — Phase 9 deletion needs dry-run log + written approval |
| ⬜ STD | **Zombie Port Guard** — Kill locked PID, or dynamically increment port |
| ⬜ STD | **Shell Anti-Interrupt** — Always inject `CI=true` to prevent stuck prompts |

---

## 🗃️ Generated Project File Structure

```
project-root/
├── /.docs/                 ← Technical documentation hub
│   ├── architecture.md     ← Data flow & macro architecture
│   ├── api-spec.md         ← API endpoint specifications
│   ├── database.md         ← Database schema (DDL)
│   ├── legacy-audit.md     ← (Conversion only) Legacy system mapping
│   └── quality_review.md  ← Output of analisa kualitas scan
├── /.scratchpad/           ← Isolated debug zone (Git-ignored)
├── /src/ or /app/          ← Main application code
├── .env.example            ← Environment variable template (no real values)
├── .gitignore              ← Auto-generated with all sensitive file blocks
├── handover.md             ← Session state tracker (Git-ignored)
├── prd.md                  ← Project requirements document (Git-ignored)
└── todo.md                 ← 8-phase task checklist (Git-ignored)
```

---

## 🌍 Dual-Language Protocol

| Context | Language |
|---|---|
| User conversation, status messages, questions | **Bahasa Indonesia** |
| Code, variable names, function names, commit messages, shell commands | **English** |

---

## 📋 Supported Tech Stacks

**Frontend:** HTML/CSS/JS Native · PHP Native · Next.js 14+ App Router · React Vite  
**Backend:** PHP Native · Laravel · Node.js Express · Hono.js · Supabase BaaS  
**Database:** MySQL · PostgreSQL (via Prisma) · SQLite · In-Memory State Simulator  
**Styling:** Tailwind CSS v4 · Vanilla CSS · Bootstrap 5  
**Additional:** Python + FastAPI · Redis + BullMQ · Socket.io · Elasticsearch · Meilisearch  
**Package Managers:** npm · pnpm · yarn · bun  

---

## 📄 License

This system instruction set is open-sourced for personal and commercial use.  
Built and maintained by [@Noisesless](https://github.com/Noisesless).

---

<div align="center">
<sub>BrainVibes v2.2 — Vibes Coding Workflow · Smarter AI, Cleaner Code, Zero Excuses</sub>
</div>
