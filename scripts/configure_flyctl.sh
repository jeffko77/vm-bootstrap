#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

configure_flyctl() {
    log "Configuring Fly.io authentication"
    
    # Ensure flyctl is in PATH
    if [ -d "$HOME/.fly/bin" ]; then
        export PATH="$HOME/.fly/bin:$PATH"
    fi
    
    if ! command_exists flyctl; then
        log_error "flyctl is not installed. Please install it first."
        return 1
    fi
    
    # Check if already authenticated
    if flyctl auth whoami &>/dev/null; then
        log_warning "Fly.io is already authenticated"
        flyctl auth whoami
        read -p "Do you want to re-authenticate? (y/N): " reauth
        if [[ ! "$reauth" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    # Check for FLY_ACCESS_TOKEN or FLY_TOKEN environment variable first
    local token="${FLY_ACCESS_TOKEN:-${FLY_TOKEN}}"
    
    if [ -n "$token" ]; then
        log "Using Fly.io token from environment variable"
        # Ensure .fly directory exists
        mkdir -p "$HOME/.fly"
        # Write token to access_token file
        echo "$token" > "$HOME/.fly/access_token"
        chmod 600 "$HOME/.fly/access_token"
        # Also export for immediate use
        export FLY_ACCESS_TOKEN="$token"
        
        # Verify authentication
        if flyctl auth whoami &>/dev/null; then
            log_success "Fly.io authenticated using token from environment"
            flyctl auth whoami
            return 0
        else
            log_error "Failed to authenticate with provided token"
            rm -f "$HOME/.fly/access_token"
        fi
    fi
    
    # If no token in environment, prompt for it
    echo ""
    echo "Fly.io authentication required."
    echo "You can create a Fly.io Personal Access Token at:"
    echo "https://fly.io/user/personal_access_tokens"
    echo ""
    echo "Alternatively, set FLY_ACCESS_TOKEN or FLY_TOKEN environment variable before running:"
    echo "  export FLY_ACCESS_TOKEN=your_token_here"
    echo ""
    echo "Or use interactive login (opens browser):"
    echo "  flyctl auth login"
    echo ""
    read -p "Enter your Fly.io Personal Access Token (or press Enter to skip): " token
    
    if [ -z "$token" ]; then
        log_warning "Skipping Fly.io authentication"
        echo ""
        echo "You can authenticate later by running:"
        echo "  flyctl auth login"
        echo ""
        echo "Or set a token:"
        echo "  export FLY_ACCESS_TOKEN=your_token_here"
        echo "  flyctl auth whoami"
        echo ""
        return 0
    fi
    
    # Ensure .fly directory exists
    mkdir -p "$HOME/.fly"
    
    # Write token to access_token file
    echo "$token" > "$HOME/.fly/access_token"
    chmod 600 "$HOME/.fly/access_token"
    # Also export for immediate use
    export FLY_ACCESS_TOKEN="$token"
    
    # Verify authentication
    if flyctl auth whoami &>/dev/null; then
        log_success "Fly.io authenticated successfully"
        flyctl auth whoami
    else
        log_error "Failed to authenticate Fly.io. Please check your token."
        rm -f "$HOME/.fly/access_token"
        return 1
    fi
}

configure_flyctl
