#!/bin/bash

# --- COULEURS ---
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
PURPLE='\033[35m'
CYAN='\033[36m'
WHITE='\033[97m'
YELLOW='\033[33m'
BROWN='\033[0;33m' # Simulé par du jaune foncé/orange selon terminal
GREY='\033[90m'
RESET='\033[0m'

# --- CONFIGURATION ---
START_TIME=$(date +%s)

# --- FONCTION NETTOYAGE ---
cleanup() {
    clear
    exit 0
}
trap cleanup SIGINT SIGTERM

# --- BOUCLE PRINCIPALE ---
FRAME=0

while true; do
    # 1. CALCULS TEMPS
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    TIMER_STR=$(printf "%02d:%02d" $((ELAPSED/60)) $((ELAPSED%60)))

    # 2. AFFICHAGE HEADER
    printf "\033[H" # Reset curseur sans clear (anti-clignotement)
    
    # Date & User
    echo -e "${PURPLE}$(date '+%A %d %B %Y — %H:%M:%S')${RESET}\n"
    printf "${CYAN}USER  : %s\nMODE  : ${YELLOW}COFFEE BREAK ☕${RESET}\n\n" "$USER"

    # 3. ASCII ART (Animation de la fumée)
    # On alterne entre 2 frames pour la fumée
    if [ $((FRAME % 2)) -eq 0 ]; then
        STEAM1="      (  )   (   )  "
        STEAM2="       ) (   )  (   "
        STEAM3="       ( )  (    )  "
    else
        STEAM1="      (   )  (  )   "
        STEAM2="       ) (    )  (  "
        STEAM3="       ( )   (   )  "
    fi

    # Dessin de la tasse
    echo -e "${WHITE}$STEAM1"
    echo -e "${WHITE}$STEAM2"
    echo -e "${WHITE}$STEAM3"
    echo -e "${BROWN}       _____________"
    echo -e "${BROWN}      <_____________> "
    echo -e "${BROWN}      |             | "
    echo -e "${BROWN}      |   ${WHITE}COFFEE${BROWN}    | "
    echo -e "${BROWN}      |    ${WHITE}BREAK${BROWN}    | "
    echo -e "${BROWN}      |_____________| "
    echo -e "${BROWN}       \___________/  ${RESET}"

    # 4. INFO TIMER
    echo -e "\n${GREY}Pause duration:${RESET}"
    echo -e "${GREEN}⏱  $TIMER_STR${RESET}"

    # 5. FOOTER
    echo -e "\n${GREY}──────────────────────────${RESET}"
    echo -e "${WHITE}[q]${GREY} to go back to work${RESET}"

    # 6. LOGIQUE INPUT
    # Attend 0.5s (animation fluide)
    read -t 0.5 -n 1 key
    if [[ $key == "q" ]]; then
        cleanup
    fi

    FRAME=$((FRAME + 1))
done
