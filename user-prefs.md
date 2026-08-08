# USER GLOBAL PREFERENCES
# Dibaca AI secara SILENT di setiap sesi baru — PRIORITAS TERTINGGI sebelum gemini.md
# Format: parameter = nilai | komentar setelah #
# AI FORBIDDEN mengubah file ini tanpa instruksi eksplisit user

[IDENTITY]
user_language      = id-ID                        # Bahasa interaksi ke user
fallback_lang      = en-US                        # Fallback untuk istilah teknis
user_name          = GBC_PC                       # Username mesin lokal

[DEVELOPMENT]
default_port_vite  = 5173                         # Default Vite/React dev server
default_port_next  = 3100                         # Default Next.js dev server
default_port_php   = 8080                         # Default PHP/Laravel dev server
package_manager    = npm                          # npm | pnpm | yarn | bun
local_server       = XAMPP Apache                 # Server lokal yang digunakan
local_base_path    = C:\xampp\htdocs\             # Base path XAMPP
db_engine          = MySQL                        # Database engine default

[DESIGN_DEFAULTS]
default_font_heading = Geist                         # Font heading default (wajib berbeda dari body)
default_font_body    = Inter                         # Font body default
# CATATAN: AI FORBIDDEN menggunakan 1 font saja. Selalu gunakan heading+body pairing.
default_palette    = UUPM-auto                    # UUPM-auto | random | [nomor 1-15]
default_geometry   = Rounded                      # Sharp | Rounded | Pill
dark_mode_default  = Dynamic Toggle Switch        # Static Light | Static Dark | Dynamic Toggle Switch
mobile_nav_default = Bottom Tab Bar               # Bottom Tab Bar | Floating Header
color_switcher     = Tidak Aktif                  # Aktif | Tidak Aktif

[HOSTING]
default_target     = Local XAMPP Apache Sub-folder
default_domain     = localhost

[AI_BEHAVIOR]
output_mode        = COMPACT                      # VERBOSE | COMPACT | AUTO
response_style     = CONCISE                      # CONCISE (max 3-5 baris) | COMPACT | VERBOSE
uupm_auto_run      = true                         # Jalankan UUPM search otomatis (awal baru & redesign)
taste_skill_auto   = true                         # Auto-trigger taste-skill-bridge saat redesign/buat halaman
anti_slop_mode     = HARD                         # HARD (semua anti-slop rules aktif) | SOFT
security_aware     = true                         # Enable silent security pattern read saat coding auth/db/input/upload
security_reminder  = true                         # Enable milestone security reminder (pasif, per fase)
max_files_per_turn = 5                            # Batas file dibuka AI per turn (token guard)
max_lines_per_read = 200                          # Batas baris per view_file call (token guard)

# Context Budget Settings (Smart Context Loading)
context_budget_7b  = 5000                         # Max tokens untuk model 7B-13B context (default 5K)
context_budget_32k = 25000                        # Max tokens untuk model 32K context (default 25K)
context_budget_128k = 100000                      # Max tokens untuk model 128K context (default 100K)
context_budget_warn = 20000                       # Warn saat used tokens melebihi ini
context_budget_stop = 28000                       # STOP dan tanya user saat used tokens melebihi ini
context_budget_tracker = true                     # Enable [CONTEXT BUDGET] output per session
context_budget_per_trigger = true                 # Enable per-trigger token estimation

# Library yang SELALU di-query via context7 tanpa instruksi eksplisit:
context7_whitelist = next.js, laravel, tailwindcss, react, astro, vue, php, mysql, axios
# Library yang SKIP dari context7 auto-query (timeout/tidak relevan):
context7_blacklist = bootstrap, jquery, wordpress

[SESSION_PROTOCOL]
read_app_context_first = true                     # Selalu baca app-context.md sebelum prd.md
handover_trigger       = 5                        # Update handover setiap N sub-task selesai

[BROWSER_TOOL]
browser_gate       = STRICT                       # STRICT | PERMISSIVE — STRICT: wajib justifikasi
dom_read_default   = read_url                     # read_url | browser_subagent — default cek DOM
recording_default  = OFF                          # ON | OFF — auto-record browser session
scratchpad_dom     = FORBIDDEN                    # FORBIDDEN | ALLOWED — scratchpad DOM via browser

[COMMIT_BEHAVIOR]
auto_unstage_env   = true                         # Auto unstage .env* sebelum commit
auto_unstage_ai    = true                         # Auto unstage handover.md, prd.md, app-context.md
commit_style       = conventional                 # conventional | simple — format pesan commit
sign_commits       = false                        # GPG signing on/off

[NOTIFICATION]
milestone_banner   = true                         # Cetak [🔒 Milestone selesai] per fase
drift_alert        = true                         # Cetak [HANDOVER DRIFT DETECTED] jika state mismatch
browser_gate_log   = true                         # Cetak [Browser Gate] saat pakai browser tool
self_check_log     = true                         # Cetak [SELF-CHECK] setelah setiap task selesai

[ACTION_BEHAVIOR]
ask_before_assume  = true                         # AI wajib tanya jika ragu, jangan asumsi
technical_debate   = true                         # AI boleh sanggah user dengan data faktual
web_search_enabled = true                         # Aktifkan web search via MCP saat answer tidak tersedia
fabrication_guard  = true                         # FORBIDDEN mengarang solusi/fakta/referensi yang tidak pasti






[META]
brainvibes_version = 4.1.0
installed_at       = 2026-07-13
last_updated       = 2026-07-17
changelog          = v4.0.0 — Efficiency Intelligence (10 gap fixed), Smart Skill Integration (SSI), auto .docs update
