#!/bin/bash

# --- Configuration ---
# Dossiers à ignorer
EXCLUDE_DIRS="(\.git/|node_modules/|obj/|bin/)"

# --- Couleurs ---
C_RESET='\033[0m'
C_CYAN='\033[1;36m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_RED='\033[1;31m'
C_BOLD='\033[1m'
C_DIM='\033[2m'

# --- Fonctions ---
print_bar() {
    local percent=$1
    local length=20
    local filled=$(( (percent * length) / 100 ))
    local empty=$(( length - filled ))
    
    printf "${C_DIM}["
    if [ $filled -gt 0 ]; then printf "${C_GREEN}%0.s▓" $(seq 1 $filled); fi
    if [ $empty -gt 0 ]; then printf "${C_DIM}%0.s░" $(seq 1 $empty); fi
    printf "${C_DIM}]${C_RESET}"
}

get_file_count() {
    find . -type f -name "$1" | grep -vE "$EXCLUDE_DIRS" | wc -l
}

get_line_count() {
    # Compte les lignes, gère le cas où aucun fichier n'existe
    find . -type f -name "$1" | grep -vE "$EXCLUDE_DIRS" | xargs wc -l 2>/dev/null | tail -n 1 | awk '{print $1}' || echo "0"
}

# --- Collecte des données ---
echo -e "${C_CYAN}>>> Scanning project...${C_RESET}"

# 1. Fichiers
N_C=$(get_file_count "*.c")
N_H=$(get_file_count "*.h")
N_MK=$(find . -name "Makefile" | wc -l)
N_SH=$(get_file_count "*.sh")

# 2. Lignes
L_C=$(get_line_count "*.c")
L_H=$(get_line_count "*.h")
L_SH=$(get_line_count "*.sh")
TOTAL_LINES=$((L_C + L_H + L_SH))

# 3. Code Réel vs Vide (Estimation)
# On compte les lignes vides dans les fichiers .c et .h
EMPTY_LINES=$(find . -type f -name "*.[ch]" | grep -vE "$EXCLUDE_DIRS" | xargs grep -c "^$" | awk -F: '{s+=$2} END {print s}')
if [ -z "$EMPTY_LINES" ]; then EMPTY_LINES=0; fi

REAL_CODE=$((TOTAL_LINES - EMPTY_LINES))
if [ $TOTAL_LINES -gt 0 ]; then
    DENSITY=$(( (REAL_CODE * 100) / TOTAL_LINES ))
else
    DENSITY=0
fi

# 4. Le plus gros fichier
BIGGEST_FILE=$(find . -type f -name "*.[ch]" | grep -vE "$EXCLUDE_DIRS" | xargs wc -l 2>/dev/null | sort -rn | head -n 2 | tail -n 1 | awk '{print $2 " (" $1 " lines)"}')

# --- Affichage ---
clear
echo -e "${C_CYAN}"
echo "   📊  PROJECT STATISTICS  📊"
echo "════════════════════════════════"
echo -e "${C_RESET}"

# Section Fichiers
echo -e "${C_BOLD}📂  FILES INVENTORY${C_RESET}"
echo -e "    ${C_CYAN}.c Files:${C_RESET}   $N_C"
echo -e "    ${C_CYAN}.h Files:${C_RESET}   $N_H"
echo -e "    ${C_CYAN}Scripts:${C_RESET}    $N_SH"
echo -e "    ${C_CYAN}Makefiles:${C_RESET}  $N_MK"
echo ""

# Section Lignes (avec barre graphique)
echo -e "${C_BOLD}📝  CODE VOLUME${C_RESET}"
printf "    %-10s %5s  %s\n" "Language" "Lines" "Ratio"
echo -e "    ${C_DIM}---------- -----  --------------------${C_RESET}"

if [ $TOTAL_LINES -gt 0 ]; then
    P_C=$(( (L_C * 100) / TOTAL_LINES ))
    P_H=$(( (L_H * 100) / TOTAL_LINES ))
    P_SH=$(( (L_SH * 100) / TOTAL_LINES ))
else
    P_C=0; P_H=0; P_SH=0
fi

printf "    ${C_GREEN}%-10s${C_RESET} %5s  " "C Source" "$L_C"
print_bar $P_C
echo " $P_C%"

printf "    ${C_YELLOW}%-10s${C_RESET} %5s  " "Headers" "$L_H"
print_bar $P_H
echo " $P_H%"

printf "    ${C_RED}%-10s${C_RESET} %5s  " "Shell" "$L_SH"
print_bar $P_SH
echo " $P_SH%"

echo ""
echo -e "    ${C_BOLD}TOTAL:${C_RESET}      $TOTAL_LINES lines"
echo -e "    ${C_BOLD}DENSITY:${C_RESET}    $DENSITY% useful code (approx)" 
echo -e "    ${C_DIM}(Excluding empty lines)${C_RESET}"
echo ""

# Section Git (si présent)
if [ -d .git ]; then
    echo -e "${C_BOLD}🐙  GIT ACTIVITY${C_RESET}"
    COMMITS=$(git rev-list --count HEAD 2>/dev/null)
    CONTRIBS=$(git log --format='%aN' 2>/dev/null | sort -u | wc -l)
    LAST_DATE=$(git log -1 --format=%cd --date=relative 2>/dev/null)
    
    echo -e "    ${C_CYAN}Commits:${C_RESET}      $COMMITS"
    echo -e "    ${C_CYAN}Contributors:${C_RESET} $CONTRIBS"
    echo -e "    ${C_CYAN}Last update:${C_RESET}  $LAST_DATE"
else
    echo -e "${C_DIM}Git repository not detected.${C_RESET}"
fi

echo ""
# Section Fun Fact
echo -e "${C_BOLD}🏆  HEAVYWEIGHT CHAMPION${C_RESET}"
if [ -n "$BIGGEST_FILE" ]; then
    echo -e "    $BIGGEST_FILE"
else
    echo -e "    N/A"
fi
echo ""
echo "════════════════════════════════"
