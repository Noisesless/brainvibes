#!/usr/bin/env bash
# index-project.sh — Index repository and ensure 3D Graph UI on port 9749 (Linux)
# Port dari index-project.ps1 untuk Linux

set -euo pipefail

REPO_PATH="${1:-$(pwd)}"
MODE="${2:-full}"
CBM_BIN=$(command -v codebase-memory-mcp 2>/dev/null || true)

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}   BRAINVIBES CODEBASE INDEXER (Linux)   ${NC}"
echo -e "${CYAN}=========================================${NC}"
echo "Target Repository : $REPO_PATH"
echo "Index Mode        : $MODE"
echo "-----------------------------------------"

if [[ -z "$CBM_BIN" ]]; then
    echo -e "${YELLOW}[WARN] codebase-memory-mcp tidak ditemukan di PATH. Silakan install terlebih dahulu.${NC}"
    exit 1
fi

# 1. Pastikan daemon & port 9749 aktif
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAEMON_SCRIPT="$SCRIPT_DIR/ensure-cbm-daemon.sh"
if [[ -f "$DAEMON_SCRIPT" ]]; then
    bash "$DAEMON_SCRIPT"
else
    nohup "$CBM_BIN" daemon start &>/dev/null &
fi

# 2. Jalankan proses indexing
echo -e "${YELLOW}[i] Mengindeks repositori AST Knowledge Graph...${NC}"
"$CBM_BIN" cli --progress index_repository --repo-path "$REPO_PATH" --mode "$MODE"

echo -e "${GREEN}[OK] Pengindeksan berhasil selesai!${NC}"
echo -e "${CYAN}[UI] Graph visualization tersedia di: http://localhost:9749/${NC}"
echo -e "${CYAN}=========================================${NC}"
