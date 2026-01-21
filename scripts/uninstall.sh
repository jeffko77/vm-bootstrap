#!/usr/bin/env bash
#
# Uninstall Bootstrap Components
# Removes all tools installed by the bootstrap script
#

source "$(dirname "$0")/common.sh"

log_warning "This will remove all tools installed by the bootstrap script"
read -p "Are you sure? (yes/NO): " confirm

if [ "$confirm" != "yes" ]; then
    log "Uninstall cancelled"
    exit 0
fi

log "Starting uninstall process"

# Python 3.13
if command_exists python3.13; then
    log "Removing Python 3.13"
    sudo apt remove -y python3.13
fi

# uv
if [ -f "$HOME/.local/bin/uv" ]; then
    log "Removing uv"
    rm -f "$HOME/.local/bin/uv"
fi

# NVM and Node.js
if [ -d "$HOME/.nvm" ]; then
    log "Removing NVM and Node.js"
    rm -rf "$HOME/.nvm"
fi

# pnpm
if [ -d "$HOME/.local/share/pnpm" ]; then
    log "Removing pnpm"
    rm -rf "$HOME/.local/share/pnpm"
fi

# Docker
if command_exists docker; then
    log "Removing Docker"
    sudo apt remove -y docker.io
fi

# PostgreSQL client
if command_exists psql; then
    log "Removing PostgreSQL client"
    sudo apt remove -y postgresql-client
fi

# flyctl
if [ -d "$HOME/.fly" ]; then
    log "Removing flyctl"
    rm -rf "$HOME/.fly"
fi

# Git credentials
if [ -f "$HOME/.git-credentials" ]; then
    log "Removing Git credentials"
    read -p "Remove Git credentials? (y/N): " remove_creds
    if [[ "$remove_creds" =~ ^[Yy]$ ]]; then
        rm -f "$HOME/.git-credentials"
        git config --global --unset credential.helper
    fi
fi

log_success "Uninstall complete"
log_warning "Note: ~/.bashrc modifications were not removed"
log_warning "You may want to manually review and clean ~/.bashrc"
