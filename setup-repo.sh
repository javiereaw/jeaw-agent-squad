#!/bin/bash
# ============================================================================
# 🚀 Setup script — run ONCE after creating the GitHub repo
# Configures your GitHub username in all files and pushes
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}🚀 jeaw-agent-squad — Setup${NC}"
echo -e "${CYAN}════════════════════════════════════════${NC}"
echo ""

# ============================================================================
# Step 1: Get GitHub username
# ============================================================================

read -p "Tu usuario de GitHub: " GH_USER

if [ -z "$GH_USER" ]; then
  echo -e "${RED}✗ Necesito tu usuario de GitHub${NC}"
  exit 1
fi

echo ""
echo -e "${YELLOW}Configurando repo para: ${GH_USER}/jeaw-agent-squad${NC}"
echo ""

# ============================================================================
# Step 2: Replace placeholders in all files
# ============================================================================

sed -i "s/YOUR_GITHUB_USER/${GH_USER}/g" README.md
sed -i "s/YOUR_GITHUB_USER/${GH_USER}/g" update.sh

echo -e "  ${GREEN}✅${NC} README.md actualizado"
echo -e "  ${GREEN}✅${NC} update.sh actualizado"

# ============================================================================
# Step 3: Commit the changes
# ============================================================================

git add README.md update.sh
git commit -m "chore: configure repo for ${GH_USER}/jeaw-agent-squad"

echo -e "  ${GREEN}✅${NC} Cambios committed"

# ============================================================================
# Step 4: Add remote and push
# ============================================================================

git remote add origin "git@github.com:${GH_USER}/jeaw-agent-squad.git" 2>/dev/null \
  || git remote set-url origin "git@github.com:${GH_USER}/jeaw-agent-squad.git"

echo -e "  ${GREEN}✅${NC} Remote configurado: git@github.com:${GH_USER}/jeaw-agent-squad.git"

echo ""
echo -e "${CYAN}Pushing to GitHub...${NC}"
git push -u origin main

if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}════════════════════════════════════════${NC}"
  echo -e "${GREEN}✅ ¡Repo listo!${NC}"
  echo -e "${GREEN}════════════════════════════════════════${NC}"
  echo ""
  echo -e "  URL: ${CYAN}https://github.com/${GH_USER}/jeaw-agent-squad${NC}"
  echo ""
  echo -e "  Instalar en un proyecto:"
  echo -e "    ${YELLOW}bash <(curl -fsSL https://raw.githubusercontent.com/${GH_USER}/jeaw-agent-squad/main/install-agents.sh) --option 4${NC}"
  echo ""
  echo -e "  Este script (setup-repo.sh) ya no se necesita. Puedes borrarlo."
else
  echo ""
  echo -e "${RED}✗ Error al hacer push. Verifica que:${NC}"
  echo -e "  1. El repo existe: ${CYAN}https://github.com/${GH_USER}/jeaw-agent-squad${NC}"
  echo -e "  2. Es privado y tienes acceso SSH configurado"
  echo -e ""
  echo -e "  Crear el repo desde CLI:"
  echo -e "    ${YELLOW}gh repo create jeaw-agent-squad --private${NC}"
  echo -e ""
  echo -e "  Luego re-ejecuta:"
  echo -e "    ${YELLOW}git push -u origin main${NC}"
fi
