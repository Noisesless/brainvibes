#!/usr/bin/env bash
# sync.sh — Brainvibes Auto-Sync Script (Linux)
# Port dari sync.ps1 untuk Linux/macOS
# Jalankan script ini untuk menyinkronkan file master dari workspace ke folder global AI.

set -euo pipefail

# Warna output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;90m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Tentukan path sumber dan target
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEMINI_TARGET_DIR="$HOME/.gemini"
KNOWLEDGE_TARGET_DIR="$GEMINI_TARGET_DIR/antigravity-ide/knowledge"

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   BRAINVIBES AUTO-SYNC SYSTEM (Linux)   ${NC}"
echo -e "${CYAN}=========================================${NC}"
echo "Sumber (Master) : $SOURCE_DIR"
echo "Target (Gemini) : $GEMINI_TARGET_DIR"
echo "-----------------------------------------"

# Pastikan folder target ada
mkdir -p "$GEMINI_TARGET_DIR"
mkdir -p "$KNOWLEDGE_TARGET_DIR"
mkdir -p "$GEMINI_TARGET_DIR/config/skills"
mkdir -p "$GEMINI_TARGET_DIR/config/scripts"

# 1. Salin berkas-berkas inti di root ke .gemini
CORE_FILES=("gemini.md" "gemini-execution.md" "gemini-templates.md" "prd-template.md" "design-system.md" "AGENTS.md" "user-prefs.md")
for file in "${CORE_FILES[@]}"; do
    src="$SOURCE_DIR/$file"
    dst="$GEMINI_TARGET_DIR/$file"
    if [[ -f "$src" ]]; then
        cp -f "$src" "$dst"
        echo -e "${GRAY}[OK] Menyalin $file -> $dst${NC}"
    else
        echo -e "${YELLOW}[WARN] File tidak ditemukan di sumber: $src${NC}"
    fi
done

# Pastikan GEMINI.md (UPPERCASE) tersedia untuk Linux case-sensitivity
if [[ -f "$GEMINI_TARGET_DIR/gemini.md" ]]; then
    cp -f "$GEMINI_TARGET_DIR/gemini.md" "$GEMINI_TARGET_DIR/GEMINI.md"
    echo -e "${GRAY}[OK] Sinkronisasi alias GEMINI.md (UPPERCASE)${NC}"
fi

# 2. Salin folder config secara rekursif ke .gemini/config
SRC_CONFIG="$SOURCE_DIR/config"
DST_CONFIG="$GEMINI_TARGET_DIR/config"
if [[ -d "$SRC_CONFIG" ]]; then
    echo -e "${YELLOW}[i] Menyalin folder config secara rekursif...${NC}"
    rsync -a --update "$SRC_CONFIG/" "$DST_CONFIG/"
    echo -e "${GREEN}[OK] Folder config tersinkronisasi.${NC}"
fi

# 3. Salin folder knowledge secara rekursif ke antigravity-ide/knowledge
SRC_KNOWLEDGE="$SOURCE_DIR/knowledge"
if [[ -d "$SRC_KNOWLEDGE" ]]; then
    echo -e "${YELLOW}[i] Menyalin folder knowledge secara rekursif...${NC}"
    rsync -a --update "$SRC_KNOWLEDGE/" "$KNOWLEDGE_TARGET_DIR/"
    echo -e "${GREEN}[OK] Folder knowledge tersinkronisasi.${NC}"
fi

# 8. Merge mcpConfig dari mcp_config.json ke settings.json (untuk Gemini)
MCP_CONFIG_SRC="$SOURCE_DIR/config/mcp_config.json"
SETTINGS_FILE="$GEMINI_TARGET_DIR/settings.json"

