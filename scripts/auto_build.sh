#!/bin/bash

# =================CONFIGURATION=================
# Nom de l'exécutable à exclure (IMPORTANT)
BIN_NAME="minishell"
# Commande de build
BUILD_CMD="make --no-print-directory"
# Dossier à surveiller
WATCH_DIR="."
# ===============================================

# --- Palette de Couleurs ---
C_RESET='\033[0m'
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_CYAN='\033[1;36m'
C_WHITE='\033[1;37m'
C_GREY='\033[0;90m'
BG_RED='\033[41m\033[37m'
BG_GREEN='\033[42m\033[30m'

# --- Vérification inotify ---
if ! command -v inotifywait &> /dev/null; then
    echo -e "${C_RED}Erreur: 'inotify-tools' requis.${C_RESET}"
    echo "Install: sudo apt install inotify-tools"
    exit 1
fi

# --- Fonctions Graphiques ---
draw_line() {
    printf "${C_GREY}%*s${C_RESET}\n" "$(tput cols)" '' | tr ' ' '─'
}

center_text() {
    local text="$1"
    local width=$(tput cols)
    local len=${#text}
    local padding=$(( (width - len) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

print_header() {
    clear
    echo -e "${C_CYAN}"
    center_text "╔════════════════════════════════════════╗"
    center_text "║      AUTO-BUILD SYSTEM MONITOR         ║"
    center_text "╚════════════════════════════════════════╝"
    echo -e "${C_RESET}"
    echo -e " ${C_BLUE}ℹ  Mode:${C_RESET} Watch  ${C_BLUE}ℹ  Target:${C_RESET} $BIN_NAME  ${C_BLUE}ℹ  Path:${C_RESET} $WATCH_DIR"
    draw_line
}

# --- Boucle Principale ---
print_header
echo -e "${C_YELLOW}>>> En attente de modifications de fichiers...${C_RESET}"

while true; do
    # 1. Attente de modification
    # On exclut .git, les objets .o, et le binaire final pour éviter les boucles
    inotifywait -q -r -e close_write \
        --exclude "(\.git/|\.o$|${BIN_NAME}$)" "$WATCH_DIR" >/dev/null

    # 2. Début du Build
    start_time=$(date +%s%N)
    print_header
    echo -e "${C_YELLOW}⚡ Changement détecté. Compilation en cours...${C_RESET}\n"

    # 3. Exécution de la commande
    # On capture la sortie mais on l'affiche quand même
    $BUILD_CMD
    build_status=$?

    # 4. Calcul du temps
    end_time=$(date +%s%N)
    elapsed=$(( (end_time - start_time) / 1000000 )) # en millisecondes
    seconds=$(( elapsed / 1000 ))
    millis=$(( elapsed % 1000 ))

    echo ""
    draw_line

    # 5. Affichage du Résultat
    if [ $build_status -eq 0 ]; then
        # SUCCÈS
        echo -e " ${BG_GREEN}  BUILD SUCCESS  ${C_RESET}  ${C_GREEN}Temps: ${seconds}.${millis}s${C_RESET}"
        
        # Petit check visuel de l'exécutable
        if [ -f "./$BIN_NAME" ]; then
             size=$(ls -lh "$BIN_NAME" | awk '{print $5}')
             echo -e " ${C_GREY}Binary size: $size${C_RESET}"
        fi
        
        # Notification système (si disponible sous Linux)
        command -v notify-send >/dev/null && notify-send -i terminal "Build Success" "Compilation terminée en ${seconds}s"
    else
        # ÉCHEC
        echo -e " ${BG_RED}  BUILD FAILED  ${C_RESET}   ${C_RED}Code erreur: $build_status${C_RESET}"
        
        # Son système (Beep) pour attirer l'attention
        echo -e "\a"
        command -v notify-send >/dev/null && notify-send -u critical "Build Failed" "Erreur de compilation !"
    fi

    draw_line
    echo -e "${C_CYAN}>>> Waiting for next change...${C_RESET}"
done
