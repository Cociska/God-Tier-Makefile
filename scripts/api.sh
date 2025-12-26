#!/bin/bash

# --- CONFIG ---
CONFIG_DIR="$HOME/.config/god-tier-makefile"
KEY_FILE="$CONFIG_DIR/anthropic.key"

# Couleurs
C_RESET='\033[0m'
C_CYAN='\033[1;36m'
C_GREEN='\033[1;32m'
C_RED='\033[1;31m'
C_YELLOW='\033[1;33m'

# Création du dossier si inexistant
mkdir -p "$CONFIG_DIR"

# --- FONCTIONS ---
set_key() {
    echo -e "${C_CYAN}Entrez votre clé API Anthropic (sk-...) :${C_RESET}"
    echo -e "${C_YELLOW}(Saisie cachée 🔒 : rien ne s'affichera pendant que vous tapez, c'est normal !)${C_RESET}"
    
    # -s pour silent (caché), -p pour le prompt
    read -s -p "> " NEW_KEY
    echo "" # Saut de ligne après la saisie cachée
    
    if [[ -z "$NEW_KEY" ]]; then
        echo -e "${C_RED}Erreur : Clé vide.${C_RESET}"
        return
    fi

    # On écrit la clé et on sécurise le fichier
    echo -n "$NEW_KEY" > "$KEY_FILE"
    chmod 600 "$KEY_FILE"
    echo -e "${C_GREEN}✅ Clé enregistrée avec succès !${C_RESET}"
}

show_key() {
    if [ -f "$KEY_FILE" ]; then
        KEY=$(cat "$KEY_FILE")
        # On affiche juste le début et la fin
        if [ ${#KEY} -gt 15 ]; then
            HIDDEN_KEY="${KEY:0:10}..................${KEY: -5}"
        else
            HIDDEN_KEY="***********"
        fi
        echo -e "${C_YELLOW}Clé actuelle :${C_RESET} $HIDDEN_KEY"
    else
        echo -e "${C_RED}Aucune clé enregistrée.${C_RESET}"
    fi
}

delete_key() {
    if [ -f "$KEY_FILE" ]; then
        rm "$KEY_FILE"
        echo -e "${C_RED}🗑️  Clé supprimée.${C_RESET}"
    else
        echo -e "${C_RED}Rien à supprimer.${C_RESET}"
    fi
}

# --- MENU FZF ---
OPTIONS="🔑 Set/Update API Key\n👁️  Show Current Key\n🗑️  Delete Key"

SELECTED=$(echo -e "$OPTIONS" | fzf \
    --height=20% --layout=reverse --border \
    --prompt="API MANAGER > " \
    --header="Manage your AI credentials")

case "$SELECTED" in
    *"Set/Update"*) set_key ;;
    *"Show"*)       show_key ;;
    *"Delete"*)     delete_key ;;
    *)              echo -e "${C_CYAN}Annulé.${C_RESET}" ;;
esac
