#!/bin/bash

# --- COULEURS ---
RED='\033[31m'
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RESET='\033[0m'

# --- VÉRIFICATIONS PRÉALABLES ---
# Vérifie si on est dans un repo git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Erreur : Ce dossier n'est pas un dépôt Git.${RESET}"
    exit 1
fi

# Vérifie si fzf est installé
if ! command -v fzf &> /dev/null; then
    echo -e "${RED}Erreur : fzf n'est pas installé.${RESET}"
    exit 1
fi

# --- LOGIQUE RESTORE ---

# 1. Vérifie s'il y a des fichiers modifiés
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${GREEN}Working tree clean. Rien à restaurer !${RESET}"
    exit 0
else
    # 2. Sélection via FZF
    # Note : awk '{print $NF}' prend le dernier mot de la ligne (le nom du fichier)
    files=$(git status --short | fzf --multi \
        --preview 'git diff --color=always {-1}' \
        --preview-window=right:60%:wrap \
        --height=80% --layout=reverse --border \
        --prompt="🔥 RESTORE (Discard changes) > " \
        --header="[TAB] Select multiple | [ENTER] Confirm | [ESC] Cancel" \
        --color="header:italic:yellow" \
        | awk '{print $NF}')

    # 3. Confirmation et Action
    if [ -n "$files" ]; then
        echo -e "${RED}>>> Discarding changes in:${RESET}"
        echo "$files" | sed 's/^/  - /'
        
        # On passe les fichiers à git restore
        # xargs permet de gérer les noms de fichiers multiples proprement
        echo "$files" | xargs git restore
        
        echo -e "${GREEN}Fichiers restaurés à l'état d'origine.${RESET}"
    else
        echo -e "${CYAN}Opération annulée.${RESET}"
    fi
fi
