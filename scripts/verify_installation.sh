#!/usr/bin/env bash
#
# Verify Bootstrap Installation
# Checks if all tools were installed correctly
#

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo -e "\n${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  🔍 Verifying Installation 🔍        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}\n"

errors=0

check_command() {
    local cmd=$1
    local name=$2
    local version_flag=${3:---version}
    
    echo -n "Checking $name... "
    if command_exists "$cmd"; then
        echo -e "${GREEN}✓ Installed${NC}"
        "$cmd" $version_flag 2>&1 | head -n 1 | sed 's/^/  → /'
    else
        echo -e "${RED}✗ Not Found${NC}"
        ((errors++))
    fi
}

# Core tools
check_command "python3" "Python"
check_command "uv" "uv"
check_command "node" "Node.js" "-v"
check_command "npm" "npm" "-v"
check_command "pnpm" "pnpm"
check_command "docker" "Docker"
check_command "psql" "PostgreSQL Client"
check_command "flyctl" "flyctl" "version"

echo ""
check_command "git" "Git"

# Check Git config
echo -n "Checking Git configuration... "
if git config --global user.name &>/dev/null; then
    echo -e "${GREEN}✓ Configured${NC}"
    echo "  → Name: $(git config --global user.name)"
    echo "  → Email: $(git config --global user.email)"
else
    echo -e "${RED}✗ Not Configured${NC}"
    ((errors++))
fi

# Check environment detection
echo -e "\n${BLUE}Environment:${NC}"
if is_wsl; then
    echo "  → WSL detected"
elif is_cloud_vm; then
    echo "  → Cloud VM detected"
else
    echo "  → Standard Linux"
fi

# Summary
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
if [ $errors -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Found $errors error(s)${NC}"
    echo -e "${YELLOW}Run: source ~/.bashrc${NC}"
    exit 1
fi
