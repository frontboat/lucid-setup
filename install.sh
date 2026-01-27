#!/bin/bash
set -e

# Colors
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

APP_NAME="${1:-lucid-quickstart}"
CLEANUP_DIR=""
LOG_FILE=$(mktemp)

# Cleanup function for failures/interrupts
cleanup() {
    local exit_code=$?

    # Kill any child processes
    pkill -P $$ 2>/dev/null || true

    if [[ -n "$CLEANUP_DIR" && -d "$CLEANUP_DIR" ]]; then
        echo -e "\n${RED}✗${RESET} Installation failed, cleaning up..."
        rm -rf "$CLEANUP_DIR"
    fi
    rm -f "$LOG_FILE"
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Validate app name
if [[ ! "$APP_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo -e "${RED}✗${RESET} Invalid app name. Use only letters, numbers, hyphens, underscores."
    exit 1
fi

# Check if directory already exists
if [[ -d "$APP_NAME" ]]; then
    echo -e "${RED}✗${RESET} Directory ${BOLD}$APP_NAME${RESET} already exists"
    exit 1
fi

echo ""
echo -e "${BOLD}${CYAN}  Lucid Agents${RESET}"
echo -e "${DIM}  Bun + Hono Starter${RESET}"
echo ""

# Check for bun
if ! command -v bun &> /dev/null; then
    echo -e "${RED}✗${RESET} bun is not installed"
    echo -e "  Install it from ${CYAN}https://bun.sh${RESET}"
    exit 1
fi

# Create basic Bun + Hono template
echo -e "${DIM}Creating Bun + Hono app...${RESET}"
if ! bun create hono@latest "$APP_NAME" --template bun --pm bun --install > "$LOG_FILE" 2>&1; then
    echo -e "${RED}✗${RESET} Failed to create app"
    cat "$LOG_FILE"
    exit 1
fi
CLEANUP_DIR="$APP_NAME"
echo -e "${GREEN}✓${RESET} Created ${BOLD}$APP_NAME${RESET}"

# Add Lucid Agents packages
echo -e "${DIM}Adding Lucid Agents packages...${RESET}"
cd "$APP_NAME"
if ! bun add @lucid-agents/a2a \
        @lucid-agents/analytics \
        @lucid-agents/ap2 \
        @lucid-agents/api-sdk \
        @lucid-agents/cli \
        @lucid-agents/core \
        @lucid-agents/express \
        @lucid-agents/hono \
        @lucid-agents/http \
        @lucid-agents/identity \
        @lucid-agents/payments \
        @lucid-agents/scheduler \
        @lucid-agents/tanstack \
        @lucid-agents/types \
        @lucid-agents/wallet > "$LOG_FILE" 2>&1; then
    echo -e "${RED}✗${RESET} Failed to add packages"
    cat "$LOG_FILE"
    exit 1
fi
echo -e "${GREEN}✓${RESET} Added 15 packages"

# Success - don't clean up the directory
CLEANUP_DIR=""

echo ""
echo -e "${GREEN}Done!${RESET} To start:"
echo ""
echo -e "  ${DIM}cd${RESET} $APP_NAME"
echo -e "  ${DIM}bun${RESET} dev"
echo ""
echo -e "${DIM}Using Claude Code? Add the Daydreams skills:${RESET}"
echo -e "  ${CYAN}/plugin marketplace add daydreamsai/skills-market${RESET}"
echo -e "  ${CYAN}/plugin install lucid-agents-sdk@daydreams-skills${RESET}"
echo ""
