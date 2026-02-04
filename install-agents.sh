#!/bin/bash
#
# JEAW Agent Squad - Installer
# Instala el equipo de 13 agentes especializados desde GitHub
#
# Compatible con: Claude Code, Antigravity, Gemini CLI, Cursor, Codex
#

set -e

REPO_URL="https://github.com/javiereaw/jeaw-agent-squad.git"
TEMP_DIR=$(mktemp -d)
VERSION="2.2.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}JEAW Agent Squad - Installer${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""

# ============================================================================
# Parse arguments
# ============================================================================

OPTION=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --option|-o)
            OPTION="$2"
            shift 2
            ;;
        --version|-v)
            echo "JEAW Agent Squad Installer v${VERSION}"
            exit 0
            ;;
        --help|-h)
            echo "Usage: bash install-agents.sh [options]"
            echo ""
            echo "Options:"
            echo "  --option, -o N   Install option (1-5) non-interactively"
            echo "  --version, -v    Show version"
            echo "  --help, -h       Show this help"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# ============================================================================
# Menu
# ============================================================================

if [[ -z "$OPTION" ]]; then
    echo -e "${NC}Donde quieres instalar los agentes?${NC}"
    echo ""
    echo -e "  ${GREEN}1)${NC} Global Antigravity   -> ~/.gemini/antigravity/"
    echo -e "  ${GREEN}2)${NC} Global Claude Code   -> ~/.claude/"
    echo -e "  ${GREEN}3)${NC} Global ambos         -> Antigravity + symlink Claude Code"
    echo -e "  ${GREEN}4)${NC} Proyecto actual      -> .agent/ + symlink .claude/"
    echo -e "  ${GREEN}5)${NC} Ruta personalizada"
    echo ""
    read -p "Opcion [1-5]: " OPTION
fi

CANONICAL=""
SYMLINKS=()

case $OPTION in
    1)
        CANONICAL="$HOME/.gemini/antigravity"
        ;;
    2)
        CANONICAL="$HOME/.claude"
        ;;
    3)
        CANONICAL="$HOME/.gemini/antigravity"
        SYMLINKS=("$HOME/.claude")
        ;;
    4)
        CANONICAL="$(pwd)/.agent"
        SYMLINKS=("$(pwd)/.claude")
        ;;
    5)
        read -p "Ruta completa: " CANONICAL
        ;;
    *)
        echo -e "${RED}Opcion no valida${NC}"
        exit 1
        ;;
esac

# ============================================================================
# Download from repository
# ============================================================================

echo ""
echo -e "${CYAN}Descargando desde GitHub...${NC}"

if ! git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    echo -e "${RED}Error: No se pudo clonar el repositorio. Verifica tu conexion.${NC}"
    exit 1
fi

echo -e "  ${GREEN}Repositorio clonado${NC}"

# ============================================================================
# Copy files
# ============================================================================

echo ""
echo -e "${CYAN}Instalando en: $CANONICAL${NC}"

# Create destination if not exists
mkdir -p "$CANONICAL"

# Copy AGENTS.MD
if [[ -f "$TEMP_DIR/.agent/AGENTS.MD" ]]; then
    cp "$TEMP_DIR/.agent/AGENTS.MD" "$CANONICAL/"
    echo -e "  ${GREEN}AGENTS.MD copiado${NC}"
fi

# Copy skills/
if [[ -d "$TEMP_DIR/.agent/skills" ]]; then
    rm -rf "$CANONICAL/skills"
    cp -r "$TEMP_DIR/.agent/skills" "$CANONICAL/"
    echo -e "  ${GREEN}skills/ copiado (13 agentes)${NC}"
fi

# ============================================================================
# Create symlinks
# ============================================================================

