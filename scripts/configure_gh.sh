#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

configure_gh() {
    log "Configuring GitHub CLI authentication"
    
    if ! command_exists gh; then
        log_error "GitHub CLI (gh) is not installed. Please install it first."
        return 1
    fi
    
    # Check if already authenticated
    if gh auth status &>/dev/null; then
        log_warning "GitHub CLI is already authenticated"
        gh auth status
        read -p "Do you want to re-authenticate? (y/N): " reauth
        if [[ ! "$reauth" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    # Check for GITHUB_TOKEN environment variable first
    if [ -n "$GITHUB_TOKEN" ]; then
        log "Using GITHUB_TOKEN from environment"
        echo "$GITHUB_TOKEN" | gh auth login --with-token
        if [ $? -eq 0 ]; then
            log_success "GitHub CLI authenticated using GITHUB_TOKEN"
            gh auth status
            return 0
        else
            log_error "Failed to authenticate with GITHUB_TOKEN"
        fi
    fi
    
    # If no token in environment, prompt for it
    echo ""
    echo "GitHub CLI authentication required."
    echo "You can create a GitHub Personal Access Token at:"
    echo "https://github.com/settings/tokens"
    echo ""
    echo "Required scopes: repo, read:org, read:user, user:email"
    echo ""
    echo "Alternatively, set GITHUB_TOKEN environment variable before running:"
    echo "  export GITHUB_TOKEN=your_token_here"
    echo ""
    read -p "Enter your GitHub Personal Access Token (or press Enter to skip): " token
    
    if [ -z "$token" ]; then
        log_warning "Skipping GitHub CLI authentication"
        echo ""
        echo "You can authenticate later by running:"
        echo "  gh auth login"
        echo ""
        return 0
    fi
    
    # Authenticate with the token
    echo "$token" | gh auth login --with-token
    if [ $? -eq 0 ]; then
        log_success "GitHub CLI authenticated successfully"
        gh auth status
    else
        log_error "Failed to authenticate GitHub CLI"
        return 1
    fi
}

configure_gh
