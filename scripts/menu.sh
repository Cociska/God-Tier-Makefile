#!/bin/bash

# --- Configuration ---
TARGETS=(
    "run"
    "auto_build"
    "tests"
    "leaks"
    "debug"
    "docker"
    "commit"
    "branch"
    "restore"
    "git_log"
    "pomodoro"
    "coffee"
    "weather"
    "star_wars"
    "clean"
    "fclean"
)

# --- Couleurs pour echo (Bash) ---
C_RESET='\033[0m'
C_CYAN='\033[1;36m'
C_GREEN='\033[1;32m'
C_RED='\033[1;31m'

# --- Vérification des dépendances ---
if ! command -v fzf &> /dev/null; then
    echo -e "${C_RED}Erreur: 'fzf' n'est pas installé.${C_RESET}"
    exit 1
fi

# --- Construction du Menu ---
LIST=$(printf "%s\n" "${TARGETS[@]}")

echo -e "${C_CYAN}⚡ Select a Make target:${C_RESET}"

# Lancement de FZF avec des couleurs nommées (valides)
# fg:-1 signifie "couleur par défaut du terminal"
SELECTED=$(echo "$LIST" | fzf \
    --height=50% \
    --layout=reverse \
    --border \
    --prompt="Make > " \
    --pointer="▶" \
    --marker="✓" \
    --info=inline \
    --header="Use arrows to move, Enter to select" \
    --color="fg:-1,bg:-1,hl:magenta,fg+:green,bg+:-1,hl+:magenta,info:yellow,prompt:cyan,pointer:green"
)

# --- Exécution ---
if [ -n "$SELECTED" ]; then
    echo -e "${C_GREEN}>>> Executing: make $SELECTED ${C_RESET}"
    make --no-print-directory "$SELECTED"
else
    echo -e "${C_RED}✖ Cancelled.${C_RESET}"
fi
