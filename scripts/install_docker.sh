#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_docker_cli() {
    log "Installing Docker CLI"
    
    if command_exists docker; then
        log_warning "Docker already installed"
        docker --version
        return 0
    fi
    
    # Install Docker based on package manager
    case "$PKG_MANAGER" in
        apt)
            pkg_update
            pkg_install docker.io
            ;;
        dnf|yum)
            pkg_update
            pkg_install docker
            ;;
        pacman)
            pkg_install docker
            ;;
        zypper)
            pkg_install docker
            ;;
        *)
            log_error "Unsupported package manager for Docker: $PKG_MANAGER"
            return 1
            ;;
    esac
    
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
