#!/bin/bash

# --- CONFIGURATION ---
# Flux Lofi Girl (plus stable qu'une playlist)
STREAM_URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"
STATS_FILE="$HOME/.pomodoro_stats"
FOCUS_TIME=1500
BREAK_TIME=300
SOCKET="/tmp/mpv_socket"
LOG_FILE="/tmp/mpv_log.txt"

# --- FIX PATH ---
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

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
    # Extraction propre du titre JSON
    echo '{ "command": ["get_property", "media-title"] }' | socat - "$SOCKET" 2>/dev/null \
    | grep -o '"data":".*"' \
    | sed 's/"data":"//;s/"$//;s/","error".*//'
}

cleanup() { mpv_cmd 'quit'; clear; exit 0; }
trap cleanup SIGINT SIGTERM

# --- SEQUENCE DEMARRAGE ---
SCRIPT_DIR=$(dirname "$0")
SIGNATURE_SCRIPT="$SCRIPT_DIR/signature.sh"
if [ -f "$SIGNATURE_SCRIPT" ]; then chmod +x "$SIGNATURE_SCRIPT" 2>/dev/null; "$SIGNATURE_SCRIPT"; else echo "Loading..."; fi
sleep 1
clear

# --- INITIALISATION ---
if [ ! -f "$STATS_FILE" ]; then echo 0 > "$STATS_FILE"; fi
SESSIONS_TODAY=0
SESSIONS_TOTAL=$(cat "$STATS_FILE")

# Lancement MPV
if ! pgrep -f "input-ipc-server=$SOCKET" >/dev/null; then
    rm -f "$SOCKET"
    mpv --no-video --idle=yes --input-ipc-server="$SOCKET" \
        --ytdl-format="bestaudio[ext=m4a]/bestaudio/best" \
        "$STREAM_URL" > "$LOG_FILE" 2>&1 &
fi

# --- BOUCLE PRINCIPALE ---
STATUS="FOCUS"
TIMER=$FOCUS_TIME

while true; do
    # 1. INFO MUSIQUE
    RAW_TITLE=$(get_title)
    
    if [ -z "$RAW_TITLE" ]; then
        if ! pgrep -f "input-ipc-server=$SOCKET" >/dev/null; then
             CLEAN_NAME="${RED}MPV Error (Check logs)${RESET}"
        else
             CLEAN_NAME="Buffering..."
        fi
    elif [[ "$RAW_TITLE" == *"http"* ]]; then
        CLEAN_NAME="Loading Metadata..."
    else
        CLEAN_NAME=${RAW_TITLE:0:50}
    fi

    # 2. CALCULS POMODORO
    if [ "$STATUS" = "FOCUS" ]; then TOTAL_TIME=$FOCUS_TIME; else TOTAL_TIME=$BREAK_TIME; fi
    ELAPSED=$((TOTAL_TIME - TIMER))
    PERC_POMO=$(( (ELAPSED * 100) / TOTAL_TIME ))
    BAR_POMO=$(draw_bar $PERC_POMO)
    TIMER_STR=$(printf "%02d:%02d" $((TIMER/60)) $((TIMER%60)))

    # 3. BATTERIE
    BAT_PATH=$(find /sys/class/power_supply/BAT* -maxdepth 0 2>/dev/null | head -n 1)
    if [ -n "$BAT_PATH" ]; then
        BAT_CAP=$(cat "$BAT_PATH/capacity")
        if [ "$(cat "$BAT_PATH/status")" = "Charging" ]; then BAT_ICON="⚡"; else BAT_ICON=""; fi
        BAT_INFO="$BAT_ICON $BAT_CAP%"
    else
        BAT_INFO="🔌 AC"
    fi

    # --- 4. AFFICHAGE (STYLE CLASSIQUE RESTAURÉ) ---
    printf "\033[H"
    
    # Date
    echo -e "${PURPLE}$(date '+%A %d %B %Y — %H:%M:%S')${RESET}\n"
    
    # User Block complet
    printf "${CYAN}USER  : %s\nOWNER : %s\nPWD   : %s\nBAT   : %s${RESET}\n\n" "$USER" "$(whoami)" "$(pwd)" "$BAT_INFO"

    # ASCII Art complet (Violet)
    echo -e "${PURPLE}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣿⠛⣿⠀⠀⠀⠀⣤⣿⢻⡇⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣿⡛⠀⣤⣿⣿⣤⣤⣿⣿⣤⢸⡇⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡗⠀"
    echo -e "⢠⣼⣿⣿⣿⣿⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷"
    echo -e "⢸⣿⣿⡟⠛⠛⢿⣿⣿⣿⣿⣿⣿⣤⣤⣤⣿⣿⣿⣿⣤⣤⣼⣿⣿"
    echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠋⠀${RESET}"

    # Stats
    printf "\n${YELLOW}Sessions : Today %d | Total %d${RESET}\n" "$SESSIONS_TODAY" "$SESSIONS_TOTAL"

    # Pomodoro
    if [ "$STATUS" = "FOCUS" ]; then COLOR=$GREEN; else COLOR=$YELLOW; fi
    printf "\n${COLOR}Pomodoro — %s${RESET}\n" "$STATUS"
    printf "${COLOR}[%s] %s${RESET}\n" "$BAR_POMO" "$TIMER_STR"

    # Musique
    printf "\n${BLUE}♪ Now Playing (Lofi Girl):${RESET}\n"
    printf "${BLUE}%s${RESET}\n" "$CLEAN_NAME"

    # Commandes
    printf "\n${GREY}────────────────────────────────────────${RESET}\n"
    printf "${WHITE}[SPC]${GREY} Pause  ${WHITE}[s]${GREY} Skip Timer  ${WHITE}[q]${GREY} Quit${RESET}\n"

    # 5. INPUT
    IFS= read -rs -t 1 -n 1 key
    if [ $? -eq 0 ]; then
        case "$key" in
            " ") mpv_cmd 'cycle pause' ;;
            "s") TIMER=1 ;;
            "q") cleanup ;;
        esac
    fi

    TIMER=$((TIMER - 1))

    # 6. LOGIQUE TIMER
    if [ $TIMER -le 0 ]; then
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
