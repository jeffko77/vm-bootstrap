#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

apply_linux_tweaks() {
    log "Applying Linux/Cloud VM tweaks"
    
    # Update system
    log "Updating system packages"
    pkg_update
    pkg_upgrade
    
    # Install security tools based on distribution
    log "Installing security tools"
    case "$PKG_MANAGER" in
        apt)
            pkg_install fail2ban ufw unattended-upgrades
            # Enable automatic security updates
            log "Enabling automatic security updates"
            sudo dpkg-reconfigure -plow unattended-upgrades || true
            # Configure firewall (allow SSH)
            log "Configuring firewall (ufw)"
            sudo ufw --force enable || true
            sudo ufw allow ssh || true
            sudo ufw allow 22/tcp || true
            ;;
        dnf|yum)
            pkg_install fail2ban firewalld
            # Enable automatic security updates via dnf-automatic
            log "Enabling automatic security updates"
            pkg_install dnf-automatic || pkg_install yum-cron || true
            if command_exists dnf-automatic; then
                sudo systemctl enable --now dnf-automatic.timer || true
            elif command_exists yum-cron; then
                sudo systemctl enable --now yum-cron || true
            fi
            # Configure firewall (allow SSH)
            log "Configuring firewall (firewalld)"
            sudo systemctl enable firewalld || true
            sudo systemctl start firewalld || true
            sudo firewall-cmd --permanent --add-service=ssh || true
            sudo firewall-cmd --reload || true
            ;;
        pacman)
            pkg_install fail2ban
            log_warning "Firewall configuration for Arch Linux requires manual setup"
            ;;
        zypper)
            pkg_install fail2ban
            log_warning "Firewall configuration for openSUSE requires manual setup"
            ;;
    esac
    
    # Enable fail2ban
    log "Enabling fail2ban"
    sudo systemctl enable fail2ban || true
    sudo systemctl start fail2ban || true
    
    # Set timezone (you can customize this)
    log "Setting timezone to UTC"
    sudo timedatectl set-timezone UTC || true
    
    # Increase file watchers (useful for development)
    log "Increasing file watchers limit"
    if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf 2>/dev/null; then
        echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
        sudo sysctl -p || true
    fi
    
    log_success "Linux/Cloud VM tweaks applied successfully"
}

apply_linux_tweaks
