#!/usr/bin/env bash
#
# Dev Bootstrap Script
# Universal setup script for new development machines
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/<user>/dev-bootstrap/main/bootstrap.sh | bash
#
# Or clone and run locally:
#   git clone https://github.com/<user>/dev-bootstrap.git
#   cd dev-bootstrap
#   bash bootstrap.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If running via curl | bash, clone the repo first
if [ ! -f "$SCRIPT_DIR/scripts/common.sh" ]; then
    echo -e "${BLUE}=== Cloning dev-bootstrap repository ===${NC}\n"
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/<user>/dev-bootstrap.git "$TEMP_DIR"
    cd "$TEMP_DIR"
    SCRIPT_DIR="$TEMP_DIR"
fi

# Load shared helper functions
source "$SCRIPT_DIR/scripts/common.sh"

##############################################
# Banner
##############################################
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════╗
║     🚀 Dev Environment Bootstrap 🚀      ║
║                                           ║
║  Setting up your development machine...  ║
╚═══════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

##############################################
# Pre-flight checks
##############################################
log "Running pre-flight checks"

# Check if running on Linux
if ! is_linux; then
    log_error "This script only supports Linux systems"
    exit 1
fi

# Check for sudo access
if ! sudo -v; then
    log_error "This script requires sudo access"
    exit 1
fi

log_success "Pre-flight checks passed"

##############################################
# Environment Detection
##############################################
log "Detecting environment"

if is_wsl; then
    log_success "Detected: WSL (Windows Subsystem for Linux)"
    ENV_TYPE="wsl"
elif is_cloud_vm; then
    log_success "Detected: Cloud VM (AWS/GCP/Azure)"
    ENV_TYPE="cloud"
else
    log_success "Detected: Standard Linux"
    ENV_TYPE="linux"
fi

##############################################
# System Package Updates
##############################################
log "Installing system packages"
sudo apt update -y
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    zip \
    unzip \
    jq \
    ripgrep \
    fd-find \
    fzf \
    tree \
    htop \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

log_success "System packages installed"

##############################################
# Core Development Tools
##############################################
log "Installing core development tools"

# Python 3.13
source "$SCRIPT_DIR/scripts/install_python.sh"

# uv (Python package manager)
source "$SCRIPT_DIR/scripts/install_uv.sh"

# Node.js via NVM
source "$SCRIPT_DIR/scripts/install_node.sh"

# pnpm
source "$SCRIPT_DIR/scripts/install_pnpm.sh"

# Docker CLI
source "$SCRIPT_DIR/scripts/install_docker.sh"

# PostgreSQL client tools
source "$SCRIPT_DIR/scripts/install_postgres.sh"

# flyctl (Fly.io CLI)
source "$SCRIPT_DIR/scripts/install_flyctl.sh"

##############################################
# Git Configuration
##############################################
log "Configuring Git"

source "$SCRIPT_DIR/scripts/configure_git.sh"
source "$SCRIPT_DIR/scripts/configure_git_aliases.sh"
source "$SCRIPT_DIR/scripts/configure_git_auth.sh"

##############################################
# Editor Helpers
##############################################
source "$SCRIPT_DIR/scripts/editor_helpers.sh"

##############################################
# Environment-Specific Tweaks
##############################################
case "$ENV_TYPE" in
    wsl)
        source "$SCRIPT_DIR/scripts/wsl_tweaks.sh"
        ;;
    cloud|linux)
        source "$SCRIPT_DIR/scripts/linux_tweaks.sh"
        ;;
esac

##############################################
# Completion
##############################################
echo -e "\n${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════════╗
║      ✅ Bootstrap Complete! ✅            ║
╚═══════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

log_success "Development environment setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Restart your terminal or run: source ~/.bashrc"
if [ "$ENV_TYPE" = "wsl" ]; then
    echo "   2. Restart WSL: wsl.exe --shutdown (from PowerShell)"
fi
echo "   3. Verify installations:"
echo "      - python3 --version"
echo "      - node --version"
echo "      - uv --version"
echo "      - pnpm --version"
echo "      - docker --version"
echo "      - flyctl version"
echo ""
log_success "Happy coding! 🎉"
