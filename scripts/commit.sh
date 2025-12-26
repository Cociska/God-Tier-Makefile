#!/bin/bash

# --- Couleurs ---
C_RESET='\033[0m'
C_GREEN='\033[1;32m'
C_CYAN='\033[1;36m'

# 1. Nettoyage silencieux
make --no-print-directory fclean > /dev/null 2>&1

# 2. Demande du message (Seule chose visible pour l'instant)
echo -e "${C_CYAN}Entrez le message de commit :${C_RESET}"
read -e -p "> " MSG

# Message par défaut si vide
if [ -z "$MSG" ]; then
    MSG="Auto-update"
fi

# 3. La magie silencieuse
# On ajoute tout, on commit et on push en envoyant tout le blabla technique à la poubelle
git add . > /dev/null 2>&1
git commit -m "$MSG" > /dev/null 2>&1
git push > /dev/null 2>&1

# 4. Le seul feedback que tu veux
echo -e "${C_GREEN}Changes pushed to GitHub <3${C_RESET}"
