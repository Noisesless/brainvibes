# Smart Skill Integration (SSI) Protocol

## Filosofi
```
Manual install (copy-paste) + AI auto-validate + Git versioning
= Simple, safe, flexible
```

---

## Auto-Detect Skill Baru

### Trigger:
- AI scan `config/skills/` setiap sesi baru
- Jika ada folder baru tanpa entry di `.skill-index.json`
- AI print: `[SKILL DETECT] Ditemukan skill baru: <name>/`

### Action:
1. Baca `SKILL.md` → extract metadata (name, description, triggers)
2. Scan `data/` → list available files
3. Baca `manifest.json` (jika ada) → extract version
4. Jalankan **Gap & Conflict Check** (§2)

---

## Gap & Conflict Check Checklist

### 1. Trigger Keywords Overlap
```
FORBIDDEN: Duplicate triggers yang sama persis
ALLOWED:  Partial overlap (triggers berbeda konteks)
ACTION:   COMBINE triggers (tidak replace)
```

### 2. Data Files Path Collision
```
FORBIDDEN: Overwrite data file yang sudah ada
ALLOWED:  File baru dengan path berbeda
ACTION:   SKIP jika collision, REPORT ke user
```

### 3. Logic/Functions Duplication
```
FORBIDDEN: Duplicate logic yang sama persis
ALLOWED:  Partial overlap (logika berbeda konteks)
ACTION:   SKIP jika duplicate, REPORT ke user
```

### 4. Dependencies Missing
```
CHECK:    Skill baru butuh skill lain?
ACTION:   INSTALL dependency jika belum ada
```

### 5. Conflicts with Existing Skills
```
CHECK:    Apakah skill baru konflik dengan existing?
ACTION:   REPORT ke user, tunggu konfirmasi
```

---

## Conflict Resolution Rules

| Conflict Type | Resolution | Example |
|---|---|---|
| Trigger keywords | COMBINE (tidak replace) | `["baca error"] + ["pernah coba"] → ["baca error", "pernah coba"]` |
| Data files | SKIP if collision | `data/form-validation.md` sudah ada → skip |
| Logic/functions | SKIP if duplicate | `authenticate()` sudah ada → skip |
| Dependencies | INSTALL if missing | Butuh `security-patterns` → install dulu |
| Conflicts | REPORT + wait | `auth-flow.md` vs `login-form.md` → report ke user |

---

## AI Workflow (Auto-Detect → Validate → Integrate)

### Step 1: Auto-Detect
```
AI scan config/skills/ setiap sesi
→ Jika ada folder baru tanpa entry di .skill-index.json
→ Trigger: "[SKILL DETECT] Ditemukan skill baru: X"
```

### Step 2: Extract Metadata
```
→ Baca SKILL.md → extract name, description, triggers
→ Baca data/ → list available files
→ Baca manifest.json (jika ada) → extract version
```

### Step 3: Gap & Conflict Check
```
→ Compare triggers dengan existing skills
→ Compare data paths dengan existing skills
→ Compare logic/functions dengan existing skills
→ Check dependencies (butuh skill lain?)
```

### Step 4: Generate Report
```
[SKILL INTEGRATION REPORT]
Skill: X v1.0
├── ✅ Compatible dengan: A, B
├── ⚠️ Partial overlap dengan: C (bagian: form-validation)
├── 💡 Rekomendasi: Ambil auth-flow.md, skip form-validation.md
└── 📋 Auto-trigger? (Y/n)
```

### Step 5: User Confirm
```
→ User: "Y" → AI integrate
→ User: "n" → Skip, log sebagai "pending"
```

### Step 6: Auto-Integrate
```
→ Copy non-conflicting files
→ Merge trigger keywords (combine, tidak replace)
→ Update .skill-index.json (AI-managed)
→ Update AGENTS.md SKILLS REGISTRY
→ Enable auto-trigger
```

### Step 7: Notify User
```
→ "[SKILL INTEGRATED] X v1.0 aktif dengan triggers: [...]"
→ "[AUTO-TRIGGER] Skill X akan aktif saat keyword: [...]"
```

---

## Auto-Trigger Policy

### Default Behavior:
- Auto-trigger **ON** setelah integrate
- AI auto-activate skill saat trigger keyword terdeteksi

