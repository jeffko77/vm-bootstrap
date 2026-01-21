#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

apply_linux_tweaks() {
    log "Applying Linux/Cloud VM tweaks"
    
    # Update system
    log "Updating system packages"
    sudo apt update -y
    sudo apt upgrade -y
    
    # Install security tools
    log "Installing security tools"
    sudo apt install -y \
        fail2ban \
        ufw \
        unattended-upgrades
    
    # Enable automatic security updates
    log "Enabling automatic security updates"
    sudo dpkg-reconfigure -plow unattended-upgrades
    
    # Configure firewall (allow SSH)
    log "Configuring firewall"
    sudo ufw --force enable
    sudo ufw allow ssh
    sudo ufw allow 22/tcp
    
    # Enable fail2ban
    log "Enabling fail2ban"
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
    
    # Set timezone (you can customize this)
    log "Setting timezone to UTC"
    sudo timedatectl set-timezone UTC
    
    # Increase file watchers (useful for development)
    log "Increasing file watchers limit"
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    
    log_success "Linux/Cloud VM tweaks applied successfully"
}

apply_linux_tweaks
