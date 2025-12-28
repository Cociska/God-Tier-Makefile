#!/bin/bash

# --- CONFIG ---
CONFIG_DIR="$HOME/.config/god-tier-makefile"
DB_FILE="$CONFIG_DIR/projects.db"
SESSION_FILE="$CONFIG_DIR/current_session"

# --- COLORS ---
C_RESET='\033[0m'
C_CYAN='\033[1;36m'
C_YELLOW='\033[1;33m'
C_RED='\033[1;31m'
C_BOLD='\033[1m'

# --- HELPERS ---
format_time() {
    local T=$1
    local H=$((T/3600))
    local M=$(( (T%3600) / 60 ))
    local S=$((T%60))
    printf "%02dh %02dm %02ds" $H $M $S
}

# --- LOGIC ---
echo -e "${C_CYAN}📊  PROJECT TIME TRACKING${C_RESET}"

if [ ! -s "$DB_FILE" ]; then
    echo -e "${C_YELLOW}No projects tracked yet.${C_RESET}"
    echo -e "Run 'make project_start' to begin."
    exit 0
fi

# Prepare list for FZF
# We format it nicely: "Project Name      | HHh MMm SSs"
LIST=""
while IFS='|' read -r name seconds; do
    human_time=$(format_time "$seconds")
    # Pad the name for alignment (max 30 chars)
    padded_name=$(printf "%-30s" "$name")
    LIST+="${padded_name}   ${human_time}\n"
done < "$DB_FILE"

# Check for active session to show status
STATUS_MSG="[No active timer]"
if [ -f "$SESSION_FILE" ]; then
    CURR=$(cut -d'|' -f1 "$SESSION_FILE")
    STATUS_MSG="🔴 REC: ${CURR}"
fi

# Display via FZF (View only)
echo -e "$LIST" | fzf \
    --height=40% --layout=reverse --border \
    --prompt="Projects > " \
    --header="$STATUS_MSG" \
    --color="header:bold:red"
