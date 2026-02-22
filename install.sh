#!/bin/bash
# ================================================================
# OpenClaw Unraid Template Installer
# https://github.com/darksoon/unraid-openclaw
# ================================================================
set -e

TEMPLATE_DIR="/boot/config/plugins/dockerMan/templates-user"
APPDATA_DIR="/mnt/user/appdata/openclaw"
REPO_URL="https://raw.githubusercontent.com/darksoon/unraid-openclaw/main"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "============================================"
echo "  🦞 OpenClaw Unraid Template Installer"
echo "============================================"
echo ""

# --- Check we're on Unraid ---
if [ ! -d "/boot/config/plugins" ]; then
    echo -e "${RED}ERROR: This doesn't look like an Unraid system.${NC}"
    echo "This script should be run via SSH on your Unraid server."
    exit 1
fi

# --- Download template ---
echo -e "${GREEN}[1/3]${NC} Installing template..."
mkdir -p "$TEMPLATE_DIR"

if curl -fsSL -o "${TEMPLATE_DIR}/openclaw.xml" "${REPO_URL}/openclaw.xml"; then
    echo "  ✅ Template installed to ${TEMPLATE_DIR}/openclaw.xml"
else
    echo -e "${RED}  ❌ Failed to download template. Check your internet connection.${NC}"
    exit 1
fi

# --- Create directories and download .env template ---
echo -e "${GREEN}[2/3]${NC} Creating directories..."
mkdir -p "${APPDATA_DIR}/config"
mkdir -p "${APPDATA_DIR}/workspace"
mkdir -p "${APPDATA_DIR}/projects"
mkdir -p "${APPDATA_DIR}/homebrew"
echo "  ✅ Created ${APPDATA_DIR}/{config,workspace,projects,homebrew}"

# Download .env.example if .env doesn't exist yet
if [ ! -f "${APPDATA_DIR}/config/.env" ]; then
    if curl -fsSL -o "${APPDATA_DIR}/config/.env" "${REPO_URL}/.env.example"; then
        echo "  ✅ Created ${APPDATA_DIR}/config/.env — edit to add your API keys"
    else
        echo -e "  ${YELLOW}⚠️  Could not download .env template (continuing anyway)${NC}"
    fi
else
    echo "  ✅ .env already exists — skipping download"
fi

# --- Check for existing container ---
echo -e "${GREEN}[3/3]${NC} Checking environment..."

if docker ps -a --format '{{.Names}}' | grep -q "^OpenClaw$"; then
    echo -e "  ${YELLOW}⚠️  OpenClaw container already exists.${NC}"
    echo "  To update: Docker UI → OpenClaw → Force Update"
    echo "  To recreate: Remove old container first, then use the new template."
fi

# --- Check Watchtower ---
if docker ps --format '{{.Names}}' | grep -q "watchtower"; then
    echo "  ✅ Watchtower detected — auto-updates will work."
else
    echo -e "  ${YELLOW}ℹ️  Watchtower not found (optional).${NC}"
    echo "  The template includes a Watchtower label. If you install Watchtower later,"
    echo "  it will auto-update OpenClaw."
fi

# --- Optional: SearXNG ---
echo ""
if docker ps -a --format '{{.Names}}' | grep -q "searxng"; then
    SEARXNG_PORT=$(docker port searxng 8080/tcp 2>/dev/null | head -1 | cut -d: -f2)
    echo -e "  ✅ SearXNG detected on port ${SEARXNG_PORT:-8080}."
    echo "  Set SEARXNG_URL in the OpenClaw template to use free web search!"
else
    echo -e "  ${YELLOW}💡 TIP: Want free unlimited web search?${NC}"
    echo "  Run SearXNG on Unraid:"
    echo ""
    echo "  docker run -d --name searxng --restart unless-stopped \\"
    echo "    -p 8888:8080 -e SEARXNG_BASE_URL=http://localhost:8888 \\"
    echo "    searxng/searxng:latest"
    echo ""
    echo "  Then set SearXNG URL in the template to http://YOUR-IP:8888"
fi

# --- Done ---
echo ""
echo "============================================"
echo "  ✅ Installation complete!"
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Edit .env file: nano ${APPDATA_DIR}/config/.env"
echo "  2. Add your API keys to the .env file"
echo "  3. Go to Unraid Docker page and reload"
echo "  4. Click 'Add Container'"
echo "  5. Select template 'OpenClaw'"
echo "  6. Set 'Env File' to: ${APPDATA_DIR}/config/.env"
echo "  7. Leave template variables empty (or use both)"
echo "  8. Click Apply"
echo ""
echo "  Access: http://YOUR-IP:18789/?token=YOUR_TOKEN (from .env)"
echo "  Onboard: Unraid Docker → OpenClaw → Console → openclaw onboard"
echo ""
echo "  Docs:   https://docs.openclaw.ai"
echo "  Issues: https://github.com/darksoon/unraid-openclaw/issues"
echo ""
