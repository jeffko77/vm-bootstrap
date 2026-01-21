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
# Utility Functions
##############################################
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

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
