#!/bin/bash

# --- CONFIG ---
# Chemin par défaut où le repo est cloné
REPO_PATH="$HOME/God-Tier-Makefile" 
RESET='\033[0m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RED='\033[31m'

# --- LOGIQUE ---
echo -e "${CYAN}>>> Checking for updates in $REPO_PATH...${RESET}"

if [ ! -d "$REPO_PATH" ]; then
    echo -e "${RED}Erreur : Le dossier $REPO_PATH n'existe pas.${RESET}"
    echo "Veuillez modifier le chemin dans scripts/update.sh si nécessaire."
    exit 1
fi

# 1. Pull Git
cd "$REPO_PATH" || exit
echo -e "${YELLOW}>>> Pulling changes from GitHub...${RESET}"
git pull

# 2. Relancer l'install (met à jour les scripts + le Makefile de référence)
echo -e "${YELLOW}>>> Updating scripts & Makefile reference...${RESET}"
./install.sh

# 3. Message de fin
echo -e "${GREEN}✅ Update complete!${RESET}"
echo -e "⚠️  ${CYAN}Latest Makefile version is available at:${RESET} $HOME/Makefile/Makefile"
