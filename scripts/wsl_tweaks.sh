#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

apply_wsl_tweaks() {
    log "Applying WSL-specific performance tweaks"
    
    # Configure /etc/wsl.conf
    log "Configuring /etc/wsl.conf"
    sudo tee /etc/wsl.conf >/dev/null <<'EOF'
[interop]
appendWindowsPath = false

[network]
generateResolvConf = false

[boot]
systemd = true
EOF
    
    # Configure DNS
    log "Configuring DNS to use Cloudflare (1.1.1.1)"
    sudo rm -f /etc/resolv.conf
    echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf >/dev/null
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf >/dev/null
    sudo chattr +i /etc/resolv.conf 2>/dev/null || true
    
    # Install WSL-specific tools
    log "Installing WSL-specific utilities"
    sudo apt update -y
    sudo apt install -y \
        wslu \
        unzip \
        zip
    
    log_success "WSL tweaks applied successfully"
    log_warning "You may need to restart WSL for all changes to take effect"
    log_warning "Run 'wsl.exe --shutdown' from PowerShell, then restart your terminal"
}

apply_wsl_tweaks
