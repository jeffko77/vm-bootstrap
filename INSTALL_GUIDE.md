# 📦 Installation Guide

## Prerequisites

- Linux-based system (Ubuntu 20.04+ recommended)
- `sudo` access
- Internet connection
- `curl` and `bash` installed

## Installation Methods

### Method 1: One-Line Remote Install

Perfect for quick setup on a brand new machine:

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
```

**What this does:**
1. Downloads the bootstrap script
2. Clones the repository to a temporary directory
3. Runs the full installation
4. Cleans up temporary files

### Method 2: Clone and Run (Recommended)

Best for customization and understanding what's being installed:

```bash
# Clone the repository
git clone https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap

# Review the scripts (optional but recommended)
cat bootstrap.sh
ls scripts/

# Run the installation
./bootstrap.sh
```

### Method 3: Selective Installation

Install only specific components:

```bash
git clone https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap

# Install only Python
source scripts/common.sh
bash scripts/install_python.sh

# Install only Node.js
bash scripts/install_node.sh

# Configure Git only
bash scripts/configure_git.sh
bash scripts/configure_git_aliases.sh
```

## Installation Flow

```
┌─────────────────────────────────────┐
│   1. Environment Detection          │
│   (WSL / Cloud VM / Linux)          │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   2. System Package Updates         │
│   (apt update & install base tools) │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   3. Core Development Tools         │
│   • Python 3.13                     │
│   • uv                              │
│   • Node.js (via NVM)               │
│   • pnpm                            │
│   • Docker CLI                      │
│   • PostgreSQL client               │
│   • flyctl                          │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   4. Git Configuration              │
│   • Identity (name/email)           │
│   • Aliases                         │
│   • GitHub authentication           │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   5. Editor & Shell Helpers         │
│   • Cursor/VS Code aliases          │
│   • Shell shortcuts                 │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   6. Environment-Specific Tweaks    │
│   WSL: DNS, PATH, performance       │
│   Cloud: Security hardening         │
│   Linux: General optimizations      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   ✅ Installation Complete!         │
└─────────────────────────────────────┘
```

## Interactive Prompts

During installation, you'll be prompted for:

### 1. Git Configuration
```
Enter your Git name: John Doe
Enter your Git email: john@example.com
```

### 2. GitHub Authentication (Optional)
```
Enter your GitHub Personal Access Token (or press Enter to skip): ghp_xxxxx
```

> **Note:** Create a token at https://github.com/settings/tokens
> Required scopes: `repo`, `workflow`

## Post-Installation Steps

### 1. Reload Shell Configuration

```bash
source ~/.bashrc
```

Or simply close and reopen your terminal.

### 2. WSL Users: Restart WSL

From PowerShell (Windows):
```powershell
wsl.exe --shutdown
```

Then reopen your WSL terminal.

### 3. Verify Installations

Run the verification script:

```bash
echo "=== Python ===" && python3 --version
echo "=== Node.js ===" && node --version
echo "=== uv ===" && uv --version
echo "=== pnpm ===" && pnpm --version
echo "=== Docker ===" && docker --version
echo "=== PostgreSQL ===" && psql --version
echo "=== flyctl ===" && flyctl version
echo "=== Git ===" && git --version
```

### 4. Test Git Aliases

```bash
git st      # Status
git lg      # Fancy log
gs          # Git status (shell alias)
```

## Environment-Specific Notes

### WSL (Windows Subsystem for Linux)

**Before Installation:**
- Ensure WSL 2 is installed
- Use Ubuntu 20.04 or later

**After Installation:**
- DNS will be set to Cloudflare (1.1.1.1)
- Windows PATH will be isolated
- systemd will be enabled
- **Must restart WSL** for all changes to take effect

**Restart WSL:**
```powershell
# From PowerShell
wsl.exe --shutdown
```

### Cloud VMs (AWS, GCP, Azure)

**Additional Security Measures:**
- `fail2ban` installed and configured
- `ufw` firewall enabled (SSH allowed)
- Automatic security updates enabled
- Timezone set to UTC

**Verify Security:**
```bash
sudo ufw status
sudo systemctl status fail2ban
```

### Standard Linux

Same as Cloud VMs but without aggressive security hardening.

## Customization

### Before Installation: Edit bootstrap.sh

Comment out components you don't need:

```bash
# source "$SCRIPT_DIR/scripts/install_docker.sh"
# source "$SCRIPT_DIR/scripts/install_postgres.sh"
```

### During Installation: Skip Prompts

Set environment variables:

```bash
export GIT_NAME="John Doe"
export GIT_EMAIL="john@example.com"
export SKIP_GIT_TOKEN=1
./bootstrap.sh
```

## Uninstallation

To remove installed tools:

```bash
# Python 3.13
sudo apt remove python3.13

# Node.js (NVM)
rm -rf ~/.nvm

# uv
rm -rf ~/.local/bin/uv

# pnpm
rm -rf ~/.local/share/pnpm

# Docker
sudo apt remove docker.io

# flyctl
rm -rf ~/.fly

# Git configuration
git config --global --unset-all user.name
git config --global --unset-all user.email
```

To remove added shell configurations:

```bash
# Backup first
cp ~/.bashrc ~/.bashrc.backup

# Remove bootstrap additions
# (Manually edit ~/.bashrc and remove lines added by bootstrap)
```

## Troubleshooting

### Installation Fails Midway

The scripts are idempotent - just run again:

```bash
./bootstrap.sh
```

Already installed components will be skipped.

### Permission Denied Errors

Ensure you have sudo access:

```bash
sudo -v
```

### Network Issues

Check internet connectivity:

```bash
curl -I https://www.google.com
```

For WSL, check DNS:

```bash
cat /etc/resolv.conf
ping 1.1.1.1
```

### Command Not Found After Install

Reload shell:

```bash
source ~/.bashrc
```

Or check PATH:

```bash
echo $PATH
```

## Support

- 📖 **Documentation**: [README.md](README.md)
- 🚀 **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- 🤝 **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)
- 🐛 **Issues**: GitHub Issues page

---

**Ready to bootstrap? Let's go! 🚀**
