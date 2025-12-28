#!/bin/bash

# --- COULEURS ---
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
PURPLE='\033[35m'
CYAN='\033[36m'
WHITE='\033[97m'
YELLOW='\033[33m'
BROWN='\033[0;33m'
GREY='\033[90m'
RESET='\033[0m'

# --- CONFIGURATION ---
START_TIME=$(date +%s)
# Taille minimale requise (L'ASCII art du café est plus compact)
MIN_COLS=40
MIN_LINES=25

# --- FONCTION NETTOYAGE ---
cleanup() {
    clear
    exit 0
}
trap cleanup SIGINT SIGTERM

# --- BOUCLE PRINCIPALE ---
FRAME=0
WAS_TOO_SMALL=0

while true; do
    # 1. CHECK TAILLE
    TERM_COLS=$(tput cols)
    TERM_LINES=$(tput lines)

    if [ "$TERM_COLS" -lt "$MIN_COLS" ] || [ "$TERM_LINES" -lt "$MIN_LINES" ]; then
        clear
        echo -e "${RED}"
        echo -e "┌──────────────────────────┐"
        echo -e "│   TERMINAL TROP PETIT    │"
        echo -e "└──────────────────────────┘"
        echo -e "${RESET}"
        echo -e "Requis : ${GREEN}${MIN_COLS}x${MIN_LINES}${RESET}"
        echo -e "Actuel : ${RED}${TERM_COLS}x${TERM_LINES}${RESET}"
        
        WAS_TOO_SMALL=1
        sleep 0.5
        continue
    fi

    # 2. GESTION AFFICHAGE (Transition)
    if [ "$WAS_TOO_SMALL" -eq 1 ]; then
        clear
        WAS_TOO_SMALL=0
    else
        printf "\033[H"
    fi

    # 3. CALCULS TEMPS
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    TIMER_STR=$(printf "%02d:%02d" $((ELAPSED/60)) $((ELAPSED%60)))

    # 4. AFFICHAGE HEADER
    # Date & User
    echo -e "${PURPLE}$(date '+%A %d %B %Y — %H:%M:%S')${RESET}\n"
    printf "${CYAN}USER  : %s\nMODE  : ${YELLOW}COFFEE BREAK ☕${RESET}\n\n" "$USER"

    # 5. ASCII ART (Animation)
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

    # 6. INFO TIMER
    echo -e "\n${GREY}Pause duration:${RESET}"
    echo -e "${GREEN}⏱  $TIMER_STR${RESET}"

    # 7. FOOTER
    echo -e "\n${GREY}──────────────────────────${RESET}"
    echo -e "${WHITE}[q]${GREY} to go back to work${RESET}"

    # 8. NETTOYAGE BAS DE PAGE
    tput ed

    # 9. LOGIQUE INPUT
    read -t 0.5 -n 1 key
    if [[ $key == "q" ]]; then
        cleanup
    fi

    FRAME=$((FRAME + 1))
done
