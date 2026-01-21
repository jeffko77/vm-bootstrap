#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

install_editor_helpers() {
    log "Adding editor helpers and aliases"
    
    # Cursor alias for WSL
    if is_wsl; then
        add_to_bashrc 'alias cursor="cursor.exe"'
        add_to_bashrc 'alias code="code.exe"'
    fi
    
    # Add common editor aliases
    add_to_bashrc 'alias c="cursor"'
    add_to_bashrc 'alias v="code"'
    
    # Set default editor
    add_to_bashrc 'export EDITOR="nano"'
    add_to_bashrc 'export VISUAL="nano"'
    
    # Add common development aliases
    add_to_bashrc 'alias ll="ls -lah"'
    add_to_bashrc 'alias la="ls -A"'
    add_to_bashrc 'alias l="ls -CF"'
    add_to_bashrc 'alias ..="cd .."'
    add_to_bashrc 'alias ...="cd ../.."'
    add_to_bashrc 'alias gs="git status"'
    add_to_bashrc 'alias gp="git pull"'
    add_to_bashrc 'alias gps="git push"'
    
    log_success "Editor helpers and aliases configured"
}

install_editor_helpers
