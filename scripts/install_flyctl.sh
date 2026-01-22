#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_flyctl() {
    log "Installing flyctl (Fly.io CLI)"
    
    if command_exists flyctl; then
        log_warning "flyctl already installed"
        flyctl version
        return 0
    fi
    
    curl -L https://fly.io/install.sh | sh
    
    # Add to PATH
    export FLYCTL_INSTALL="$HOME/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"
    
    add_to_bashrc 'export FLYCTL_INSTALL="$HOME/.fly"'
    add_to_bashrc 'export PATH="$FLYCTL_INSTALL/bin:$PATH"'
    
    log_success "flyctl installed successfully"
    "$HOME/.fly/bin/flyctl" version || true
}

install_flyctl
