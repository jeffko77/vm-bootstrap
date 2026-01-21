#!/usr/bin/env bash
#
# Update All Installed Tools
# Updates system packages and development tools
#

source "$(dirname "$0")/common.sh"

log "Updating all development tools"

# System packages
log "Updating system packages"
sudo apt update -y
sudo apt upgrade -y
log_success "System packages updated"

# Python packages
if command_exists pip3; then
    log "Updating pip"
    python3 -m pip install --upgrade pip
    log_success "pip updated"
fi

# uv
if command_exists uv; then
    log "Updating uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    log_success "uv updated"
fi

# Node.js (update to latest)
if [ -d "$HOME/.nvm" ]; then
    log "Updating Node.js to latest"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node --reinstall-packages-from=node
    nvm alias default node
    log_success "Node.js updated"
fi

# pnpm
if command_exists pnpm; then
    log "Updating pnpm"
    pnpm add -g pnpm
    log_success "pnpm updated"
fi

# flyctl
if command_exists flyctl; then
    log "Updating flyctl"
    curl -L https://fly.io/install.sh | sh
    log_success "flyctl updated"
fi

log_success "All tools updated!"
echo ""
echo "Run the following to verify:"
echo "  bash scripts/verify_installation.sh"
