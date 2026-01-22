#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_gh() {
    log "Installing GitHub CLI (gh)"
    
    if command_exists gh; then
        log_warning "GitHub CLI already installed"
        gh --version
        return 0
    fi
    
    # Install based on package manager
    case "$PKG_MANAGER" in
        apt)
            # Add GitHub CLI repository
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            pkg_update
            pkg_install gh
            ;;
        dnf)
            pkg_install dnf-plugins-core
            sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
            pkg_update
            pkg_install gh
            ;;
        yum)
            pkg_install yum-utils
            sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
            pkg_update
            pkg_install gh
            ;;
        pacman)
            pkg_install github-cli
            ;;
        zypper)
            sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
            pkg_update
            pkg_install gh
            ;;
        *)
            log_error "Unsupported package manager for GitHub CLI: $PKG_MANAGER"
            log_warning "Please install GitHub CLI manually from: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
            return 1
            ;;
    esac
    
    log_success "GitHub CLI installed successfully"
    gh --version
}

install_gh
