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

# Ensure config dir exists
mkdir -p "$CONFIG_DIR"
touch "$DB_FILE"

# 1. Check if session already running
if [ -f "$SESSION_FILE" ]; then
    CURRENT_PROJ=$(cut -d'|' -f1 "$SESSION_FILE")
    echo -e "${C_RED}⚠️  A timer is already running for '${CURRENT_PROJ}'.${C_RESET}"
    echo -e "Please run ${C_YELLOW}make project_stop${C_RESET} first."
    exit 1
fi

# 2. Get list of existing projects
# We use awk to extract just the project names for the list
EXISTING=$(awk -F'|' '{print $1}' "$DB_FILE")

# 3. FZF Selection (Select existing OR type new)
SELECTION=$(echo "$EXISTING" | fzf --print-query \
    --height=30% --layout=reverse --border \
    --prompt="⏱️  START TIMER > " \
    --header="Select existing project OR type a new name" \
    --info=inline)

# Handle Cancel (Empty output)
if [ -z "$SELECTION" ]; then
    echo -e "${C_RED}Cancelled.${C_RESET}"
    exit 0
fi

# Parse FZF output:
# Line 1: Query (what was typed)
# Line 2: Selection (what was selected from list)
QUERY=$(echo "$SELECTION" | head -n1)
HIT=$(echo "$SELECTION" | tail -n1)
PROJECT=""

# If the user selected an existing entry
if [ -n "$HIT" ] && echo "$EXISTING" | grep -q "^$HIT$"; then
    PROJECT="$HIT"
else
    # New project
    PROJECT="$QUERY"
fi

if [ -z "$PROJECT" ]; then
    echo -e "${C_RED}Invalid project name.${C_RESET}"
    exit 1
fi

# 4. Start Session
START_TIME=$(date +%s)
echo "${PROJECT}|${START_TIME}" > "$SESSION_FILE"

echo -e "${C_GREEN}✅ Timer started for project: ${C_BOLD}${PROJECT}${C_RESET}"
echo -e "${C_CYAN}Run 'make project_stop' to save time.${C_RESET}"
