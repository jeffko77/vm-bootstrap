# 🔒 Secrets & Tokens Setup Guide

This guide explains how to set up all the secrets and tokens needed for the bootstrap process.

## 📋 Overview

The bootstrap script will prompt you for tokens/credentials during installation. Here's what you need and how to get them.

---

## 🔑 GitHub Personal Access Token

### Why You Need It
- Authenticate Git operations
- Clone private repositories
- Push to GitHub without entering password every time

### How to Create One

1. **Go to GitHub Settings**
   - Navigate to: https://github.com/settings/tokens
   - Or: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)

2. **Generate New Token**
   - Click "Generate new token (classic)"
   - Give it a descriptive name: `vm-bootstrap` or `dev-machine-access`

3. **Set Expiration**
   - Choose: 90 days, 1 year, or No expiration (for personal machines)

4. **Select Scopes** (minimum required):
   - ✅ `repo` - Full control of private repositories
   - ✅ `workflow` - Update GitHub Action workflows
   - ✅ `read:org` - Read org and team membership (if using orgs)

5. **Generate and Copy**
   - Click "Generate token"
   - **IMPORTANT**: Copy the token NOW - you won't see it again!
   - Format: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### During Bootstrap

When prompted:
```
Enter your GitHub Personal Access Token (or press Enter to skip): 
```

Paste your token and press Enter.

**The token will be stored in `~/.git-credentials` with 600 permissions (secure).**

---

## 🚀 Fly.io Access Token (Optional)

### Why You Need It
- Deploy applications to Fly.io
- Manage Fly.io resources from CLI

### How to Get One

#### Option 1: Login via CLI (Recommended)
After bootstrap completes:
```bash
flyctl auth login
```
This opens your browser to authenticate.

#### Option 2: Generate API Token
1. Go to: https://fly.io/user/personal_access_tokens
2. Click "Create token"
3. Give it a name: `vm-bootstrap-machine`
4. Click "Create"
5. Copy the token

### During Bootstrap

The script will prompt:
```
Enter your Fly.io access token: 
```

You can either:
- Paste the token (it will be stored in `~/.fly/access_token`)
- Press Enter to skip and use `flyctl auth login` later

---

## 🔧 Git Configuration

### What You'll Be Asked

1. **Git Name**
   ```
   Enter your Git name: 
   ```
   Example: `Jeff Ko` or your full name

2. **Git Email**
   ```
   Enter your Git email: 
   ```
   Example: `jeffko77@gmail.com` or your GitHub email
   
   💡 **Tip**: Use your GitHub no-reply email if you want privacy:
   - Go to: https://github.com/settings/emails
   - Enable "Keep my email addresses private"
   - Use: `<ID>+jeffko77@users.noreply.github.com`

---

## 🛡️ Security Best Practices

### GitHub Token Security

✅ **DO:**
- Use tokens with minimal required scopes
- Set expiration dates for tokens
- Rotate tokens regularly
- Delete tokens you're not using
- Use different tokens for different machines

❌ **DON'T:**
- Share tokens in public repos
- Commit tokens to version control
- Use personal tokens in CI/CD (use GitHub Apps instead)
- Give tokens more permissions than needed

### Storage Locations

The bootstrap script stores credentials securely:

| Credential | Location | Permissions |
|------------|----------|-------------|
| GitHub Token | `~/.git-credentials` | 600 (owner read/write only) |
| Fly.io Token | `~/.fly/access_token` | 600 (owner read/write only) |
| Git Config | `~/.gitconfig` | 644 (world readable - no secrets) |

### Checking Your Stored Credentials

```bash
# View Git credentials (will show token!)
cat ~/.git-credentials

# View Git configuration (no secrets here)
cat ~/.gitconfig

# View Fly.io token (will show token!)
cat ~/.fly/access_token

# Check file permissions
ls -l ~/.git-credentials ~/.fly/access_token
# Should show: -rw------- (600)
```

---

## 🔄 Non-Interactive Mode

If you want to automate the bootstrap without prompts:

### Set Environment Variables

```bash
export GIT_NAME="Jeff Ko"
export GIT_EMAIL="jeffko77@gmail.com"
export GITHUB_TOKEN="ghp_your_token_here"
export FLY_TOKEN="fly_your_token_here"
export SKIP_GIT_TOKEN=1  # Skip GitHub token prompt

./bootstrap.sh
```

### Pre-create Credential Files

