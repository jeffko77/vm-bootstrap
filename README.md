# 🚀 Dev Bootstrap

A comprehensive, modular bootstrap script for setting up new development machines. Automatically detects your environment (WSL, Cloud VM, or standard Linux) and configures everything you need to start coding immediately.

## ✨ Features

### 🔧 Core Development Tools
- **Python 3.13** with pip and venv
- **uv** - Modern Python package manager
- **Node.js** (latest) via NVM
- **pnpm** - Fast, disk space efficient package manager
- **Docker CLI** - Container management
- **PostgreSQL Client Tools** - Database utilities
- **flyctl** - Fly.io deployment CLI

### 🎯 Smart Environment Detection
- **WSL** - Windows Subsystem for Linux optimizations
- **Cloud VM** - AWS, GCP, Azure security hardening
- **Standard Linux** - General Linux desktop/server setup

### 🛠 Configuration
- Git identity and authentication setup
- Useful Git aliases (`gst`, `gco`, `glg`, etc.)
- Editor shortcuts for Cursor and VS Code
- Shell aliases and improvements
- PATH optimization

### 🔒 Security (Cloud VM/Linux)
- fail2ban for SSH protection
- UFW firewall configuration
- Automatic security updates
- Timezone configuration

### ⚡ WSL Optimizations
- DNS configuration (Cloudflare 1.1.1.1)
- Windows PATH isolation
- Network performance tweaks
- systemd enablement

## 🚀 Quick Start

### One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
```

### Manual Install

```bash
# Clone the repository
git clone https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap

