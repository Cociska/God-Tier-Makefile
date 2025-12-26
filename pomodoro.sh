#!/bin/bash

# --- CONFIGURATION ---
STREAM_URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"
STATS_FILE="$HOME/.pomodoro_stats"
FOCUS_TIME=1500
BREAK_TIME=300
SOCKET="/tmp/mpv_socket"
LOG_FILE="/tmp/mpv_log.txt"

# --- FIX PATH ---
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# --- TERMINAL SIZE CONSTRAINTS ---
MIN_COLS=50
MIN_LINES=30

# --- COULEURS ---
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
PURPLE='\033[35m'
CYAN='\033[36m'
WHITE='\033[97m'
YELLOW='\033[33m'
GREY='\033[90m'
RESET='\033[0m'

# --- FONCTIONS UTILITAIRES ---
draw_bar() {
    local perc=$1
    local len=20
    local filled=$(( (perc * len) / 100 ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar="${bar}█"; done
    for ((i=filled; i<len; i++)); do bar="${bar}░"; done
    echo "$bar"
}

mpv_cmd() { echo "$1" | socat - "$SOCKET" 2>/dev/null; }

get_title() {
    # Extraction robuste
    echo '{ "command": ["get_property", "media-title"] }' | socat - "$SOCKET" 2>/dev/null \
    | grep "data" \
    | head -n 1 \
    | cut -d '"' -f 4
}

cleanup() { mpv_cmd 'quit'; clear; exit 0; }
trap cleanup SIGINT SIGTERM

# --- SEQUENCE DEMARRAGE ---
SCRIPT_DIR=$(dirname "$0")
SIGNATURE_SCRIPT="$SCRIPT_DIR/signature.sh"
if [ -f "$SIGNATURE_SCRIPT" ]; then
    chmod +x "$SIGNATURE_SCRIPT" 2>/dev/null
    "$SIGNATURE_SCRIPT"
else
    echo "Loading..."
fi
sleep 1
clear

# --- INITIALISATION ---
[ ! -f "$STATS_FILE" ] && echo 0 > "$STATS_FILE"
SESSIONS_TODAY=0
SESSIONS_TOTAL=$(cat "$STATS_FILE")

# --- MPV ---
if ! pgrep -f "input-ipc-server=$SOCKET" >/dev/null; then
    rm -f "$SOCKET"
    mpv --no-video --idle=yes --input-ipc-server="$SOCKET" \
        --ytdl-format="bestaudio[ext=m4a]/bestaudio/best" \
        "$STREAM_URL" > "$LOG_FILE" 2>&1 &
fi

# --- BOUCLE PRINCIPALE ---
STATUS="FOCUS"
TIMER=$FOCUS_TIME
WAS_TOO_SMALL=0

while true; do
    # 1. CHECK TAILLE
    TERM_COLS=$(tput cols)
    TERM_LINES=$(tput lines)

    if [ "$TERM_COLS" -lt "$MIN_COLS" ] || [ "$TERM_LINES" -lt "$MIN_LINES" ]; then
        clear
        echo -e "${RED}"
        echo -e "┌──────────────────────────────┐"
        echo -e "│    TERMINAL TROP PETIT 🛑    │"
        echo -e "└──────────────────────────────┘"
        echo -e "${RESET}"
        echo -e "Requis  : ${GREEN}${MIN_COLS}x${MIN_LINES}${RESET}"
        echo -e "Actuel  : ${RED}${TERM_COLS}x${TERM_LINES}${RESET}"
        echo ""
        echo -e "${GREY}Agrandissez la fenêtre...${RESET}"
        
        WAS_TOO_SMALL=1
        sleep 0.5
        continue
    fi

    # 2. GESTION DE L'AFFICHAGE (Transition)
    if [ "$WAS_TOO_SMALL" -eq 1 ]; then
        clear # Force le nettoyage complet si on vient de l'erreur
        WAS_TOO_SMALL=0
    else
        printf "\033[H" # Sinon on écrase juste (anti-clignotement)
    fi

    # 3. DONNÉES MUSIQUE
    RAW_TITLE=$(get_title)
    CLEAN_NAME=$(echo "$RAW_TITLE" | tr -cd '[:print:]' | cut -c 1-50)

    if [ -z "$CLEAN_NAME" ]; then
        if ! pgrep -f "input-ipc-server=$SOCKET" >/dev/null; then
            CLEAN_NAME="${RED}MPV Error (Check logs)${RESET}"
        else
            CLEAN_NAME="Buffering..."
        fi
    fi

    # 4. LOGIQUE TIMER
    TOTAL_TIME=$([ "$STATUS" = "FOCUS" ] && echo "$FOCUS_TIME" || echo "$BREAK_TIME")
    ELAPSED=$((TOTAL_TIME - TIMER))
    PERC_POMO=$(( (ELAPSED * 100) / TOTAL_TIME ))
    BAR_POMO=$(draw_bar "$PERC_POMO")
    TIMER_STR=$(printf "%02d:%02d" $((TIMER/60)) $((TIMER%60)))

    # 5. BATTERIE
    BAT_PATH=$(find /sys/class/power_supply/BAT* -maxdepth 0 2>/dev/null | head -n 1)
    if [ -n "$BAT_PATH" ]; then
        BAT_CAP=$(cat "$BAT_PATH/capacity")
        BAT_ICON=$([ "$(cat "$BAT_PATH/status")" = "Charging" ] && echo "⚡")
        BAT_INFO="$BAT_ICON $BAT_CAP%"
    else
        BAT_INFO="🔌 AC"
    fi

    # 6. DESSIN INTERFACE
    echo -e "${PURPLE}$(date '+%A %d %B %Y — %H:%M:%S')${RESET}\n"
    printf "${CYAN}USER  : %s\nOWNER : %s\nPWD   : %s\nBAT   : %s${RESET}\n\n" \
        "$USER" "$(whoami)" "$(pwd)" "$BAT_INFO"

    echo -e "${PURPLE}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣿⠛⣿⠀⠀⠀⠀⣤⣿⢻⡇⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣿⡛⠀⣤⣿⣿⣤⣤⣿⣿⣤⢸⡇⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡗⠀"
    echo -e "⢠⣼⣿⣿⣿⣿⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷"
    echo -e "⢸⣿⣿⡟⠛⠛⢿⣿⣿⣿⣿⣿⣿⣤⣤⣤⣿⣿⣿⣿⣤⣤⣼⣿⣿"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠋⠀${RESET}"

    printf "\n${YELLOW}Sessions : Today %d | Total %d${RESET}\n" "$SESSIONS_TODAY" "$SESSIONS_TOTAL"

    COLOR=$([ "$STATUS" = "FOCUS" ] && echo "$GREEN" || echo "$YELLOW")
    printf "\n${COLOR}Pomodoro — %s${RESET}\n" "$STATUS"
    printf "${COLOR}[%s] %s${RESET}\n" "$BAR_POMO" "$TIMER_STR"

    printf "\n${BLUE}♪ Now Playing (Lofi Girl):${RESET}\n"
    printf "${BLUE}%s${RESET}\n" "$CLEAN_NAME"

    printf "\n${GREY}────────────────────────────────────────${RESET}\n"
    printf "${WHITE}[SPC]${GREY} Pause  ${WHITE}[s]${GREY} Skip Timer  ${WHITE}[q]${GREY} Quit${RESET}\n"

    # NETTOYAGE BAS DE PAGE (CRUCIAL)
    tput ed

    # 7. INPUT
    IFS= read -rs -t 1 -n 1 key
    case "$key" in
        " ") mpv_cmd 'cycle pause' ;;
        "s") TIMER=1 ;;
        "q") cleanup ;;
    esac

    TIMER=$((TIMER - 1))

    # 8. FIN TIMER
    if [ "$TIMER" -le 0 ]; then
        printf "\a"
        if [ "$STATUS" = "FOCUS" ]; then
            STATUS="BREAK"
            TIMER=$BREAK_TIME
            SESSIONS_TODAY=$((SESSIONS_TODAY + 1))
            SESSIONS_TOTAL=$((SESSIONS_TOTAL + 1))
            echo "$SESSIONS_TOTAL" > "$STATS_FILE"
            mpv_cmd 'set pause yes'
        else
            STATUS="FOCUS"
            TIMER=$FOCUS_TIME
            mpv_cmd 'set pause no'
        fi
        clear
    fi
done
