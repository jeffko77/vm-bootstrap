#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

install_postgres_tools() {
    log "Installing PostgreSQL client tools"
    
    if command_exists psql; then
        log_warning "PostgreSQL client already installed"
        psql --version
        return 0
    fi
    
    sudo apt update -y
    sudo apt install -y postgresql-client
    
    log_success "PostgreSQL client tools installed successfully"
    psql --version
}

install_postgres_tools
