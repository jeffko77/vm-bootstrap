# Contributing to Dev Bootstrap

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## 🎯 How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. Create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - System information (OS, version, environment)

### Suggesting Enhancements

1. Open an issue describing your suggestion
2. Explain why this enhancement would be useful
3. Provide examples if possible

### Pull Requests

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📝 Coding Guidelines

### Shell Script Standards

1. **Use bash shebang**: `#!/usr/bin/env bash`
2. **Enable error handling**: `set -e` at the top of scripts
3. **Source common.sh**: Use shared functions from `scripts/common.sh`
4. **Idempotency**: Scripts should be safe to run multiple times
5. **Check before install**: Use `command_exists` to check if tool is already installed

### Example Script Structure

```bash
#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

install_mytool() {
    log "Installing MyTool"
    
    if command_exists mytool; then
        log_warning "MyTool already installed"
        mytool --version
        return 0
    fi
    
    # Installation commands here
    curl -sSL https://example.com/install.sh | sh
    
    # Add to PATH if needed
    add_to_bashrc 'export PATH="$HOME/.mytool/bin:$PATH"'
    
    log_success "MyTool installed successfully"
    mytool --version
}

install_mytool
```

### Logging Functions

Use these from `scripts/common.sh`:

- `log "message"` - Blue info message
- `log_success "message"` - Green success message
- `log_warning "message"` - Yellow warning message
- `log_error "message"` - Red error message

### Helper Functions

Available in `scripts/common.sh`:

- `command_exists "cmd"` - Check if command exists
- `add_to_bashrc "line"` - Add line to ~/.bashrc (if not exists)
- `ensure_directory "path"` - Create directory if it doesn't exist
- `is_wsl()` - Returns true if running in WSL
- `is_cloud_vm()` - Returns true if running in cloud VM
- `is_linux()` - Returns true if running on Linux

## 🧪 Testing

### Test Individual Scripts

```bash
# Test detection
bash detection/detect_wsl.sh
bash detection/detect_cloud_vm.sh

# Test installation scripts (may require sudo)
bash scripts/install_python.sh
```

### Test Full Bootstrap

In a clean environment (VM or container):

```bash
git clone https://github.com/your-fork/dev-bootstrap.git
cd dev-bootstrap
./bootstrap.sh
```

### Manual Verification

After running bootstrap:

```bash
# Verify all tools installed
python3 --version
node --version
uv --version
pnpm --version
docker --version
flyctl version

# Check Git configuration
git config --global --list

# Check aliases
git st
gs
```

## 📦 Adding New Tools

1. Create `scripts/install_newtool.sh`
2. Follow the example structure above
3. Add it to `bootstrap.sh` in the appropriate section
4. Update `README.md` with the new tool
5. Test thoroughly

## 🔍 Code Review Process

1. All PRs require review before merging
2. Tests must pass (if applicable)
3. Code must follow style guidelines
4. Documentation must be updated

## 📖 Documentation

When adding features:

1. Update `README.md` if user-facing
2. Add examples to `QUICKSTART.md` if relevant
3. Document any new functions in code comments
4. Update troubleshooting section if applicable

## 🎨 Commit Message Guidelines

Use clear, descriptive commit messages:

- `feat: Add Redis installation script`
- `fix: Resolve NVM PATH issue in WSL`
- `docs: Update README with new tool`
- `refactor: Improve error handling in common.sh`
- `test: Add tests for cloud detection`

## 🤝 Community

- Be respectful and constructive
- Help others in issues and discussions
- Share your use cases and improvements

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for making Dev Bootstrap better! 🙏