### User Control:
```
Disable:  "disable auto-trigger <skill-name>"
Enable:   "enable auto-trigger <skill-name>"
Test:     "test trigger <skill-name> <keyword>"
List:     "list auto-triggers"
```

### Implementation:
```
1. AI scan trigger keyword di user message
2. Jika match dengan skill auto-trigger → activate skill
3. Jika tidak match → skip
4. User bisa override: "disable auto-trigger X"
```

---

## Quality Analysis Trigger (Periodic)

### Trigger Command:
```
User ketik: "analisa kualitas brainvibes"
```

### AI Scan:
```
1. Context poisoning risk (token usage, duplicates)
2. Skill gaps (missing functionality)
3. Skill conflicts (overlap, redundancy)
4. Performance bottlenecks (slow skills, high token cost)
5. .docs staleness (apakah .docs masih sesuai dengan codebase?)
```

### AI Recommend:
```
1. Update existing skills (fix bugs, add features)
2. Implement new skills (fill gaps)
3. Remove redundant skills (eliminate overlap)
4. Optimize high-cost skills (reduce token usage)
5. Auto-update .docs (after N tasks completed)
```

---

## Auto-Update .docs Protocol

### Trigger:
```
Setiap 5-6 task selesai → AI auto-scan .docs/
→ Jika ada file yang perlu update → update otomatis
→ Jika tidak ada perubahan → skip
```

### Auto-Update Checklist:
```
1. architecture.md → scan codebase → update jika ada perubahan arsitektur
2. api-spec.md → scan routes/endpoints → update jika ada endpoint baru
3. database.md → scan migrations/schema → update jika ada table/column baru
4. quality_review.md → run linter → update jika ada code smell baru
5. routes.md → scan frontend/backend → update jika ada route baru
6. dependency-graph.md → scan imports → update jika ada file baru
7. issues.md → FIFO max 10 resolved → update jika ada issue baru
```

### Implementation:
```
1. AI scan task completion di todo.md
2. Jika task count mod 5 == 0 → trigger auto-update .docs
3. AI scan .docs/ files → compare dengan codebase aktual
4. Jika ada perubahan → update file
5. Jika tidak ada perubahan → skip
6. Print: "[DOCS UPDATE] X files updated, Y files skipped"
```

### Token Optimization:
```
- Scan .docs/ files hanya jika ada perubahan di codebase
- Gunakan mtime check → skip jika file tidak berubah
- Batch update → 1x scan, update semua file yang perlu
- Archive old .docs/ jika ukuran > 100 baris/file
```

---

## .skill-index.json Management

### AI-Managed Rules:
```
1. AI yang update .skill-index.json (bukan user)
2. Update otomatis setelah integrate/remove skill
3. Format: name, path, triggers, version, dependencies, conflicts
4. Timestamp: last_updated setiap ada perubahan
```

### Manual Override (jika perlu):
```
User bisa edit .skill-index.json manual
→ AI akan detect dan sync dengan codebase
→ Print: "[INDEX SYNC] Ditemanisasi manual, sync dengan codebase..."
```

---

## Error Handling

### Skill Corrupt:
```
→ AI detect: SKILL.md tidak valid
→ Action: Log error, skip skill, report ke user
→ Print: "[SKILL ERROR] X corrupt, skip until fixed"
```

### Dependency Missing:
```
→ AI detect: Skill A butuh Skill B, tapi B belum ada
→ Action: INSTALL B dulu, lalu A
→ Print: "[DEPENDENCY] Installing B (required by A)..."
```

### Index Out of Sync:
```
→ AI detect: .skill-index.json tidak match dengan codebase
→ Action: Rebuild index dari codebase
→ Print: "[INDEX SYNC] Rebuilding index from codebase..."
```

---

## Summary

| Feature | Status | Implementation |
|---|---|---|
| Auto-detect skill baru | ✅ | Scan config/skills/ setiap sesi |
| Gap & conflict check | ✅ | 5-point checklist |
| Smart merge | ✅ | Combine triggers, skip duplicates |
| Auto-trigger | ✅ | ON by default, user can disable |
| AI-managed index | ✅ | .skill-index.json auto-update |
| Quality analysis | ✅ | "analisa kualitas brainvibes" |
| Auto-update .docs | ✅ | Every 5-6 tasks |
| Error handling | ✅ | Corrupt, missing deps, out of sync |
