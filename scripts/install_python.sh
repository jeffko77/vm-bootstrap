#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

install_python() {
    log "Installing Python 3.13"
    
    if command_exists python3.13; then
        log_warning "Python 3.13 already installed"
        python3.13 --version
        return 0
    fi
    
    # Add deadsnakes PPA for Python 3.13
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt update -y
    sudo apt install -y python3.13 python3.13-venv python3.13-dev
    
    log "Setting python3 → python3.13"
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1
    sudo update-alternatives --set python3 /usr/bin/python3.13
    
    log "Installing pip for Python 3.13"
    curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.13
    
    log_success "Python 3.13 installed successfully"
    python3 --version
}

install_python
