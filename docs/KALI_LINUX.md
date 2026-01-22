# Kali Linux Support

This branch (`kali-linux`) adds full support for **Kali Linux**.

## What's Different

- **Detection**: Kali is detected via `/etc/os-release` (`ID=kali`).
- **Package manager**: Uses `apt` (Debian-based), so most package names are identical to Debian/Ubuntu.
- **Root user**: Kali typically runs as root by default. The script detects root and handles it appropriately (no sudo needed).
- **Security tools**: Many security tools are pre-installed on Kali. The script checks before installing to avoid duplicates.
- **Updates**: Kali uses rolling releases, so `unattended-upgrades` is skipped (not applicable to rolling releases).

## Package Compatibility

Kali Linux is based on Debian Testing, so package names are generally identical:
- ✅ `build-essential` → `build-essential`
- ✅ `python3-pip` → `python3-pip`
- ✅ `docker.io` → `docker.io`
- ✅ All standard Debian/Ubuntu packages work

## Root User Handling

Kali Linux typically runs as root by default. The bootstrap script:
- Detects if running as root (`id -u` = 0)
- Defines `sudo` as a no-op function when running as root
- Works seamlessly whether running as root or with sudo

## Security Tools

Kali comes with many security tools pre-installed. The script:
- Checks if tools like `fail2ban` and `ufw` are already installed
- Only installs missing tools
- Skips `unattended-upgrades` (not applicable to rolling releases)

## Usage

```bash
# Clone and use the kali-linux branch
git clone -b kali-linux https://github.com/jeffko77/vm-bootstrap.git
cd vm-bootstrap
./bootstrap.sh
```

Or with curl (replace `main` with `kali-linux` when that branch is pushed):

```bash
curl -fsSL https://raw.githubusercontent.com/jeffko77/vm-bootstrap/kali-linux/bootstrap.sh | bash
```

## Requirements

- Kali Linux (or Kali-based) with `apt`
- Network access
- Root access (default) or sudo configured

## Notes

- **Root user**: If you're running as root (default on Kali), you won't be prompted for passwords.
- **Security tools**: Many tools are pre-installed. The script only installs what's missing.
- **Rolling release**: Kali uses rolling releases, so automatic update mechanisms differ from fixed-release distributions.
- **Development focus**: This bootstrap focuses on development tools, not penetration testing tools (which Kali already includes).

## Differences from Debian/Ubuntu

1. **Root by default**: No sudo prompts when running as root
2. **Pre-installed tools**: Many security/development tools already present
3. **Rolling release**: Update strategy differs from fixed releases
4. **Package versions**: May have different versions than Debian Stable/Ubuntu
