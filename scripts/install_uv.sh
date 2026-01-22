#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_uv() {
    log "Installing uv (Python package manager)"
    
    if command_exists uv; then
        log_warning "uv already installed"
        uv --version
        return 0
    fi
    
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add to PATH
    export UV_INSTALL="$HOME/.local/bin"
    export PATH="$UV_INSTALL:$PATH"
    
    add_to_bashrc 'export UV_INSTALL="$HOME/.local/bin"'
    add_to_bashrc 'export PATH="$UV_INSTALL:$PATH"'
    
    log_success "uv installed successfully"
    "$HOME/.local/bin/uv" --version || true
}

install_uv
