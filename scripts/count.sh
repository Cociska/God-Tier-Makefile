#!/bin/bash
CYAN='\033[36m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}${CYAN}Lines of C code:${RESET}"
echo -e "${CYAN}------------------${RESET}"
# On compte les lignes des fichiers passés en argument (SRC)
echo -e "${BOLD}${CYAN}$(wc -l "$@" | tail -n 1)${RESET}"
echo -e "${CYAN}------------------${RESET}"
echo ""
