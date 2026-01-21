# 🚀 Quick Start Guide

## Installation

### Option 1: One-Line Install (Fastest)

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
```

### Option 2: Clone and Run (Recommended for customization)

```bash
git clone https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap
./bootstrap.sh
```

## What to Expect

The script will:

1. ✅ Detect your environment (WSL/Cloud VM/Linux)
2. ✅ Update system packages
3. ✅ Install Python 3.13, Node.js, uv, pnpm, Docker, PostgreSQL client, flyctl
4. ✅ Configure Git with your identity and aliases
5. ✅ Set up GitHub authentication (you'll be prompted for a token)
6. ✅ Apply environment-specific tweaks
7. ✅ Add helpful shell aliases

## During Installation

You'll be prompted for:

- **Git name**: Your full name (e.g., "John Doe")
- **Git email**: Your email address (e.g., "john@example.com")
- **GitHub token**: (Optional) Personal Access Token from https://github.com/settings/tokens

## After Installation

### 1. Reload your shell

```bash
source ~/.bashrc
```

### 2. For WSL users, restart WSL

From PowerShell:
```powershell
wsl.exe --shutdown
```

Then reopen your WSL terminal.

### 3. Verify installations

```bash
python3 --version    # Should show 3.13.x
node --version       # Should show v20+ or latest
uv --version         # Should show uv version
pnpm --version       # Should show pnpm version
docker --version     # Should show Docker version
flyctl version       # Should show flyctl version
```

### 4. Test Git

```bash
git config --global --list
git st  # Short for git status
```

## Customization

### Skip specific components

Edit `bootstrap.sh` and comment out lines you don't need:

```bash
# source "$SCRIPT_DIR/scripts/install_docker.sh"  # Skip Docker
```

### Add custom tools

Create a new script in `scripts/install_mytool.sh` and add:

```bash
source "$SCRIPT_DIR/scripts/install_mytool.sh"
```

## Troubleshooting

### Python not found
```bash
source ~/.bashrc
python3 --version
```

### NVM not working
```bash
source ~/.nvm/nvm.sh
node --version
```

### Docker permission denied
```bash
newgrp docker
# or log out and back in
```

## Support

- 📖 Full documentation: See [README.md](README.md)
- 🐛 Issues: Create an issue on GitHub
- 💡 Questions: Check the troubleshooting section in README.md

---

**Happy bootstrapping! 🎉**
