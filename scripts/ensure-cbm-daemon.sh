#!/usr/bin/env bash
# ensure-cbm-daemon.sh — Ensure codebase-memory daemon is running on port 9749
# Port dari ensure-cbm-daemon.ps1 untuk Linux

PORT="${1:-9749}"
CBM_BIN=$(command -v codebase-memory-mcp 2>/dev/null || true)

# Warna
GREEN='\033[0;32m'
GRAY='\033[0;90m'
YELLOW='\033[0;33m'
NC='\033[0m'

test_port_listening() {
    local port="$1"
    if command -v ss &>/dev/null; then
        ss -tlnp 2>/dev/null | grep -q ":${port} "
    elif command -v nc &>/dev/null; then
        nc -z 127.0.0.1 "$port" 2>/dev/null
    else
        (echo >/dev/tcp/127.0.0.1/$port) 2>/dev/null
    fi
}

if ! test_port_listening "$PORT"; then
    if [[ -n "$CBM_BIN" ]]; then
        nohup "$CBM_BIN" daemon start &>/dev/null &
        echo -e "${GREEN}[+] codebase-memory-mcp daemon started on port $PORT${NC}"
    else
        echo -e "${YELLOW}[WARN] codebase-memory-mcp tidak ditemukan di PATH${NC}"
    fi
else
    echo -e "${GRAY}[OK] codebase-memory-mcp daemon already running on port $PORT${NC}"
fi
