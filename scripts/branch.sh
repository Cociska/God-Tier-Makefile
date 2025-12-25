#!/bin/bash

# --- COULEURS ---
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

# --- VÉRIFICATIONS ---
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Erreur : Pas un dépôt Git.${RESET}"
    exit 1
fi

# --- LOGIQUE ---

# 1. On récupère la liste des branches locales proprement
# %(refname:short) permet d'avoir juste "main" au lieu de "refs/heads/main"
branches=$(git branch --format='%(refname:short)')

# 2. On lance FZF avec l'option --print-query
# Cela permet de récupérer CE QUE TU TAPES (query) en plus de CE QUE TU SÉLECTIONNES (selection)
# output contiendra :
# Ligne 1 : Ce que tu as tapé
# Ligne 2 : La branche sélectionnée (si trouvée)
output=$(echo "$branches" | fzf --print-query \
    --height=30% --layout=reverse --border \
    --prompt="🌿 Branch > " \
    --header="Type to filter OR type new name to create" \
    --info=inline)

# Si l'utilisateur a fait Echap (output vide)
if [ -z "$output" ]; then
    echo -e "${CYAN}Opération annulée.${RESET}"
    exit 0
fi

# On sépare la query (ligne 1) de la sélection (ligne 2)
query=$(echo "$output" | head -n1)
selection=$(echo "$output" | tail -n1)

# --- ANALYSE DU CHOIX ---

# Cas 1 : L'utilisateur a sélectionné une branche existante
# (La sélection n'est pas vide ET elle existe dans la liste des branches)
if [ -n "$selection" ] && echo "$branches" | grep -q "^$selection$"; then
    echo -e "${BLUE}>>> Switching to branch ${YELLOW}$selection${BLUE}...${RESET}"
    git checkout "$selection"

# Cas 2 : L'utilisateur a tapé un nom qui n'existe pas (Création)
elif [ -n "$query" ]; then
    echo -e "${YELLOW}La branche '${query}' n'existe pas.${RESET}"
    echo -n "Voulez-vous la créer ? (y/n) "
    read -r response
    if [ "$response" == "y" ]; then
        echo -e "${GREEN}>>> Creating and switching to ${query}...${RESET}"
        git checkout -b "$query"
    else
        echo -e "${CYAN}Annulé.${RESET}"
    fi

# Cas 3 : Cas bizarre (vide)
else
    echo -e "${RED}Erreur ou annulation.${RESET}"
fi
