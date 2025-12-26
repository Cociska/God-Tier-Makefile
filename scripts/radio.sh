#!/bin/bash

# --- CONFIG ---
DEFAULT_URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"

# --- COULEURS ---
PURPLE='\033[35m'
CYAN='\033[36m'
GREEN='\033[32m'
RESET='\033[0m'

echo -e "${PURPLE}🎧 Radio Station${RESET}"
echo -e "${PURPLE}Entrez l'URL Youtube du live (Par défaut : Lofi Girl)${RESET}"
read -p "> " USER_INPUT

# Gestion de la valeur par défaut
if [ -z "$USER_INPUT" ]; then
    URL="$DEFAULT_URL"
    NAME="Lofi Girl"
else
    URL="$USER_INPUT"
    NAME="Custom Radio"
fi

echo -e "${CYAN}>>> Tuning in to $NAME...${RESET}"

# On vérifie si mpv est installé
if ! command -v mpv &> /dev/null; then
    echo -e "${RED}Erreur : mpv n'est pas installé.${RESET}"
    exit 1
fi

# Lance en background, silencieux, et se détache du terminal
nohup mpv --no-video --really-quiet "$URL" >/dev/null 2>&1 &

echo -e "${GREEN}✅ Radio started in background.${RESET}"
echo -e "${CYAN}(Utilisez 'killall mpv' pour stopper)${RESET}"
