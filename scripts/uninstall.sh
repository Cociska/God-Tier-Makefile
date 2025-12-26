#!/bin/bash

# --- COULEURS ---
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'
BOLD='\033[1m'

# --- CHEMINS ---
INSTALL_DIR="$HOME/Makefile"
CONFIG_DIR="$HOME/.config/god-tier-makefile"
GLOBAL_CMD="/usr/local/bin/makefile"

clear
echo -e "${RED}${BOLD}☢️   PROTOCOL D'AUTO-DESTRUCTION INITIÉ   ☢️${RESET}"
echo -e "${YELLOW}Vous êtes sur le point de désinstaller God Tier Makefile.${RESET}"
echo -e "Cela va supprimer :"
echo -e "  1. La commande système '${BOLD}makefile${RESET}'"
echo -e "  2. Les scripts installés dans '${BOLD}$INSTALL_DIR${RESET}'"
echo -e "  3. Vos clés API et configurations"
echo ""
read -p "Êtes-vous sûr de vouloir continuer ? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Annulé. Longue vie au code.${RESET}"
    exit 1
fi

echo ""

# 1. Suppression de la commande globale
if [ -f "$GLOBAL_CMD" ]; then
    echo -e "${CYAN}>>> Suppression de la commande globale (sudo requis)...${RESET}"
    if sudo rm "$GLOBAL_CMD"; then
        echo -e "${GREEN}✅ Commande 'makefile' supprimée.${RESET}"
    else
        echo -e "${RED}❌ Échec de la suppression de la commande.${RESET}"
    fi
else
    echo -e "${YELLOW}ℹ️  Commande globale introuvable (déjà supprimée ?)${RESET}"
fi

# 2. Suppression du dossier d'installation
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${CYAN}>>> Suppression des scripts ($INSTALL_DIR)...${RESET}"
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✅ Scripts supprimés.${RESET}"
fi

# 3. Suppression des configs (API Key)
if [ -d "$CONFIG_DIR" ]; then
    echo -e "${CYAN}>>> Suppression des configurations ($CONFIG_DIR)...${RESET}"
    rm -rf "$CONFIG_DIR"
    echo -e "${GREEN}✅ Config supprimée.${RESET}"
fi

# 4. Suppression du Repo (Self-destruct)
CURRENT_DIR=$(pwd)
echo ""
echo -e "${RED}${BOLD}Dernière étape :${RESET} Voulez-vous supprimer ce dossier (le dépôt Git) ?"
echo -e "Chemin : $CURRENT_DIR"
read -p "(y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}>>> Suppression du dépôt source...${RESET}"
    # On sort du dossier pour pouvoir le supprimer
    cd ..
    rm -rf "$CURRENT_DIR"
    echo -e "${GREEN}✅ Dépôt supprimé.${RESET}"
    echo -e "${BOLD}Désinstallation complète. Au revoir ! 👋${RESET}"
else
    echo -e "${GREEN}✅ Désinstallation terminée (Le dépôt a été conservé).${RESET}"
fi
