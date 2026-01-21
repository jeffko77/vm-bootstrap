# 🚀 Jeff Ko's Quick Start Guide

## Your One-Line Install Command

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
```

---

## 🔑 Token Setup (Before Running)

### GitHub Personal Access Token

1. Go to: **https://github.com/settings/tokens**
2. Click: **"Generate new token (classic)"**
3. Name it: `vm-bootstrap` or `dev-machines`
4. Scopes needed:
   - ✅ `repo` (full control)
   - ✅ `workflow` (update workflows)
5. Click **"Generate token"**
6. **COPY IT NOW** - looks like: `ghp_xxxxxxxxxxxxxxxxxxxx`

### During Installation

When prompted:
```
Enter your Git name: Jeff Ko
Enter your Git email: [your-email]@gmail.com
Enter your GitHub Personal Access Token: ghp_[paste-your-token-here]
```

---

## 📋 Installation Checklist

- [ ] Have GitHub token ready (see above)
- [ ] Run the one-line command
- [ ] Enter: `Jeff Ko` for name
- [ ] Enter your email
- [ ] Paste GitHub token
- [ ] Skip Fly.io token (press Enter) - set up later if needed
- [ ] Wait 5-10 minutes for installation
- [ ] Run: `source ~/.bashrc`
- [ ] If WSL: Run `wsl.exe --shutdown` from PowerShell, then reopen
- [ ] Verify: `bash scripts/verify_installation.sh`

---

## ✅ What Gets Installed

- Python 3.13
- Node.js (latest)
- uv (Python package manager)
- pnpm (JS package manager)
- Docker CLI
- PostgreSQL client
- flyctl (Fly.io CLI)
- Git configuration with aliases
- Shell aliases and improvements

---

## 🎯 First Steps After Install

```bash
# Reload shell
source ~/.bashrc

# Verify everything
python3 --version
node --version
docker --version

# Check Git config
git config --global --list

# Test Git aliases
git st    # git status
git lg    # pretty log

# Clone your repos
git clone https://github.com/jeffko77/your-repo.git
```

---

## 🔐 Where Your Tokens Are Stored

- **GitHub token**: `~/.git-credentials` (permissions: 600)
- **Git config**: `~/.gitconfig`
- **Fly.io token**: `~/.fly/access_token` (if you set it up)

### View Your Stored Token

```bash
cat ~/.git-credentials
# Shows: https://ghp_your_token:@github.com
```

### Update Token Later

```bash
echo "https://ghp_NEW_TOKEN:@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
```

---

## 🛠️ Useful Commands

### Verify Installation
```bash
bash scripts/verify_installation.sh
```

### Update All Tools
```bash
bash scripts/update_all.sh
```

### Uninstall Everything
```bash
bash scripts/uninstall.sh
```

---

## 🚨 Quick Fixes

### Command not found
```bash
source ~/.bashrc
```

### Docker permission denied
```bash
newgrp docker
# or logout/login
```

### WSL DNS not working
```bash
sudo rm /etc/resolv.conf
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
```

---

## 📞 Your Repository

- **URL**: https://github.com/jeffko77/vm-bootstrap.git
- **Install**: `curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash`
- **Docs**: All in the repo after you push it

---

## 🔄 Publishing to GitHub

```bash
cd /home/jeffko/projects/bootstrap

# Initialize git
git init
git add .
git commit -m "Initial commit: VM bootstrap repository"

# Add remote (your repo)
git remote add origin https://github.com/jeffko77/vm-bootstrap.git

# Push
git branch -M main
git push -u origin main
```

---

## 🎉 You're All Set!

Just remember this command for new machines:

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
```

And have your GitHub token ready!

---

**Need more details?**
- Token setup: [SECRETS_SETUP.md](SECRETS_SETUP.md)
- Full usage: [USAGE.md](USAGE.md)
- Complete docs: [README.md](README.md)
