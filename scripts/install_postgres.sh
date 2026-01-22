#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_postgres_tools() {
    log "Installing PostgreSQL client tools"
    
    if command_exists psql; then
        log_warning "PostgreSQL client already installed"
        psql --version
        return 0
    fi
    
    # Install PostgreSQL client based on package manager
    case "$PKG_MANAGER" in
        apt)
            pkg_update
            pkg_install postgresql-client
            ;;
        dnf|yum)
            pkg_update
            pkg_install postgresql
            ;;
        pacman)
            pkg_install postgresql
            ;;
        zypper)
            pkg_install postgresql
            ;;
        *)
            log_error "Unsupported package manager for PostgreSQL: $PKG_MANAGER"
            return 1
            ;;
    esac
    
    log_success "PostgreSQL client tools installed successfully"
    psql --version
}

install_postgres_tools
