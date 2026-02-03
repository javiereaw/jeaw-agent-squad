#!/bin/bash
# ============================================================================
# 🤖 AI Agent Team - Updater
# Checks for updates and re-installs if a new version is available
# ============================================================================

set +e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration — change REPO_OWNER/REPO_NAME to match your GitHub repo
REPO_OWNER="${AGENT_TEAM_OWNER:-YOUR_GITHUB_USER}"
REPO_NAME="${AGENT_TEAM_REPO:-jeaw-agent-squad}"
BRANCH="${AGENT_TEAM_BRANCH:-main}"
RAW_BASE="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}"

echo ""
echo -e "${CYAN}🤖 AI Agent Team - Updater${NC}"
echo -e "${CYAN}════════════════════════════════════════${NC}"

# ============================================================================
# Check current version
# ============================================================================

CURRENT_VERSION="unknown"

# Check project-level version
if [ -f ".agent/.version" ]; then
  CURRENT_VERSION=$(cat .agent/.version)
# Check global Antigravity version
elif [ -f "$HOME/.gemini/antigravity/.version" ]; then
  CURRENT_VERSION=$(cat "$HOME/.gemini/antigravity/.version")
# Check global Claude Code version
elif [ -f "$HOME/.claude/.version" ]; then
  CURRENT_VERSION=$(cat "$HOME/.claude/.version")
fi

echo -e "  Versión instalada: ${YELLOW}${CURRENT_VERSION}${NC}"

# ============================================================================
# Check latest version from GitHub
# ============================================================================

echo -e "  Comprobando última versión..."

LATEST_VERSION=$(curl -fsSL "${RAW_BASE}/VERSION" 2>/dev/null | tr -d '[:space:]')

if [ -z "$LATEST_VERSION" ]; then
  echo -e "  ${RED}✗${NC} No se pudo comprobar la versión remota."
  echo -e "    Verifica tu conexión o la configuración del repo:"
  echo -e "    REPO_OWNER=${REPO_OWNER} REPO_NAME=${REPO_NAME}"
  echo ""
  echo -e "  Para configurar tu repo, ejecuta:"
  echo -e "    ${YELLOW}export AGENT_TEAM_OWNER=tu-usuario-github${NC}"
  echo -e "    ${YELLOW}export AGENT_TEAM_REPO=jeaw-agent-squad${NC}"
  exit 1
fi

echo -e "  Última versión:   ${GREEN}${LATEST_VERSION}${NC}"

# ============================================================================
# Compare versions
# ============================================================================

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo ""
  echo -e "  ${GREEN}✅ Ya estás en la última versión.${NC}"
  echo ""
  exit 0
fi

echo ""
echo -e "  ${YELLOW}⬆ Actualización disponible: ${CURRENT_VERSION} → ${LATEST_VERSION}${NC}"
echo ""
read -p "  ¿Actualizar ahora? [Y/n]: " CONFIRM
CONFIRM=${CONFIRM:-Y}

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo -e "  Actualización cancelada."
  exit 0
fi

# ============================================================================
# Download and run latest installer
# ============================================================================

echo ""
echo -e "${BLUE}⬇ Descargando instalador v${LATEST_VERSION}...${NC}"

TEMP_INSTALLER=$(mktemp /tmp/install-agents-XXXXX.sh)
curl -fsSL "${RAW_BASE}/install-agents.sh" -o "$TEMP_INSTALLER" 2>/dev/null

if [ ! -s "$TEMP_INSTALLER" ]; then
  echo -e "  ${RED}✗${NC} Error descargando el instalador."
  rm -f "$TEMP_INSTALLER"
  exit 1
fi

echo -e "${GREEN}✅ Descargado. Ejecutando instalador...${NC}"
echo ""

bash "$TEMP_INSTALLER"
rm -f "$TEMP_INSTALLER"

echo ""
echo -e "${GREEN}✅ Actualización a v${LATEST_VERSION} completada.${NC}"
echo ""