```bash
# GitHub credentials
echo "https://ghp_your_token_here:@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials

# Git config
git config --global user.name "Jeff Ko"
git config --global user.email "jeffko77@gmail.com"

# Fly.io token
mkdir -p ~/.fly
echo "your_fly_token_here" > ~/.fly/access_token
chmod 600 ~/.fly/access_token

# Then run bootstrap (will skip these prompts)
./bootstrap.sh
```

---

## 🧪 Testing Tokens

### Test GitHub Token

```bash
# Test with curl
curl -H "Authorization: token ghp_your_token_here" \
  https://api.github.com/user

# Or test with git
git clone https://github.com/jeffko77/private-repo.git
```

### Test Git Configuration

```bash
git config --global --list
# Should show your name and email
```

### Test Fly.io Token

```bash
flyctl auth whoami
# Should show your Fly.io account
```

---

## 🔐 Token Management

### View Your Tokens

**GitHub:**
- https://github.com/settings/tokens
- View/revoke existing tokens

**Fly.io:**
- https://fly.io/user/personal_access_tokens
- View/revoke existing tokens

### Rotate Tokens

When you rotate tokens:

1. **Create new token** (follow steps above)

2. **Update ~/.git-credentials:**
   ```bash
   echo "https://NEW_TOKEN:@github.com" > ~/.git-credentials
   chmod 600 ~/.git-credentials
   ```

3. **Update Fly.io token:**
   ```bash
   echo "NEW_FLY_TOKEN" > ~/.fly/access_token
   chmod 600 ~/.fly/access_token
   ```

4. **Revoke old token** in GitHub/Fly.io settings

---

## 🚨 Token Leaked? Act Fast!

If you accidentally commit a token:

1. **Revoke it immediately:**
   - GitHub: https://github.com/settings/tokens
   - Fly.io: https://fly.io/user/personal_access_tokens

2. **Generate a new token**

3. **Update your local credentials**

4. **If committed to Git:**
   ```bash
   # Remove from history (use with caution!)
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all
   
   # Or use BFG Repo-Cleaner
   # https://rtyley.github.io/bfg-repo-cleaner/
   ```

5. **Force push** (if in your own repo):
   ```bash
   git push origin --force --all
   ```

---

## 📝 Quick Reference

### During Bootstrap Installation

| Prompt | What to Enter | Skip? |
|--------|---------------|-------|
| Git name | Your full name | No |
| Git email | Your email address | No |
| GitHub token | `ghp_...` from GitHub | Yes (press Enter) |
| Fly.io token | Token from Fly.io | Yes (press Enter) |

### After Installation

```bash
# Verify Git setup
git config --global --list

# Test GitHub authentication
git clone https://github.com/jeffko77/some-repo.git

# Login to Fly.io (if skipped during bootstrap)
flyctl auth login
```

---

## 🎯 Recommended Workflow

### For New Machine

1. **Run bootstrap:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/main/bootstrap.sh | bash
   ```

2. **Enter credentials when prompted:**
   - Git name and email (required)
   - GitHub token (recommended)
   - Fly.io token (optional, can do later)

3. **Verify setup:**
   ```bash
   bash scripts/verify_installation.sh
   git config --global --list
   ```

4. **Test GitHub access:**
   ```bash
   git clone https://github.com/jeffko77/vm-bootstrap.git
   ```

### For Temporary/Testing VM

- Skip token prompts (press Enter)
- Use `flyctl auth login` when needed
- Use SSH keys for Git instead of tokens

---

## 💡 Pro Tips

1. **Use SSH for Git** (alternative to tokens):
   ```bash
   ssh-keygen -t ed25519 -C "jeffko77@gmail.com"
   cat ~/.ssh/id_ed25519.pub
   # Add to GitHub: https://github.com/settings/keys
   ```

2. **Use credential helper** (already configured by bootstrap):
   ```bash
   git config --global credential.helper store
   ```

3. **Check token scopes** before creating:
   - Minimal scopes = better security
   - Can always create new token with more scopes

4. **Different tokens for different purposes:**
   - Personal development: Full repo access
   - CI/CD: Limited scopes
   - Testing: Short expiration

---

## 📞 Need Help?

- **GitHub Token Issues**: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
- **Fly.io Auth**: https://fly.io/docs/flyctl/auth-login/
- **Git Credentials**: https://git-scm.com/docs/git-credential-store

---

**Remember: Keep your tokens secret, keep your tokens safe! 🔐**
