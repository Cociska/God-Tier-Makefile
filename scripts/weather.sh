#!/bin/bash

# --- CONFIG ---
DEFAULT_CITY="Lille"

# --- COULEURS ---
CYAN='\033[36m'
BOLD='\033[1m'
RESET='\033[0m'

clear
echo -e "${BOLD}${CYAN}🌤️  Weather Station${RESET}"
echo -e "${CYAN}Quelle ville souhaitez-vous voir ? (Par défaut : $DEFAULT_CITY)${RESET}"
read -p "> " USER_INPUT

# Si l'input est vide (-z), on utilise la valeur par défaut
if [ -z "$USER_INPUT" ]; then
    CITY="$DEFAULT_CITY"
else
    CITY="$USER_INPUT"
fi

echo -e "\n${CYAN}>>> Fetching weather for $CITY...${RESET}\n"

# Affichage météo (Format 3 est compact + Format v2 complet)
curl -s "wttr.in/$CITY?format=3"
echo ""
curl -s "wttr.in/$CITY?0"
