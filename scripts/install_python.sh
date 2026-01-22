#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_python() {
    log "Installing Python 3"
    
    # Check if Python 3 is already installed
    if command_exists python3; then
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
        log_warning "Python $PYTHON_VERSION already installed"
        python3 --version
        # Install pip if not present
        if ! command_exists pip3; then
            log "Installing pip"
            curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
        fi
        return 0
    fi
    
    # Install Python based on package manager
    case "$PKG_MANAGER" in
        apt)
            log "Installing Python 3.13 via deadsnakes PPA"
            sudo add-apt-repository -y ppa:deadsnakes/ppa
            pkg_update
            pkg_install python3.13 python3.13-venv python3.13-dev
            sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1
            sudo update-alternatives --set python3 /usr/bin/python3.13
            PYTHON_CMD="python3.13"
            ;;
        dnf|yum)
            log "Installing Python 3 from EPEL/repositories"
            # Enable EPEL for additional packages
            if [ "$PKG_MANAGER" = "dnf" ]; then
                pkg_install epel-release || true
            else
                pkg_install epel-release || pkg_install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm || true
            fi
            pkg_update
            # Install latest available Python 3
            pkg_install python3 python3-pip python3-devel
            PYTHON_CMD="python3"
            ;;
        pacman)
            pkg_install python python-pip
            PYTHON_CMD="python"
            ;;
        zypper)
            pkg_install python3 python3-pip python3-devel
            PYTHON_CMD="python3"
            ;;
        *)
            log_error "Unsupported package manager: $PKG_MANAGER"
            return 1
            ;;
    esac
    
    # Install pip if not installed
    if ! command_exists pip3; then
        log "Installing pip"
        curl -sS https://bootstrap.pypa.io/get-pip.py | sudo $PYTHON_CMD
    fi
    
    log_success "Python installed successfully"
    python3 --version
    pip3 --version
}

install_python
