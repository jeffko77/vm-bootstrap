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
        # Install pip if not present using package manager
        if ! command_exists pip3; then
            log "Installing pip via package manager"
            case "$PKG_MANAGER" in
                apt)
                    pkg_install python3-pip
                    ;;
                dnf|yum)
                    pkg_install python3-pip
                    ;;
                pacman)
                    pkg_install python-pip
                    ;;
                zypper)
                    pkg_install python3-pip
                    ;;
                *)
                    log_warning "Could not install pip via package manager. You may need to install it manually."
                    ;;
            esac
        fi
        return 0
    fi
    
    # Install Python based on package manager
    case "$PKG_MANAGER" in
        apt)
            log "Installing latest stable Python 3 from system repositories"
            pkg_install python3 python3-pip python3-venv python3-dev
            PYTHON_CMD="python3"
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
    
    # Verify pip is installed
    if ! command_exists pip3; then
        log_warning "pip3 not found after installation. Attempting to install via ensurepip..."
        # Try ensurepip as a fallback
        if python3 -m ensurepip --version &>/dev/null; then
            OUTPUT=$(sudo python3 -m ensurepip --upgrade 2>&1) || true
            if echo "$OUTPUT" | grep -q "externally-managed-environment"; then
                log_warning "System Python detected. Please install pip via package manager: sudo apt install python3-pip"
            fi
        else
            log_warning "ensurepip not available. pip3 may need to be installed manually."
        fi
    fi
    
    log_success "Python installed successfully"
    python3 --version
    pip3 --version
}

install_python
