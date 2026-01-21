#!/usr/bin/env bash
#
# Test Script for Dev Bootstrap
# Quick validation without full installation
#

set -e

echo "🧪 Testing Dev Bootstrap Scripts"
echo "================================="
echo ""

# Test 1: Common functions
echo "Test 1: Loading common.sh..."
source scripts/common.sh
log "Test log message"
log_success "Test success message"
log_warning "Test warning message"
echo "✓ Common functions work"
echo ""

# Test 2: Environment detection
echo "Test 2: Environment detection..."
if is_linux; then
    echo "✓ Linux detected"
else
    echo "✗ Not Linux (this script expects Linux)"
    exit 1
fi

if is_wsl; then
    echo "✓ WSL environment detected"
elif is_cloud_vm; then
    echo "✓ Cloud VM environment detected"
else
    echo "✓ Standard Linux environment detected"
fi
echo ""

# Test 3: Helper functions
echo "Test 3: Helper functions..."
if command_exists bash; then
    echo "✓ command_exists works"
else
    echo "✗ command_exists failed"
    exit 1
fi
echo ""

# Test 4: Detection scripts
echo "Test 4: Detection scripts..."
bash detection/detect_linux.sh
echo "✓ Detection scripts work"
echo ""

# Test 5: Script permissions
echo "Test 5: Checking script permissions..."
if [ -x bootstrap.sh ]; then
    echo "✓ bootstrap.sh is executable"
else
    echo "✗ bootstrap.sh is not executable"
    exit 1
fi

if [ -x scripts/common.sh ]; then
    echo "✓ scripts are executable"
else
    echo "✗ scripts are not executable"
    exit 1
fi
echo ""

# Test 6: File structure
echo "Test 6: Verifying file structure..."
required_files=(
    "bootstrap.sh"
    "scripts/common.sh"
    "scripts/install_python.sh"
    "scripts/install_node.sh"
    "scripts/install_uv.sh"
    "scripts/install_pnpm.sh"
    "scripts/install_docker.sh"
    "scripts/install_postgres.sh"
    "scripts/install_flyctl.sh"
    "scripts/configure_git.sh"
    "scripts/configure_git_aliases.sh"
    "scripts/configure_git_auth.sh"
    "scripts/editor_helpers.sh"
    "scripts/wsl_tweaks.sh"
    "scripts/linux_tweaks.sh"
    "detection/detect_wsl.sh"
    "detection/detect_cloud_vm.sh"
    "detection/detect_linux.sh"
    "config/gitconfig.example"
    "config/bashrc.append"
    "config/wsl.conf"
    "README.md"
)

missing=0
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "✗ Missing: $file"
        ((missing++))
    fi
done

if [ $missing -eq 0 ]; then
    echo "✓ All required files present"
else
    echo "✗ Missing $missing file(s)"
    exit 1
fi
echo ""

# Summary
echo "================================="
echo "✅ All tests passed!"
echo ""
echo "Ready to use. Run:"
echo "  ./bootstrap.sh"
echo ""
