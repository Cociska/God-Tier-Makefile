#!/bin/bash

# --- CONFIG ---
# Récupère le dossier où se trouve ce script (pour trouver claude.py)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SCRIPT="$SCRIPT_DIR/claude.py"
LOG_FILE="build.log"

# --- COULEURS ---
CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

# --- LOGIQUE ---
echo -e "${CYAN}>>> Attempting build...${RESET}"

# On lance make (en silence dans le log)
# Si make échoue (retourne une erreur), on rentre dans le 'else'
if make --no-print-directory > "$LOG_FILE" 2>&1; then
    echo -e "${GREEN}>>> Build successful! No AI needed.${RESET}"
else
    echo -e "${RED}>>> Build failed! Asking Claude...${RESET}"
    
    # On lit le fichier de log pour le donner à Claude
    ERROR_LOG=$(cat "$LOG_FILE")
    
    # Appel du script Python avec le prompt
    "$CLAUDE_SCRIPT" "Voici mon erreur de compilation, explique-la brièvement et donne une solution : $ERROR_LOG"
fi

# Nettoyage
rm -f "$LOG_FILE"
