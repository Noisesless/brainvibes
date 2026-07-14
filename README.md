<div align="center">

# 🧠 Brainvibes

### _Global AI Coding Configuration System_

**Satu ekosistem lengkap. Nol kompromi.**

[![Version](https://img.shields.io/badge/version-4.0.0--stable-6366f1?style=for-the-badge&logo=gitbook&logoColor=white)](https://github.com/Noisesless/brainvibes)
[![Gemini CLI](https://img.shields.io/badge/Gemini_CLI-Compatible-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://github.com/google-gemini/gemini-cli)
[![Antigravity IDE](https://img.shields.io/badge/Antigravity_IDE-Compatible-8b5cf6?style=for-the-badge&logo=visualstudiocode&logoColor=white)](#)
[![Platform](https://img.shields.io/badge/Platform-Windows_%7C_Unix-0ea5e9?style=for-the-badge&logo=windows&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-10b981?style=for-the-badge)](LICENSE)

---

*Sistem instruksi global berbasis Markdown untuk menstandarisasi, mengamankan,*
*dan mengotomasi seluruh siklus hidup proyek kode yang dibangun bersama AI.*

</div>

---

## 📌 Apa Itu Brainvibes?

**Brainvibes** adalah ekosistem konfigurasi lengkap yang bertindak sebagai **"DNA Otak"** dari setiap sesi coding berbasis AI. Dengan menempatkan seluruh berkas ini di direktori konfigurasi terminal AI Anda, agen AI (seperti Gemini CLI atau Antigravity IDE) akan secara otomatis membaca dan mematuhi seluruh aturan interaksi, keamanan, estetika visual, dan alur kerja yang telah Anda tetapkan — **di setiap sesi kerja baru, tanpa perlu konfigurasi ulang**.

> Dirancang khusus untuk developer yang ingin AI-nya **bekerja seperti senior engineer berpengalaman** — bukan seperti autocomplete yang asal jalan.

---

## 📂 Struktur Ekosistem

### Berkas Inti (9 File)

| File | Ukuran | Fungsi |
| :--- | :--- | :--- |
| 🧠 [`gemini.md`](gemini.md) | ~20KB | **Core Otak** — Global system instructions, §VISUAL_GATE, §SESSION_PROTOCOL, pointer ke detail |
| 🛠️ [`gemini-execution.md`](gemini-execution.md) | ~30KB | **Kecerdasan Eksekusi** — Aturan coding, arsitektur modular, upload pipeline, Modern CSS, A11Y |
| 📋 [`gemini-templates.md`](gemini-templates.md) | ~25KB | **Templates & Commands** — Detail 10 makro command, YOLO debug mode, 5 tahap Git Commit |
| 📋 [`prd-template.md`](prd-template.md) | ~55KB | **Blueprint** — Template PRD 11-bab, CORE IDENTITY LOCK, Visual DNA System |
| 🎨 [`design-system.md`](design-system.md) | ~36KB | **Design DNA** — CSS token system (oklch), @layer architecture, typography, components |
| 📐 [`AGENTS.md`](AGENTS.md) | ~12KB | **Rules Tambahan** — Session init protocol, anti-slop enforcement, skills registry, security auto-trigger |
| ⚙️ [`user-prefs.md`](user-prefs.md) | ~2.5KB | **Preferensi** — Port defaults, design defaults, AI behavior toggles, context7 whitelist |
| 🔌 [`config/mcp_config.json`](config/mcp_config.json) | ~170B | **MCP Server** — context7 documentation retrieval server |
| 📜 `LICENSE` | ~36KB | MIT License |

### Skills System (10 Skill Folders)

| Skill | Trigger Keywords | Fungsi |
| :--- | :--- | :--- |
| 🎨 `ui-ux-pro-max` | awal baru, redesign | **UUPM** — Design intelligence dengan 15 CSV datasets, multi-stack support |
| 🖌️ `taste-skill-bridge` | buat halaman, landing page, UI baru | Anti-slop frontend bridge, Three Dials system |
| 🔒 `security-patterns` | analisa keamanan, scan keamanan | Vulnerability database + secure coding patterns per stack |
| 📝 `code-snippets` | buat form, buat navbar, buat modal | Library snippet siap pakai (auth, form, layout, UI components) |
| 🗄️ `database-patterns` | desain database, migration | Schema design, query optimization, ORM patterns |
| 📚 `lessons-learned` | baca error, jangan ulangi | Anti-patterns + fast solutions dari proyek nyata |
| ♿ `accessibility-audit` | audit a11y, WCAG | Checklist WCAG 2.2 AA |
| ⚡ `performance-audit` | audit performa, lighthouse | Core Web Vitals optimization |
| 🚀 `deployment-checklist` | deploy, hosting, go live | Pre-deploy checklist per platform |
| 🔀 `git-workflow` | commit, push, branch | Conventional commits, branch protection |

### Knowledge Items (3 Knowledge Bases)

| Knowledge | Isi | Fungsi |
| :--- | :--- | :--- |
| 📕 `error-solutions/` | 4 file (PHP, Next.js, CSS oklch, XAMPP) | Solusi error dari proyek nyata — dibaca saat `baca error` |
| 📗 `project-retrospectives/` | 1 retro + template | Post-mortem proyek — dibaca saat `awal baru` |
| 📘 `vibes-stack-patterns/` | 3 file (PHP, Next.js, CSS) | Proven code patterns — dibaca saat menulis kode |

---

## ⚡ Instalasi Cepat (2 Langkah)

```bash
# 1. Clone repositori ini
git clone https://github.com/Noisesless/brainvibes.git

# 2. Salin semua berkas ke direktori konfigurasi AI Anda
#    Windows (Gemini CLI / Antigravity IDE):
copy brainvibes\gemini.md               %USERPROFILE%\.gemini\gemini.md
copy brainvibes\gemini-execution.md     %USERPROFILE%\.gemini\gemini-execution.md
copy brainvibes\gemini-templates.md     %USERPROFILE%\.gemini\gemini-templates.md
copy brainvibes\prd-template.md          %USERPROFILE%\.gemini\prd-template.md
copy brainvibes\design-system.md         %USERPROFILE%\.gemini\design-system.md
copy brainvibes\AGENTS.md                %USERPROFILE%\.gemini\AGENTS.md
copy brainvibes\user-prefs.md            %USERPROFILE%\.gemini\user-prefs.md
xcopy brainvibes\config                  %USERPROFILE%\.gemini\config /E /I /Y
xcopy brainvibes\knowledge               %USERPROFILE%\.gemini\antigravity-ide\knowledge /E /I /Y

#    Unix / macOS:
cp brainvibes/gemini*.md brainvibes/prd-template.md brainvibes/design-system.md \
   brainvibes/AGENTS.md brainvibes/user-prefs.md ~/.gemini/
cp -r brainvibes/config/* ~/.gemini/config/
cp -r brainvibes/knowledge/* ~/.gemini/antigravity-ide/knowledge/
```

> ✅ Selesai. AI Anda akan langsung membaca instruksi ini di sesi berikutnya secara otomatis.

---

## 🎮 10 Makro Command

Ketik perintah di bawah sebagai **kalimat pertama** pada sesi chat AI Anda:

<table>
<tr>
<th width="20%">Command</th>
<th width="25%">Mode</th>
<th width="55%">Kapan Digunakan</th>
</tr>
<tr>
<td><code>awal baru</code></td>
<td>🏗️ Fase Inisiasi</td>
<td>Memulai proyek dari nol. Wizard PRD 10-poin + Stack Intelligence Gate + Knowledge Priming.</td>
</tr>
<tr>
<td><code>awal lanjut</code></td>
<td>🔄 Kontinuitas</td>
<td>Melanjutkan sesi. Baca <code>app-context.md</code> → Visual DNA Checksum → resume task aktif.</td>
</tr>
<tr>
<td><code>awal konversi</code></td>
<td>🔀 Re-Platforming</td>
<td>Migrasi stack lama ke baru. Legacy audit → Wizard 7-poin → Strangler Fig 9-fase.</td>
</tr>
<tr>
<td><code>baca error</code></td>
<td>🔥 YOLO Debug</td>
<td>Full codebase scan → <code>issues.md</code> → Mandor Approval Gate sebelum fix.</td>
</tr>
<tr>
<td><code>tambah fitur</code></td>
<td>➕ Incremental Add</td>
<td>Tambah fitur tanpa wawancara ulang. Konflik detection + scope guard.</td>
</tr>
<tr>
<td><code>lanjut dari sini</code></td>
<td>🔁 Context Recovery</td>
<td>Reconstruct state saat context window terpotong di tengah sesi.</td>
</tr>
<tr>
<td><code>status proyek</code></td>
<td>📊 Quick Brief</td>
<td>Laporan 10-baris: progres, kompilasi, port, issues. Lalu STOP.</td>
</tr>
<tr>
<td><code>analisa kualitas</code></td>
<td>🔍 Code Smell Scan</td>
<td>Audit kualitas kode: duplikasi, complexity, magic numbers. Output di <code>quality_review.md</code>.</td>
</tr>
<tr>
<td><code>analisa keamanan</code></td>
<td>🔒 Security Audit</td>
<td>Passive pentest: OWASP 5-kategori scan, dependency map, vulnerability documentation. Output di <code>security-audit.md</code>.</td>
</tr>
<tr>
<td><code>scan keamanan</code></td>
<td>🔒 Security Audit</td>
<td>Alias untuk <code>analisa keamanan</code>.</td>
</tr>
</table>

---

## 🔄 Alur Kerja Sistem

```mermaid
graph TD
    START([👤 Developer]) --> CMD{Perintah Makro?}

    CMD -- "awal baru" --> INIT[🧙 Wizard PRD\n10 Pertanyaan Linier]
    INIT --> PRD[📄 Generate prd.md\n+ todo.md]
    PRD --> PHASE[🏗️ Fase Koding\n6 Fase / 9 Fase Konversi]

    CMD -- "awal lanjut" --> RESTORE[🔁 State Restoring\nBaca prd + todo + handover\n+ /.legacy/ jika konversi aktif]
    RESTORE --> PHASE

    CMD -- "awal konversi" --> WIZARD[🔀 Wizard Konversi\n6 Pertanyaan Stack Migration]
    WIZARD --> LEGACY[📦 Legacy Isolation\nke folder /.legacy/]
    LEGACY --> PHASE

    PHASE --> TASK{✅ 5-6 Sub-task\nSelesai?}
    TASK -- Ya --> HANDOVER[📝 Auto-update\nhandover.md\n+ Safe Git Commit]
    HANDOVER --> PHASE

    PHASE --> BUG{🐛 Error Ditemukan?}
    BUG -- "baca error" --> SCAN[🔍 Full Codebase Scan\nTulis /.docs/issues.md]
    SCAN --> GATE[🚦 Mandor Approval Gate\nAI Berhenti — Tunggu Izin]
    GATE -- Disetujui --> FIX[🔧 Fix Loop\nRetry max 3x]
    FIX --> ITSA[🛡️ IT Scan Assessment\n5 Lapisan Keamanan]
    ITSA --> PHASE

    BUG -- Tidak --> PHASE
```

---

## 📊 Kenapa Brainvibes? (Comparison Matrix)

| Fitur | ✅ Dengan Brainvibes | ❌ Tanpa Brainvibes |
| :--- | :--- | :--- |
| **Konsistensi Desain Visual** | Premium & konsisten. *Tonal Preservation Matrix* — Light Mode mempertahankan DNA warna asli palet. Dark Mode = Deep Tonal dari spektrum yang sama. | AI hardcode `#FFF` / `#000` hambar, teks abu-abu di atas latar abu-abu, risiko teks tak terbaca tinggi. |
| **Keamanan Kredensial Git** | Auto-unstage `.env*`, `handover.md`, DB lokal, kredensial JSON sebelum **setiap** commit — otomatis, tanpa perlu ingat. | File rahasia sering ter-push ke GitHub publik secara tidak sengaja. |
| **Debugging (YOLO Mode)** | Sistematis: jurnal retry `issues.md`, batas 3x percobaan, rollback `git clean`, zombie port release, mock API fallback, ITSA pasca-fix. | AI looping tanpa batas, stderr tersembunyi ke null, port bentrok dibiarkan hang. |
| **Ingatan Antar Sesi (State)** | Nol amnesia. `handover.md` dengan FIFO rolling buffer 100 baris — AI berikutnya langsung tahu status, port aktif, dan komponen terpasang. | Saat token context penuh, AI lupa rute halaman yang sudah dibuat dan menulis ulang komponen (code bloating). |
| **Perencanaan Proyek** | Wizard PRD linier 1-per-giliran. Kode baru ditulis **setelah** PRD disetujui. Zero-Fluff Filter aktif. | AI langsung koding tanpa rencana, asumsi arsitektur sepihak, 10 pertanyaan sekaligus dalam satu chat. |
| **Mode Konversi Stack** | Strangler Fig Pattern: isolasi `/.legacy/`, 9-fase atomik, Git checkpoint per fase, Legacy Purge Gate dengan dry-run log. | Tidak ada pola terstruktur — migrasi ad-hoc, rawan fitur terlewat dan data hilang. |
| **Arsitektur & Kepatuhan Kode** | Strict layer separation (Presentation → Logic → Data), ACID transaction guard, Lazy Loading ekspor, Zero-Dead-End Link Policy. | Spaghetti code, query DB langsung dari UI, link mati `href="#"`, bundle size membengkak. |

---

## 🛡️ Fitur Keamanan Unggulan

```
┌─────────────────────────────────────────────────────────┐
│              5 LAPISAN SCAN KELAYAKAN (ITSA)            │
├─────────┬───────────────────────────────────────────────┤
│ Layer 1 │ Linting Check — ESLint / PHP Pint / Prettier  │
│ Layer 2 │ Deep Scan Type-Safety — Compiler strict mode  │
│ Layer 3 │ SAST Analysis — Celah dependensi & hardcoded  │
│         │ secret detection                              │
│ Layer 4 │ Form Input Validation Guard — Anti SQL Inject │
│         │ & XSS, Rate Limiting 5 attempts / 15 menit   │
│ Layer 5 │ Auth Integrity Verification — Session/JWT     │
│         │ lifecycle check + Route Guard 3-Zona          │
└─────────┴───────────────────────────────────────────────┘
```

---

## 🎨 15 Master Palet Warna 2026

Brainvibes menyertakan sistem pemilihan palet warna bertingkat yang dikunci ke dalam **CSS Custom Properties (`--vibe-*`)** dan divalidasi secara kontras (`min ratio 4.5:1`) sebelum ditulis ke disk:

| Cluster | Nama Palet | Karakter |
| :--- | :--- | :--- |
| 🌑 Gelap | Obsidian Forge, Cyber Industrial, Carbon Slate | Dark-first, kontras ekstrem |
| 🌿 Alam | Forest Sage, Earthy Terracotta, Ocean Teal | Organik, hangat, tenang |
| ☀️ Terang | Ivory Cream, Arctic White, Lavender Mist | Minimalis, bersih, terang |
| 🔥 Vibrant | Neon Pulse, KTM Orange, Kawasaki Green, Cobalt Blue | Streetwear, berani, saturasi tinggi |
| ⚖️ Netral | Corporate Slate, Graphite Professional | Formal, enterprise, korporat |

> Jika memilih opsi **RANDOM**, nama kluster pemenang akan dicetak ke terminal saat serah terima `prd.md`.

---

## 📁 Struktur Direktori Proyek Yang Dihasilkan

```
/[nama-proyek]/
├── /.docs/                 ← Pusat dokumentasi teknis inti (wajib ada)
│   ├── architecture.md     ← Aliran data makro (Presentation → Logic → DB)
│   ├── api-spec.md         ← Spesifikasi endpoint & server actions
│   ├── database.md         ← Schema DDL SQL / Local JSON State blueprint
│   ├── quality_review.md   ← Hasil audit linter, code smells, complexity
│   ├── routes.md           ← Peta routes aktif (Frontend & API)
│   ├── dependency-graph.md ← Analisis import, critical files, circular deps
│   └── issues.md           ← Bug tracker FIFO (max 10 resolved, OPEN wajib dipertahankan)
├── /.scratchpad/            ← Zona debug terisolasi (Git-Ignored otomatis)
├── /src/ atau /app/         ← Source code aplikasi utama
├── /public/ atau /assets/   ← Aset statis + fallback image WebP
├── .env                     ← Konfigurasi sensitif (tidak pernah masuk Git)
├── .env.example             ← Template kunci tanpa nilai asli
├── .gitignore               ← Proteksi otomatis sejak detik pertama proyek
├── app-context.md           ← State tracker cepat AI-optimized (Git-Ignored)
├── handover.md              ← State tracker harian human-readable (Git-Ignored)
├── prd.md                   ← Dokumen spesifikasi proyek (Git-Ignored)
└── todo.md                  ← Checklist koding berjenjang (Git-Ignored)
```

---

## 📈 Riwayat Versi & Changelog

| Versi | Commit | Ringkasan Perubahan |
| :--- | :--- | :--- |
| `v4.0.0` | [Current] | **Split Architecture & Memory Protocol Sync**: Pemisahan `gemini.md` 146KB monolith menjadi 3 tier (gemini.md core ≤22KB, gemini-execution.md, gemini-templates.md) untuk mengatasi limitasi context window AI (truncation 83.6%). Mengintegrasikan 3 gap unik Memory-system-instruction (`routes.md`, `dependency-graph.md`, dan `§FLOWS` di `app-context-template.md`). |
| `v2.3.0` | [`a1b2c3d`](https://github.com/Noisesless/brainvibes/commit/a1b2c3d) | **Visual Output Gate & Anti-Slop UI Enforcement**: Mengubah mekanisme pemicuan taste-skill dari kata kunci (input-based) menjadi tipe output (output-based). Menambahkan 4 aturan Anti-AI-SLOP baru: larangan ikon SVG mentah, larangan border/hiasan pada logo, larangan mencampur pustaka ikon, serta kewajiban rekomendasi style sesuai Visual DNA sebelum koding. |
| `v2.0.0` | [`8fcf799`](https://github.com/Noisesless/brainvibes/commit/8fcf799) | Fix 8 celah lanjutan: rename `## 2. Environment & Local Settings`, standardisasi log `## 10.`, tutup unclosed code block, deteksi `/.legacy/` untuk konversi, ASCII tree kondisional, cross-ref Section 11→6D |
| `v1.9.0` | [`d588ac1`](https://github.com/Noisesless/brainvibes/commit/d588ac1) | Fix 7 konflik `awal konversi`: wizard 6-langkah, 9-fase atomik, klarifikasi `git mv` vs filesystem move, tracking `/.legacy/`, kolom Status Porting Section 11, handover trigger, Git checkpoint per fase |
| `v1.8.0` | [`bba7771`](https://github.com/Noisesless/brainvibes/commit/bba7771) | Hardened `baca error`: port sync API, linter auto-fix trap, db lock clearance, static frontend bypass |
| `v1.7.0` | [`5a6f93f`](https://github.com/Noisesless/brainvibes/commit/5a6f93f) | Integrasi ITSA post-fix assessment ke mode `baca error` |


---

## 🤝 Kontribusi

Pull request dan issue sangat disambut! Jika kamu menemukan celah instruksi, konflik logika, atau ingin menambahkan dukungan framework baru ke dalam template, silakan buka **Issue** terlebih dahulu untuk diskusi.

```
1. Fork repositori ini
2. Buat branch fitur: git checkout -b feat/nama-fitur-kamu
3. Commit perubahan: git commit -m "feat: deskripsi perubahan"
4. Push ke branch: git push origin feat/nama-fitur-kamu
5. Buka Pull Request ke branch main
```

---

<div align="center">

**Dibuat dengan ☕ dan obsesi terhadap kode yang rapi.**

[![GitHub Stars](https://img.shields.io/github/stars/Noisesless/brainvibes?style=social)](https://github.com/Noisesless/brainvibes)
[![GitHub Forks](https://img.shields.io/github/forks/Noisesless/brainvibes?style=social)](https://github.com/Noisesless/brainvibes/fork)

*Brainvibes — karena AI yang baik butuh instruksi yang lebih baik.*

</div>
