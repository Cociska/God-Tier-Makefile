#!/bin/bash

# ==================================================
# Makefile Interactive Menu (fzf)
# ==================================================

# --- Targets ---
TARGETS=(
    "run"
    "auto_build"
    "debug"
    "docker"
    "leaks"
    "tests"
    "coverage"
    "commit"
    "branch"
    "restore"
    "git_log"
    "count"
    "stats"
    "api"
    "claude"
    "claude_fix"
    "update"
    "pomodoro"
    "coffee"
    "weather"
    "joke"
    "radio"
    "star_wars"
    "clean"
    "fclean"
    "re"
)

# --- Couleurs ---
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

echo -e "${C_CYAN}⚡ Makefile menu${C_RESET}"

SELECTED=$(echo "$LIST" | fzf \
    --height=60% \
    --layout=reverse \
    --border \
    --prompt="make > " \
    --pointer="▶" \
    --info=inline \
    --header="↑↓ navigate • Enter run • Esc cancel" \
    --color="fg:-1,bg:-1,hl:magenta,fg+:green,bg+:-1,hl+:magenta,info:yellow,prompt:cyan,pointer:green"
)

# --- Exécution ---
if [ -n "$SELECTED" ]; then
    echo -e "${C_GREEN}>>> Executing: make $SELECTED${C_RESET}"
    make --no-print-directory "$SELECTED"
else
    echo -e "${C_RED}✖ Cancelled.${C_RESET}"
fi

