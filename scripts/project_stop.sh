#!/bin/bash

# --- CONFIG ---
CONFIG_DIR="$HOME/.config/god-tier-makefile"
DB_FILE="$CONFIG_DIR/projects.db"
SESSION_FILE="$CONFIG_DIR/current_session"

# --- COLORS ---
C_RESET='\033[0m'
C_CYAN='\033[1;36m'
C_GREEN='\033[1;32m'
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
if [ ! -f "$SESSION_FILE" ]; then
    echo -e "${C_RED}⚠️  No active timer found.${C_RESET}"
    exit 1
fi

# 1. Read session info
SESSION_DATA=$(cat "$SESSION_FILE")
PROJECT=$(echo "$SESSION_DATA" | cut -d'|' -f1)
START_TIME=$(echo "$SESSION_DATA" | cut -d'|' -f2)
END_TIME=$(date +%s)

# 2. Calculate duration
DURATION=$((END_TIME - START_TIME))
FORMATTED=$(format_time $DURATION)

echo -e "${C_CYAN}>>> Stopping timer for ${C_BOLD}${PROJECT}${C_RESET}..."
echo -e "    Session duration: ${C_YELLOW}${FORMATTED}${C_RESET}"

# 3. Update Database
# We create a temporary file
TMP_DB="$DB_FILE.tmp"
FOUND=0

# Read DB line by line
while IFS= read -r line || [ -n "$line" ]; do
    P_NAME=$(echo "$line" | cut -d'|' -f1)
    P_TIME=$(echo "$line" | cut -d'|' -f2)

    if [ "$P_NAME" == "$PROJECT" ]; then
        # Add to existing
        NEW_TIME=$((P_TIME + DURATION))
        echo "${P_NAME}|${NEW_TIME}" >> "$TMP_DB"
        FOUND=1
    else
        # Keep other projects as is
        echo "$line" >> "$TMP_DB"
    fi
done < "$DB_FILE"

# If project was new (not found in loop), append it
if [ $FOUND -eq 0 ]; then
    echo "${PROJECT}|${DURATION}" >> "$TMP_DB"
fi

mv "$TMP_DB" "$DB_FILE"
rm "$SESSION_FILE"

echo -e "${C_GREEN}✅ Time saved successfully!${C_RESET}"
