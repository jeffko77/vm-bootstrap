#!/usr/bin/env bash

# Detect if running in WSL (Windows Subsystem for Linux)

is_wsl() {
    grep -qi "microsoft" /proc/version 2>/dev/null
}

if is_wsl; then
    echo "WSL detected"
    exit 0
else
    echo "Not running in WSL"
    exit 1
fi
