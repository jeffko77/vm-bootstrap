#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

configure_git_auth() {
    log "Setting up GitHub authentication"
    
    if [ -f ~/.git-credentials ]; then
        log_warning "Git credentials already exist"
        read -p "Do you want to update them? (y/N): " update_creds
        if [[ ! "$update_creds" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    echo ""
    echo "You can create a GitHub Personal Access Token at:"
    echo "https://github.com/settings/tokens"
    echo ""
    read -p "Enter your GitHub Personal Access Token (or press Enter to skip): " GITHUB_TOKEN
    
    if [ -z "$GITHUB_TOKEN" ]; then
        log_warning "Skipping GitHub authentication setup"
        return 0
    fi
    
    git config --global credential.helper store
    echo "https://$GITHUB_TOKEN:@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    
    log_success "GitHub authentication configured successfully"
}

configure_git_auth
