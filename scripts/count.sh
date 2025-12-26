#!/bin/bash
CYAN='\033[36m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}${CYAN}Lines of C code:${RESET}"
echo -e "${CYAN}------------------${RESET}"

# Vérification : Est-ce qu'il y a des fichiers passés en argument ?
if [ $# -eq 0 ]; then
    # Aucun fichier -> on affiche 0 directement pour éviter que wc n'attende une entrée clavier
    echo -e "${BOLD}${CYAN}0 total${RESET}"
else
    # On compte les lignes (2>/dev/null cache les erreurs si un fichier est introuvable)
    echo -e "${BOLD}${CYAN}$(wc -l "$@" 2>/dev/null | tail -n 1)${RESET}"
fi

echo -e "${CYAN}------------------${RESET}"
echo ""