if [[ ${#SYMLINKS[@]} -gt 0 ]]; then
    echo ""
    echo -e "${CYAN}Creando symlinks...${NC}"

    for SYMLINK_PATH in "${SYMLINKS[@]}"; do
        # Create parent directory if not exists
        mkdir -p "$SYMLINK_PATH"

        # Remove old rules symlink from previous versions
        OLD_RULES_SYMLINK="$SYMLINK_PATH/rules"
        if [[ -L "$OLD_RULES_SYMLINK" ]]; then
            rm -f "$OLD_RULES_SYMLINK"
        fi

        # Copy AGENTS.MD to symlink directory
        if [[ -f "$CANONICAL/AGENTS.MD" ]]; then
            cp "$CANONICAL/AGENTS.MD" "$SYMLINK_PATH/"
            echo -e "  ${GREEN}AGENTS.MD copiado a $SYMLINK_PATH${NC}"
        fi

        # Symlink for skills/
        SYMLINK_SKILLS="$SYMLINK_PATH/skills"
        CANONICAL_SKILLS="$CANONICAL/skills"

        # Remove existing symlink or directory
        if [[ -L "$SYMLINK_SKILLS" ]]; then
            rm -f "$SYMLINK_SKILLS"
        elif [[ -d "$SYMLINK_SKILLS" ]]; then
            rm -rf "$SYMLINK_SKILLS"
        fi

        # Create symlink (relative path)
        ln -s "../.agent/skills" "$SYMLINK_SKILLS" 2>/dev/null || \
            ln -s "$CANONICAL_SKILLS" "$SYMLINK_SKILLS"

        echo -e "  ${GREEN}$SYMLINK_SKILLS -> $CANONICAL_SKILLS${NC}"
    done
fi

# ============================================================================
# Clone external skill repositories
# ============================================================================

REPOS_DIR="$HOME/repos/agent-skills-sources"

echo ""
echo -e "${CYAN}Configurando repositorios de skills externos...${NC}"

clone_or_update_repo() {
    local repo_url="$1"
    local repo_dir="$2"
    local repo_name="$3"

    if [[ -d "$repo_dir/.git" ]]; then
        echo -e "  ${BLUE}Actualizando $repo_name...${NC}"
        (cd "$repo_dir" && git pull --quiet 2>/dev/null) || true
        echo -e "  ${GREEN}$repo_name actualizado${NC}"
    else
        echo -e "  ${BLUE}Clonando $repo_name...${NC}"
        if git clone --quiet "$repo_url" "$repo_dir" 2>/dev/null; then
            echo -e "  ${GREEN}$repo_name clonado${NC}"
        else
            echo -e "  ${YELLOW}No se pudo clonar $repo_name (sin red?)${NC}"
        fi
    fi
}

mkdir -p "$REPOS_DIR"
clone_or_update_repo "https://github.com/anthropics/anthropic-cookbook.git" "$REPOS_DIR/anthropic-cookbook" "Anthropic Cookbook"
clone_or_update_repo "https://github.com/anthropics/courses.git" "$REPOS_DIR/anthropic-courses" "Anthropic Courses"

# ============================================================================
# Cleanup
# ============================================================================

rm -rf "$TEMP_DIR"

# ============================================================================
# Summary
# ============================================================================

echo ""
echo -e "${CYAN}=============================================${NC}"
echo -e "${GREEN}Instalacion completada!${NC}"
echo ""
echo -e "${NC}Estructura instalada:${NC}"
echo -e "  ${CYAN}$CANONICAL${NC}"
echo -e "    ${GRAY}AGENTS.MD        <- Reglas globales + Iron Laws${NC}"
echo -e "    ${GRAY}skills/          <- 13 agentes especializados${NC}"

if [[ ${#SYMLINKS[@]} -gt 0 ]]; then
    echo ""
    echo -e "${NC}Symlinks creados:${NC}"
    for s in "${SYMLINKS[@]}"; do
        echo -e "  ${CYAN}$s/skills -> $CANONICAL/skills${NC}"
    done
fi

echo ""
echo -e "${NC}Agentes disponibles:${NC}"
echo -e "  ${GRAY}project-auditor, tech-lead, developer, security-hardener,${NC}"
echo -e "  ${GRAY}performance-optimizer, test-engineer, docs-writer, devops-engineer,${NC}"
echo -e "  ${GRAY}accessibility-auditor, orchestrator, agent-architect,${NC}"
echo -e "  ${GRAY}code-reviewer, systematic-debugger${NC}"
echo ""
echo -e "${YELLOW}Para actualizar en el futuro, vuelve a ejecutar este script.${NC}"
echo ""
