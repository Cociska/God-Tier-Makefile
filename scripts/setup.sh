#!/bin/bash

# --- CONFIG ---
# On pointe vers le Makefile "maître" stocké chez toi
TEMPLATE_PATH="$HOME/Makefile/Makefile"
CURRENT_DIR=$(pwd)

# --- COULEURS ---
GREEN='\033[32m'
RED='\033[31m'
CYAN='\033[36m'
YELLOW='\033[33m'
RESET='\033[0m'

echo -e "${CYAN}⚡ Initializing God Tier Environment in: $CURRENT_DIR ...${RESET}"

# 1. Vérification : Est-ce qu'un Makefile existe déjà ?
if [ -f "$CURRENT_DIR/Makefile" ]; then
    echo -e "${RED}⚠️  Attention : Un Makefile existe déjà ici !${RESET}"
    echo -e "${YELLOW}Voulez-vous l'écraser ? (y/N)${RESET}"
    read -n 1 -r REPLY
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Annulé. Votre Makefile actuel est sauf.${RESET}"
        exit 1
    fi
fi

# 2. Vérification : Est-ce que le template source existe ?
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo -e "${RED}Erreur critique : Le template est introuvable à $TEMPLATE_PATH${RESET}"
    echo "Avez-vous bien lancé ./install.sh la première fois ?"
    exit 1
fi

# 3. La copie magique
cp "$TEMPLATE_PATH" "$CURRENT_DIR/Makefile"

echo -e "${GREEN}✅ Makefile généré avec succès !${RESET}"
echo -e "👉 Vous pouvez maintenant taper '${YELLOW}make help${RESET}' pour commencer."
