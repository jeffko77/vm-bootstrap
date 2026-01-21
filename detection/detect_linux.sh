#!/usr/bin/env bash

# Detect if running on Linux

is_linux() {
    [ "$(uname -s)" = "Linux" ]
}

if is_linux; then
    echo "Linux detected"
    echo "Distribution: $(lsb_release -d 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo "Kernel: $(uname -r)"
    exit 0
else
    echo "Not running on Linux"
    exit 1
fi
