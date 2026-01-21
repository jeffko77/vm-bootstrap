#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

install_docker_cli() {
    log "Installing Docker CLI"
    
    if command_exists docker; then
        log_warning "Docker already installed"
        docker --version
        return 0
    fi
    
    # Install Docker
    sudo apt update -y
    sudo apt install -y docker.io
    
    # Add user to docker group
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker "$USER"
    
    # Enable Docker service (if not WSL)
    if ! is_wsl; then
        sudo systemctl enable docker
        sudo systemctl start docker
    fi
    
    log_success "Docker CLI installed successfully"
    log_warning "You may need to log out and back in for docker group changes to take effect"
    docker --version
}

install_docker_cli
