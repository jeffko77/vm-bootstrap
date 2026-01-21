# 🚀 Usage Guide

## Quick Install

### One-Line Command

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
```

This will:
1. Download the bootstrap script
2. Clone the repository to a temporary directory
3. Install all tools
4. Configure Git and shell
5. Clean up temporary files

---

## 📋 What You'll Be Prompted For

During installation, you'll need to provide:

### 1. Git Configuration (Required)
```
Enter your Git name: Jeff Ko
Enter your Git email: jeffko77@gmail.com
```

### 2. GitHub Token (Recommended)
```
Enter your GitHub Personal Access Token (or press Enter to skip): ghp_xxxx...
```

👉 **How to get this**: See [SECRETS_SETUP.md](SECRETS_SETUP.md)
- Go to: https://github.com/settings/tokens
- Create token with `repo` and `workflow` scopes
- Copy the `ghp_...` token

### 3. Fly.io Token (Optional)
```
Enter your Fly.io access token: 
```

👉 **Can skip this** - Just press Enter and use `flyctl auth login` later

---

## 🎯 Complete Installation Flow

```bash
# 1. Run the one-liner
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash

# 2. Follow prompts:
#    - Enter your name: Jeff Ko
#    - Enter your email: jeffko77@gmail.com
#    - Enter GitHub token: ghp_... (or skip with Enter)
#    - Enter Fly.io token: (or skip with Enter)

# 3. Wait for installation (5-10 minutes)

# 4. Reload shell
source ~/.bashrc

# 5. If on WSL, restart WSL (from PowerShell)
wsl.exe --shutdown

# 6. Verify installation
cd /tmp/dev-bootstrap  # or wherever it cloned
bash scripts/verify_installation.sh

# 7. Test tools
python3 --version    # Should show 3.13.x
node --version       # Should show latest
docker --version     # Should show Docker version
```

---

## 🔧 Alternative: Clone and Run Locally

If you want to review/customize before running:

```bash
# Clone the repository
git clone https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap

# Review what it does
cat bootstrap.sh
ls scripts/

# Optional: Edit to skip components
nano bootstrap.sh  # Comment out lines you don't want

# Run it
./bootstrap.sh

# Verify
bash scripts/verify_installation.sh
```

---

## 🎨 Selective Installation

Install only specific tools:

```bash
# Clone first
git clone https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap

# Install only what you need
source scripts/common.sh

bash scripts/install_python.sh
bash scripts/install_node.sh
bash scripts/install_uv.sh
# ... etc

# Configure Git
bash scripts/configure_git.sh
bash scripts/configure_git_aliases.sh
```

---

## 🌍 Environment-Specific Behavior

The script auto-detects your environment:

### WSL (Windows Subsystem for Linux)
- ✅ DNS configured (Cloudflare 1.1.1.1)
- ✅ Windows PATH isolated
- ✅ Performance tweaks applied
- ⚠️ **Must restart WSL after**: `wsl.exe --shutdown`

### Cloud VM (AWS, GCP, Azure)
- ✅ Security hardening (fail2ban, UFW)
- ✅ Automatic security updates
- ✅ Firewall configured (SSH allowed)
- ℹ️ Detects: EC2, GCE, Azure instances

### Standard Linux
- ✅ Basic optimizations
- ✅ Development tools installed
- ✅ File watcher limits increased

---

## ✅ Post-Installation

### Verify Everything Works

```bash
# Quick verification
bash scripts/verify_installation.sh

# Manual checks
python3 --version
node --version
npm --version
uv --version
pnpm --version
docker --version
psql --version
flyctl version
git --version

# Check Git config
git config --global --list

# Test Git aliases
git st      # Should work (git status -sb)
git lg      # Should work (fancy log)
```

### Test GitHub Access

```bash
# Clone a test repo
git clone https://github.com/jeffko77/vm-bootstrap.git test-clone

# If it works without asking for password, you're set!
```

### Login to Fly.io (if you skipped token)

```bash
flyctl auth login
# Opens browser to authenticate
```

---

## 🔄 Updating Tools

After installation, you can update everything:

```bash
cd vm-bootstrap  # wherever you cloned it

# Update all tools
bash scripts/update_all.sh

# Or update specific ones
bash scripts/install_python.sh    # Reinstalls/updates Python
bash scripts/install_node.sh      # Updates Node to latest
```

---

## 🗑️ Uninstalling

To remove everything:

```bash
cd vm-bootstrap
bash scripts/uninstall.sh
```

This will remove:
- Python 3.13
- Node.js/NVM
- uv, pnpm
- Docker
- PostgreSQL client
- flyctl

⚠️ **Note**: Git credentials and ~/.bashrc modifications require manual cleanup

---

## 🚨 Troubleshooting

### Command Not Found After Install

```bash
source ~/.bashrc
# Or close and reopen terminal
```

### Python Not Found

```bash
python3 --version
which python3
sudo update-alternatives --config python3
```

### Node/NVM Not Working

```bash
source ~/.nvm/nvm.sh
nvm list
node --version
```

### Docker Permission Denied

```bash
sudo usermod -aG docker $USER
newgrp docker
# Or log out and back in
```

### WSL DNS Issues

```bash
sudo rm /etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
sudo chattr +i /etc/resolv.conf
```

---

## 🎯 Usage Examples

### New WSL Machine

```bash
# In WSL Ubuntu terminal
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash

# Follow prompts
# Wait for completion
# From PowerShell:
wsl.exe --shutdown

# Reopen WSL and verify
source ~/.bashrc
python3 --version
```

### New Cloud VM

```bash
# SSH into your VM
ssh user@vm-ip

# Run bootstrap
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash

# No restart needed (not WSL)
source ~/.bashrc

# Verify
bash scripts/verify_installation.sh
```

### Development Machine

```bash
# Clone for customization
git clone https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap

# Review scripts
cat bootstrap.sh
cat scripts/install_docker.sh

# Customize if needed
nano bootstrap.sh

# Run
./bootstrap.sh

# Verify and start coding!
```

---

## 📚 More Information

- **Secrets Setup**: [SECRETS_SETUP.md](SECRETS_SETUP.md) - How to get GitHub/Fly.io tokens
- **Quick Reference**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Command cheat sheet
- **Full Documentation**: [README.md](README.md) - Complete guide
- **Installation Details**: [INSTALL_GUIDE.md](INSTALL_GUIDE.md) - In-depth installation

---

## 🎉 You're Ready!

The one-line command is:

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
```

Save this command somewhere handy - you'll use it every time you set up a new machine!

**Happy bootstrapping! 🚀**
