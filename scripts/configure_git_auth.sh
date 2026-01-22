#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

configure_git_auth() {
    log "Setting up GitHub authentication"
    
    # Check for GITHUB_TOKEN environment variable first
    local token="$GITHUB_TOKEN"
    
    if [ -f ~/.git-credentials ]; then
        log_warning "Git credentials already exist"
        if [ -z "$token" ]; then
            read -p "Do you want to update them? (y/N): " update_creds
            if [[ ! "$update_creds" =~ ^[Yy]$ ]]; then
                return 0
            fi
        fi
    fi
    
    # If no token in environment, prompt for it
    if [ -z "$token" ]; then
        echo ""
        echo "You can create a GitHub Personal Access Token at:"
        echo "https://github.com/settings/tokens"
        echo ""
        echo "Alternatively, set GITHUB_TOKEN environment variable before running:"
        echo "  export GITHUB_TOKEN=your_token_here"
        echo ""
        read -p "Enter your GitHub Personal Access Token (or press Enter to skip): " token
    else
        log "Using GITHUB_TOKEN from environment"
    fi
    
    if [ -z "$token" ]; then
        log_warning "Skipping GitHub authentication setup"
        return 0
    fi
    
    git config --global credential.helper store
    echo "https://$token:@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    
    log_success "GitHub authentication configured successfully"
}

configure_git_auth
