#!/usr/bin/env bash

# Common functions and utilities for bootstrap scripts

##############################################
# Logging
##############################################
log() {
    echo -e "\n\033[1;34m=== $1 ===\033[0m\n"
}

log_success() {
    echo -e "\033[1;32m✓ $1\033[0m"
}

log_error() {
    echo -e "\033[1;31m✗ $1\033[0m"
}

log_warning() {
    echo -e "\033[1;33m⚠ $1\033[0m"
}

##############################################
# Utility Functions
##############################################
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

##############################################
# Environment Detection
##############################################
is_wsl() {
    grep -qi "microsoft" /proc/version 2>/dev/null
}

is_cloud_vm() {
    # Detect common cloud providers
    if [ -f /sys/class/dmi/id/product_uuid ]; then
        UUID=$(sudo cat /sys/class/dmi/id/product_uuid 2>/dev/null)
        case "$UUID" in
            *EC2*|*ec2*) return 0 ;;      # AWS
            *GCE*|*gce*) return 0 ;;      # Google Cloud
            *Azure*|*azure*) return 0 ;;  # Azure
        esac
    fi
    
    # Check for cloud provider metadata services
    if curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/ &>/dev/null; then
        return 0  # AWS
    fi
    
    return 1
}

is_linux() {
    [ "$(uname -s)" = "Linux" ]
}

##############################################
# Distribution Detection
##############################################
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID="${ID:-unknown}"
        DISTRO_VERSION="${VERSION_ID:-}"
        DISTRO_NAME="${NAME:-Unknown Linux}"
        # Kali Linux: ID=kali
        if [ "$DISTRO_ID" = "kali" ]; then
            DISTRO_ID="kali"
            DISTRO_NAME="${DISTRO_NAME:-Kali GNU/Linux}"
        fi
    elif [ -f /etc/redhat-release ]; then
        # RHEL/CentOS/AlmaLinux older versions
        if grep -qi "almalinux" /etc/redhat-release; then
            DISTRO_ID="almalinux"
        elif grep -qi "centos" /etc/redhat-release; then
            DISTRO_ID="centos"
        elif grep -qi "rhel" /etc/redhat-release; then
            DISTRO_ID="rhel"
        else
            DISTRO_ID="rhel"
        fi
        DISTRO_NAME=$(cat /etc/redhat-release)
    else
        DISTRO_ID="unknown"
        DISTRO_NAME="Unknown Linux"
    fi
}

detect_package_manager() {
    if command_exists apt-get; then
        PKG_MANAGER="apt"
        PKG_UPDATE="apt-get update -qq"
        PKG_INSTALL="apt-get install -y"
        PKG_UPGRADE="apt-get upgrade -y"
    elif command_exists dnf; then
        PKG_MANAGER="dnf"
        PKG_UPDATE="dnf check-update -q || true"
        PKG_INSTALL="dnf install -y"
        PKG_UPGRADE="dnf upgrade -y"
    elif command_exists yum; then
        PKG_MANAGER="yum"
        PKG_UPDATE="yum check-update -q || true"
        PKG_INSTALL="yum install -y"
        PKG_UPGRADE="yum upgrade -y"
    elif command_exists pacman; then
        PKG_MANAGER="pacman"
        PKG_UPDATE="pacman -Sy"
        PKG_INSTALL="pacman -S --noconfirm"
        PKG_UPGRADE="pacman -Su --noconfirm"
    elif command_exists zypper; then
        PKG_MANAGER="zypper"
        PKG_UPDATE="zypper refresh -q"
        PKG_INSTALL="zypper install -y"
        PKG_UPGRADE="zypper update -y"
    else
        log_error "No supported package manager found (apt, dnf, yum, pacman, zypper)"
        return 1
    fi
}

# Initialize distribution detection
detect_distro
detect_package_manager

##############################################
# Package Manager Functions
##############################################
pkg_update() {
    log "Updating package lists"
    sudo $PKG_UPDATE
}

pkg_install() {
    sudo $PKG_INSTALL "$@"
}

pkg_upgrade() {
    sudo $PKG_UPGRADE "$@"
}

pkg_add_repo() {
    case "$PKG_MANAGER" in
        apt)
            sudo add-apt-repository -y "$1"
            ;;
        dnf|yum)
            # For RHEL-based, repos are typically added via .repo files
            log_warning "Repository addition for $PKG_MANAGER may require manual .repo file setup"
            ;;
        *)
            log_warning "Repository addition not automated for $PKG_MANAGER"
            ;;
    esac
}

##############################################
# Utility Functions (continued)
##############################################
add_to_bashrc() {
    local line="$1"
    if ! grep -qF "$line" ~/.bashrc; then
        echo "$line" >> ~/.bashrc
        log_success "Added to ~/.bashrc: $line"
    fi
}

ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log_success "Created directory: $dir"
    fi
}
