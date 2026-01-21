#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

install_pnpm() {
    log "Installing pnpm"
    
    if command_exists pnpm; then
        log_warning "pnpm already installed"
        pnpm --version
        return 0
    fi
    
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    
    # Add pnpm to PATH
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    
    add_to_bashrc 'export PNPM_HOME="$HOME/.local/share/pnpm"'
    add_to_bashrc 'export PATH="$PNPM_HOME:$PATH"'
    
    log_success "pnpm installed successfully"
}

install_pnpm
