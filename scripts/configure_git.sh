#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

configure_git() {
    log "Configuring Git identity"
    
    # Check if git config already has user.name
    if git config --global user.name &>/dev/null; then
        log_warning "Git user.name already set: $(git config --global user.name)"
        read -p "Do you want to update it? (y/N): " update_name
        if [[ ! "$update_name" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    read -p "Enter your Git name: " git_name
    read -p "Enter your Git email: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    
    # Additional useful git configs
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor "nano"
    
    log_success "Git configured with name: $git_name, email: $git_email"
}

configure_git
