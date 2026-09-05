#!/usr/bin/env bash
# cbm-hook.sh — Antigravity IDE Lifecycle Hook for codebase-memory daemon
# Ensures port 9749 is alive, returns valid JSON to stdout
# Port dari cbm-hook.ps1 untuk Linux

PORT=9749
CBM_BIN=$(command -v codebase-memory-mcp 2>/dev/null || true)

# Cek apakah port 9749 sedang listening
is_connected=false
if command -v ss &>/dev/null; then
    if ss -tlnp 2>/dev/null | grep -q ":${PORT} "; then
        is_connected=true
    fi
elif command -v nc &>/dev/null; then
    if nc -z 127.0.0.1 "$PORT" 2>/dev/null; then
        is_connected=true
    fi
else
    # Fallback: /dev/tcp
    if (echo >/dev/tcp/127.0.0.1/$PORT) 2>/dev/null; then
        is_connected=true
    fi
fi

if [[ "$is_connected" == "false" && -n "$CBM_BIN" ]]; then
    nohup "$CBM_BIN" daemon start &>/dev/null &
fi

# Output valid JSON contract for Antigravity hook
echo "{}"
