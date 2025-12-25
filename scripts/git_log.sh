#!/bin/bash

# --- COULEURS ---
RED='\033[31m'
RESET='\033[0m'

# --- VERIF ---
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Erreur : Pas un dépôt Git.${RESET}"
    exit 1
fi

# --- LOGIQUE ---
# 1. git log formaté (Hash en couleur, Date relative, Message, Auteur)
# 2. fzf pour naviguer
# 3. --preview : C'est là que la magie opère. On récupère le hash (le 1er mot) et on fait git show.

git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
fzf --ansi --no-sort --reverse --height=90% --border \
    --prompt="📜 HISTORY > " \
    --header="[UP/DOWN] Navigate | [ENTER] View Details | [q] Quit" \
    --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % git show --color=always %" \
    --preview-window=right:60%:wrap \
    --bind "enter:execute(echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % git show --color=always % | less -R)"
