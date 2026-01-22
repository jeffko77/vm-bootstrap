#!/usr/bin/env bash
#
# Dev Bootstrap Script
# Universal setup script for new development machines
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
#
# Or clone and run locally:
#   git clone https://github.com/jeffko77/vm-bootstrap.git
#   cd vm-bootstrap
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
    echo -e "${BLUE}=== Cloning vm-bootstrap repository ===${NC}\n"
    
    # Check if git is installed, if not install it first
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}Git not found. Installing git first...${NC}\n"
        # Detect package manager for git installation
        if command -v apt-get &> /dev/null; then
            sudo apt-get update -qq
            sudo apt-get install -y git
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y git
        elif command -v yum &> /dev/null; then
            sudo yum install -y git
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy --noconfirm git
        elif command -v zypper &> /dev/null; then
            sudo zypper install -y git
        else
            echo -e "${RED}Error: Could not install git automatically.${NC}"
            echo -e "${RED}Please install git manually and run this script again.${NC}"
            exit 1
        fi
        echo -e "${GREEN}Git installed successfully!${NC}\n"
    fi
    
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/jeffko77/vm-bootstrap.git "$TEMP_DIR"
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

# Detect distribution and package manager
detect_distro
if ! detect_package_manager; then
    log_error "Could not detect package manager. Exiting."
    exit 1
fi

log_success "Detected: $DISTRO_NAME"
log_success "Package manager: $PKG_MANAGER"
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

# Map package names across distributions
get_package_name() {
    local pkg="$1"
    case "$PKG_MANAGER" in
        apt)
            echo "$pkg"
            ;;
        dnf|yum)
            case "$pkg" in
                build-essential) echo "gcc gcc-c++ make" ;;
                fd-find) echo "fd-find" ;;
                python3-pip) echo "python3-pip" ;;
                software-properties-common) echo "" ;;  # Not needed on RHEL
                apt-transport-https) echo "" ;;  # Not needed on RHEL
                lsb-release) echo "redhat-lsb-core" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        pacman)
            case "$pkg" in
                build-essential) echo "base-devel" ;;
                fd-find) echo "fd" ;;
                python3-pip) echo "python-pip" ;;
                software-properties-common) echo "" ;;
                apt-transport-https) echo "" ;;
                lsb-release) echo "lsb-release" ;;
                *) echo "$pkg" ;;
            esac
            ;;
        zypper)
            case "$pkg" in
                build-essential) echo "gcc gcc-c++ make" ;;
                fd-find) echo "fd" ;;
                python3-pip) echo "python3-pip" ;;
                software-properties-common) echo "" ;;
                apt-transport-https) echo "" ;;
                lsb-release) echo "lsb-release" ;;
                *) echo "$pkg" ;;
            esac
            ;;
    esac
}

# Build package list for current distribution
PACKAGES=""
for pkg in build-essential curl wget git zip unzip jq ripgrep fd-find fzf tree htop python3-pip software-properties-common apt-transport-https ca-certificates gnupg lsb-release; do
    mapped=$(get_package_name "$pkg")
    if [ -n "$mapped" ]; then
        PACKAGES="$PACKAGES $mapped"
    fi
done

# Update package lists
pkg_update

# Install packages
log "Installing: $PACKAGES"
pkg_install $PACKAGES

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

# GitHub CLI
source "$SCRIPT_DIR/scripts/install_gh.sh"

##############################################
# Service Authentication
##############################################
log "Configuring service authentication"

# Fly.io authentication
source "$SCRIPT_DIR/scripts/configure_flyctl.sh"

##############################################
# Git Configuration
##############################################
log "Configuring Git"

source "$SCRIPT_DIR/scripts/configure_git.sh"
source "$SCRIPT_DIR/scripts/configure_git_aliases.sh"
source "$SCRIPT_DIR/scripts/configure_git_auth.sh"

# GitHub CLI Configuration
source "$SCRIPT_DIR/scripts/configure_gh.sh"

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
    echo "   2. Restart WSL (choose one):"
    echo "      - Simple: Close and reopen your terminal"
    echo "      - From PowerShell: Run 'wsl --shutdown' or 'wsl.exe --shutdown'"
    echo "      - From WSL console: Run 'sudo reboot' (restarts WSL instance)"
fi
echo "   3. Verify installations:"
echo "      - python3 --version"
echo "      - node --version"
echo "      - uv --version"
echo "      - pnpm --version"
echo "      - docker --version"
echo "      - flyctl version"
echo "      - gh --version"
echo ""
log_success "Happy coding! 🎉"
