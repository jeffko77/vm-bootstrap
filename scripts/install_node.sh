#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_nvm_node() {
    log "Installing Node.js via NVM"
    
    # Check if NVM is already installed
    if [ -d "$HOME/.nvm" ]; then
        log_warning "NVM already installed"
    else
        log "Installing NVM"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install latest LTS (stable) Node.js
    log "Installing latest LTS (stable) Node.js"
    nvm install --lts
    nvm alias default lts/*
    
    log_success "Node.js installed successfully"
    node --version
    npm --version
}

install_nvm_node