if [[ -f "$MCP_CONFIG_SRC" ]]; then
    echo -e "${YELLOW}[i] Merging MCP config ke settings.json...${NC}"

    # Buat settings.json jika belum ada
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        echo '{}' > "$SETTINGS_FILE"
        echo -e "${GREEN}[+] Membuat settings.json baru${NC}"
    fi

    if command -v jq &> /dev/null; then
        # Cek apakah format baru (mcp) atau lama (mcpServers)
        if jq -e '.mcp' "$MCP_CONFIG_SRC" &>/dev/null; then
            # Format baru — merge key "mcp"
            MCP_SERVERS=$(jq '.mcp' "$MCP_CONFIG_SRC")
            UPDATED=$(jq --argjson mcp "$MCP_SERVERS" '.mcp = (.mcp // {}) * $mcp' "$SETTINGS_FILE")
            echo "$UPDATED" > "$SETTINGS_FILE"
            echo -e "${GREEN}[OK] MCP servers (format baru) berhasil di-sync ke settings.json${NC}"
        elif jq -e '.mcpServers' "$MCP_CONFIG_SRC" &>/dev/null; then
            # Format lama — merge key "mcpServers"
            MCP_SERVERS=$(jq '.mcpServers' "$MCP_CONFIG_SRC")
            UPDATED=$(jq --argjson mcp "$MCP_SERVERS" '.mcpServers = (.mcpServers // {}) * $mcp' "$SETTINGS_FILE")
            echo "$UPDATED" > "$SETTINGS_FILE"
            echo -e "${GREEN}[OK] MCP servers (format lama) berhasil di-merge ke settings.json${NC}"
        fi
    else
        echo -e "${YELLOW}[WARN] jq tidak ditemukan — skip MCP merge. Install: sudo pacman -S jq${NC}"
    fi
elif [[ ! -f "$MCP_CONFIG_SRC" ]]; then
    echo -e "${YELLOW}[WARN] mcp_config.json tidak ditemukan di sumber: $MCP_CONFIG_SRC${NC}"
fi

# 10. Codebase Memory Daemon & UI Auto-Start (Port 9749)
echo ""
echo -e "${YELLOW}[STEP 10] codebase-memory-mcp Daemon & UI Server${NC}"
ENSURE_SCRIPT="$SOURCE_DIR/scripts/ensure-cbm-daemon.sh"
if [[ -f "$ENSURE_SCRIPT" ]]; then
    bash "$ENSURE_SCRIPT"
else
    CBM_BIN=$(command -v codebase-memory-mcp 2>/dev/null || true)
    if [[ -n "$CBM_BIN" ]]; then
        nohup "$CBM_BIN" daemon start &>/dev/null &
        echo -e "${GREEN}[+] codebase-memory-mcp daemon started on port 9749${NC}"
    else
        echo -e "${GRAY}[INFO] codebase-memory-mcp tidak ditemukan — skip daemon start${NC}"
    fi
fi

echo "-----------------------------------------"
echo -e "${GREEN}[SUKSES] Sinkronisasi master Brainvibes selesai!${NC}"
echo -e "${CYAN}=========================================${NC}"

# 9. Handover.md Archive Cleanup (Auto-cleanup > 30 days)
echo ""
echo -e "${YELLOW}[STEP 9] Handover.md Archive Cleanup${NC}"
ARCHIVE_DIR="$SOURCE_DIR/.archive"
if [[ -d "$ARCHIVE_DIR" ]]; then
    OLD_COUNT=$(find "$ARCHIVE_DIR" -name "handover-*.md" -mtime +30 2>/dev/null | wc -l)
    if [[ "$OLD_COUNT" -gt 0 ]]; then
        echo "  Found $OLD_COUNT archives > 30 days"
        find "$ARCHIVE_DIR" -name "handover-*.md" -mtime +30 -delete 2>/dev/null
        echo -e "${GREEN}  [OK] Old archives cleaned${NC}"
    else
        echo -e "${GRAY}  [OK] No old archives to clean${NC}"
    fi
else
    echo -e "${GRAY}  [INFO] No .archive folder found (skip)${NC}"
fi