# Make scripts executable
chmod +x bootstrap.sh
chmod +x scripts/*.sh
chmod +x detection/*.sh

# Run the bootstrap script
./bootstrap.sh
```

## 📁 Repository Structure

```
vm-bootstrap/
│
├── bootstrap.sh                # Main entrypoint
├── scripts/
│   ├── common.sh               # Shared functions (logging, detection, helpers)
│   ├── install_python.sh       # Python 3.13 installation
│   ├── install_node.sh         # Node.js via NVM
│   ├── install_uv.sh           # uv package manager
│   ├── install_pnpm.sh         # pnpm installation
│   ├── install_docker.sh       # Docker CLI
│   ├── install_postgres.sh     # PostgreSQL client tools
│   ├── install_flyctl.sh       # Fly.io CLI
│   ├── configure_git.sh        # Git identity setup
│   ├── configure_git_aliases.sh # Git aliases
│   ├── configure_git_auth.sh   # GitHub authentication
│   ├── editor_helpers.sh       # Editor shortcuts and aliases
│   ├── wsl_tweaks.sh           # WSL-specific optimizations
│   └── linux_tweaks.sh         # Linux/Cloud VM hardening
│
├── detection/
│   ├── detect_wsl.sh           # WSL detection utility
│   ├── detect_cloud_vm.sh      # Cloud provider detection
│   └── detect_linux.sh         # Linux detection
│
├── config/
│   ├── gitconfig.example       # Example Git configuration
│   ├── bashrc.append           # Bash configuration additions
│   └── wsl.conf                # WSL configuration template
│
├── docs/                       # Documentation
│   ├── QUICKSTART.md           # Quick start guide
│   ├── INSTALL_GUIDE.md        # Detailed installation
│   ├── USAGE.md                # Usage guide
│   ├── SECRETS_SETUP.md        # Token/secrets setup
│   ├── CONTRIBUTING.md         # Contribution guidelines
│   ├── QUICK_REFERENCE.md      # Command reference
│   └── PROJECT_SUMMARY.md      # Project overview
│
└── README.md                   # This file
```

## 🎯 What Gets Installed

### System Packages
- build-essential
- curl, wget, git
- jq, ripgrep, fd-find, fzf
- tree, htop
- zip, unzip

### Development Tools
| Tool | Version | Location |
|------|---------|----------|
| Python | 3.13 | `/usr/bin/python3.13` |
| uv | Latest | `~/.local/bin/uv` |
| Node.js | Latest | `~/.nvm/` |
| pnpm | Latest | `~/.local/share/pnpm` |
| Docker | Latest | System package |
| PostgreSQL | Client only | System package |
| flyctl | Latest | `~/.fly/bin/flyctl` |

## 🔧 Customization

### Modifying the Installation

Each component is isolated in its own script, making it easy to customize:

1. **Skip a component**: Comment out the corresponding line in `bootstrap.sh`
2. **Add a component**: Create a new script in `scripts/` and source it in `bootstrap.sh`
3. **Modify behavior**: Edit the individual script files

### Example: Skip Docker Installation

Edit `bootstrap.sh` and comment out:

```bash
# source "$SCRIPT_DIR/scripts/install_docker.sh"
```

## 🧪 Testing

You can test individual components:

```bash
# Test environment detection
bash detection/detect_wsl.sh
bash detection/detect_cloud_vm.sh
bash detection/detect_linux.sh

# Test individual installers (requires sudo)
bash scripts/install_python.sh
bash scripts/install_node.sh
```

## 📝 Post-Installation

After running the bootstrap script:

1. **Restart your terminal** or run:
   ```bash
   source ~/.bashrc
   ```

2. **For WSL users**, restart WSL from PowerShell:
   ```powershell
   wsl.exe --shutdown
   ```

3. **Verify installations**:
   ```bash
   python3 --version
   node --version
   uv --version
   pnpm --version
   docker --version
   flyctl version
   ```

4. **Check Git configuration**:
   ```bash
   git config --global --list
   ```

## 📚 Documentation

- **[Quick Start](docs/QUICKSTART.md)** - Get started in 5 minutes
- **[Installation Guide](docs/INSTALL_GUIDE.md)** - Detailed installation instructions
- **[Usage Guide](docs/USAGE.md)** - How to use the bootstrap script
- **[Secrets Setup](docs/SECRETS_SETUP.md)** - GitHub and Fly.io token configuration
- **[Quick Reference](docs/QUICK_REFERENCE.md)** - Command cheat sheet
- **[Contributing](docs/CONTRIBUTING.md)** - How to contribute
- **[Project Summary](docs/PROJECT_SUMMARY.md)** - Architecture and design

## 🛡 Security Notes

- The script requires `sudo` access for system package installation
- GitHub tokens are stored in `~/.git-credentials` with 600 permissions
- For cloud VMs, fail2ban and UFW are automatically configured
- All installation scripts are idempotent (safe to run multiple times)

## 🔍 Environment Detection Logic

### WSL Detection
```bash
grep -qi "microsoft" /proc/version
```

### Cloud VM Detection
Checks for:
- DMI product UUID (EC2, GCE, Azure identifiers)
- Cloud metadata services (AWS, GCP, Azure)

### Linux Detection
```bash
[ "$(uname -s)" = "Linux" ]
```

## 🎨 Git Aliases

The following Git aliases are automatically configured:

| Alias | Command |
|-------|---------|
| `git st` | `git status -sb` |
| `git co` | `git checkout` |
| `git br` | `git branch` |
| `git cm` | `git commit -m` |
| `git amend` | `git commit --amend --no-edit` |
| `git lg` | `git log --oneline --graph --decorate --all` |
| `git undo` | `git reset --soft HEAD~1` |
| `git unstage` | `git reset HEAD --` |

Plus shell aliases:
- `gs` → `git status`
- `gp` → `git pull`
- `gps` → `git push`

## 🐛 Troubleshooting

### Python not found
```bash
which python3
sudo update-alternatives --config python3
```

### NVM not loading
```bash
source ~/.bashrc
# or
source ~/.nvm/nvm.sh
```

### Docker permission denied
```bash
# Log out and back in, or run:
newgrp docker
```

### WSL DNS issues
```bash
sudo rm /etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
```

## 🤝 Contributing

Feel free to submit issues or pull requests to improve this bootstrap script!

See **[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)** for detailed guidelines on how to contribute.

## 📜 License

MIT License - feel free to use and modify as needed.

## 🙏 Acknowledgments

Built for developers who want to get productive quickly on new machines without memorizing installation commands.

---

**Happy Coding! 🎉**
