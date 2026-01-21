# 🎯 Quick Reference Card

## Installation

```bash
# One-line install
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash

# Or clone and run
git clone https://github.com/jeffko77/vm-bootstrap.git && cd vm-bootstrap && ./bootstrap.sh
```

## Post-Install

```bash
source ~/.bashrc                    # Reload shell
bash scripts/verify_installation.sh # Verify all tools
```

## Installed Tools

| Tool | Command | Check Version |
|------|---------|---------------|
| Python | `python3` | `python3 --version` |
| uv | `uv` | `uv --version` |
| Node | `node` | `node --version` |
| npm | `npm` | `npm --version` |
| pnpm | `pnpm` | `pnpm --version` |
| Docker | `docker` | `docker --version` |
| PostgreSQL | `psql` | `psql --version` |
| flyctl | `flyctl` | `flyctl version` |

## Git Aliases

```bash
git st              # status -sb
git co <branch>     # checkout
git br              # branch
git cm "message"    # commit -m
git amend           # commit --amend --no-edit
git lg              # log --oneline --graph --decorate --all
git undo            # reset --soft HEAD~1
git unstage <file>  # reset HEAD --

# Shell aliases
gs                  # git status
gp                  # git pull
gps                 # git push
```

## Shell Aliases

```bash
ll                  # ls -lah
la                  # ls -A
..                  # cd ..
...                 # cd ../..
c                   # cursor
v                   # code
```

## Utility Scripts

```bash
bash scripts/verify_installation.sh    # Verify all tools
bash scripts/update_all.sh             # Update everything
bash scripts/uninstall.sh              # Remove all tools
bash test.sh                           # Test scripts
```

## Detection Functions

```bash
source scripts/common.sh

is_wsl          # Returns 0 if WSL
is_cloud_vm     # Returns 0 if cloud VM
is_linux        # Returns 0 if Linux
command_exists  # Check if command exists
```

## Individual Installers

```bash
# Install only specific tools
bash scripts/install_python.sh
bash scripts/install_node.sh
bash scripts/install_uv.sh
bash scripts/install_pnpm.sh
bash scripts/install_docker.sh
bash scripts/install_postgres.sh
bash scripts/install_flyctl.sh
```

## Troubleshooting

```bash
# Reload shell
source ~/.bashrc

# Check PATH
echo $PATH

# Reload NVM
source ~/.nvm/nvm.sh

# Fix Docker permissions
newgrp docker

# WSL: Fix DNS
sudo rm /etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
```

## WSL Specific

```bash
# Restart WSL (from PowerShell)
wsl.exe --shutdown

# Check WSL version
wsl.exe --list --verbose

# Check /etc/wsl.conf
cat /etc/wsl.conf

# Check DNS
cat /etc/resolv.conf
```

## Configuration Files

```
~/.bashrc                   # Shell configuration
~/.gitconfig                # Git configuration
~/.git-credentials          # GitHub token (600 perms)
/etc/wsl.conf              # WSL config (WSL only)
```

## Paths

```
Python:     /usr/bin/python3.13
uv:         ~/.local/bin/uv
Node/NVM:   ~/.nvm/
pnpm:       ~/.local/share/pnpm
flyctl:     ~/.fly/bin/flyctl
```

## Environment Variables

```bash
# Added to ~/.bashrc
export NVM_DIR="$HOME/.nvm"
export UV_INSTALL="$HOME/.local/bin"
export PNPM_HOME="$HOME/.local/share/pnpm"
export FLYCTL_INSTALL="$HOME/.fly"
export EDITOR="nano"
```

## GitHub Token Setup

```bash
# Create token at:
https://github.com/settings/tokens

# Required scopes:
- repo
- workflow

# Or manually configure:
git config --global credential.helper store
echo "https://TOKEN:@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
```

## Update Tools

```bash
# System packages
sudo apt update && sudo apt upgrade

# Python packages
python3 -m pip install --upgrade pip

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Node
nvm install node --reinstall-packages-from=node

# pnpm
pnpm add -g pnpm

# Or use the update script
bash scripts/update_all.sh
```

## Common Issues

| Issue | Solution |
|-------|----------|
| Command not found | `source ~/.bashrc` |
| Python not found | Check alternatives: `sudo update-alternatives --config python3` |
| NVM not loading | `source ~/.nvm/nvm.sh` |
| Docker permission denied | `newgrp docker` or logout/login |
| WSL DNS not working | See WSL Specific section above |

## Documentation

- 📖 Full docs: [README.md](README.md)
- 🚀 Quick start: [QUICKSTART.md](QUICKSTART.md)
- 📦 Installation: [INSTALL_GUIDE.md](INSTALL_GUIDE.md)
- 🤝 Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)
- 📋 Summary: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)

---

**Keep this handy! 📌**
