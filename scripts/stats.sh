#!/bin/bash

# --- Configuration ---
# Dossiers à ignorer
EXCLUDE_DIRS="(\.git/|node_modules/|obj/|bin/|__pycache__/|\.mypy_cache/)"

# --- Couleurs ---
C_RESET='\033[0m'
C_CYAN='\033[1;36m'     # Info / C
C_GREEN='\033[1;32m'    # C Source
C_YELLOW='\033[1;33m'   # Headers
C_RED='\033[1;31m'      # Shell
C_BLUE='\033[1;34m'     # Python
C_PURPLE='\033[1;35m'   # Makefile
C_WHITE='\033[1;37m'    # Readme
C_GREY='\033[0;90m'     # Others
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

# 1. Fichiers & Lignes par type

# C / Headers
N_C=$(get_file_count "*.c"); L_C=$(get_line_count "*.c")
N_H=$(get_file_count "*.h"); L_H=$(get_line_count "*.h")

# Shell
N_SH=$(get_file_count "*.sh"); L_SH=$(get_line_count "*.sh")

# Python
N_PY=$(get_file_count "*.py"); L_PY=$(get_line_count "*.py")

# Makefiles (Nom exact ou extension .mk)
N_MK=$(find . -type f \( -name "Makefile" -o -name "*.mk" \) | grep -vE "$EXCLUDE_DIRS" | wc -l)
L_MK=$(find . -type f \( -name "Makefile" -o -name "*.mk" \) | grep -vE "$EXCLUDE_DIRS" | xargs wc -l 2>/dev/null | tail -n 1 | awk '{print $1}' || echo "0")

# Readme / Markdown
N_MD=$(get_file_count "*.md"); L_MD=$(get_line_count "*.md")

# Others (Tout ce qui n'est pas matché ci-dessus)
# On cherche tous les fichiers, et on exclut ceux qu'on connait déjà
N_OTH=$(find . -type f \
    -not -name "*.c" -not -name "*.h" \
    -not -name "*.sh" -not -name "*.py" \
    -not -name "Makefile" -not -name "*.mk" \
    -not -name "*.md" \
    | grep -vE "$EXCLUDE_DIRS" | wc -l)

L_OTH=$(find . -type f \
    -not -name "*.c" -not -name "*.h" \
    -not -name "*.sh" -not -name "*.py" \
    -not -name "Makefile" -not -name "*.mk" \
    -not -name "*.md" \
    | grep -vE "$EXCLUDE_DIRS" | xargs wc -l 2>/dev/null | tail -n 1 | awk '{print $1}' || echo "0")

# Totaux
TOTAL_FILES=$((N_C + N_H + N_SH + N_PY + N_MK + N_MD + N_OTH))
TOTAL_LINES=$((L_C + L_H + L_SH + L_PY + L_MK + L_MD + L_OTH))

# 3. Code Réel vs Vide (Estimation sur les langages de code uniquement)
# On compte les lignes vides dans les fichiers .c, .h, .py, .sh
EMPTY_LINES=$(find . -type f \( -name "*.[ch]" -o -name "*.py" -o -name "*.sh" \) | grep -vE "$EXCLUDE_DIRS" | xargs grep -c "^$" | awk -F: '{s+=$2} END {print s}')
if [ -z "$EMPTY_LINES" ]; then EMPTY_LINES=0; fi

REAL_CODE=$((TOTAL_LINES - EMPTY_LINES))
if [ $TOTAL_LINES -gt 0 ]; then
    DENSITY=$(( (REAL_CODE * 100) / TOTAL_LINES ))
else
    DENSITY=0
fi

# 4. Le plus gros fichier (scan global)
BIGGEST_FILE=$(find . -type f | grep -vE "$EXCLUDE_DIRS" | xargs wc -l 2>/dev/null | sort -rn | head -n 2 | tail -n 1 | awk '{print $2 " (" $1 " lines)"}')

# --- Affichage ---
clear
echo -e "${C_CYAN}"
echo "   📊  PROJECT STATISTICS  📊"
echo "════════════════════════════════"
echo -e "${C_RESET}"

# === Section Fichiers (Affichage conditionnel) ===
echo -e "${C_BOLD}📂  FILES INVENTORY ($TOTAL_FILES total)${C_RESET}"

# Fonction d'affichage ligne fichier
print_file_stat() {
    local count=$1
    local color=$2
    local label=$3
    if [ "$count" -gt 0 ]; then
        echo -e "    ${color}${label}:${C_RESET}   $count"
    fi
}

# L'alignement est géré par des espaces manuels ou printf si besoin, ici simple
if [ "$N_C" -gt 0 ];   then printf "    ${C_GREEN}%-12s${C_RESET} %d\n" ".c Files" "$N_C"; fi
if [ "$N_H" -gt 0 ];   then printf "    ${C_YELLOW}%-12s${C_RESET} %d\n" ".h Files" "$N_H"; fi
if [ "$N_PY" -gt 0 ];  then printf "    ${C_BLUE}%-12s${C_RESET} %d\n" "Python" "$N_PY"; fi
if [ "$N_MK" -gt 0 ];  then printf "    ${C_PURPLE}%-12s${C_RESET} %d\n" "Makefiles" "$N_MK"; fi
if [ "$N_SH" -gt 0 ];  then printf "    ${C_RED}%-12s${C_RESET} %d\n" "Scripts" "$N_SH"; fi
if [ "$N_MD" -gt 0 ];  then printf "    ${C_WHITE}%-12s${C_RESET} %d\n" "Docs/MD" "$N_MD"; fi
if [ "$N_OTH" -gt 0 ]; then printf "    ${C_GREY}%-12s${C_RESET} %d\n" "Others" "$N_OTH"; fi
echo ""

# === Section Lignes (avec barre graphique) ===
echo -e "${C_BOLD}📝  CODE VOLUME${C_RESET}"
printf "    %-12s %5s  %s\n" "Type" "Lines" "Ratio"
echo -e "    ${C_DIM}------------ -----  --------------------${C_RESET}"

# Fonction d'affichage ligne stats
print_line_stat() {
    local count=$1
    local color=$2
    local label=$3
    
    if [ "$count" -gt 0 ]; then
        local ratio=$(( (count * 100) / TOTAL_LINES ))
        printf "    ${color}%-12s${C_RESET} %5s  " "$label" "$count"
        print_bar $ratio
        echo " $ratio%"
    fi
}

print_line_stat "$L_C"   "$C_GREEN"  "C Source"
print_line_stat "$L_H"   "$C_YELLOW" "Headers"
print_line_stat "$L_PY"  "$C_BLUE"   "Python"
print_line_stat "$L_MK"  "$C_PURPLE" "Makefiles"
print_line_stat "$L_SH"  "$C_RED"    "Shell"
print_line_stat "$L_MD"  "$C_WHITE"  "Docs"
print_line_stat "$L_OTH" "$C_GREY"   "Others"

echo ""
echo -e "    ${C_BOLD}TOTAL:${C_RESET}      $TOTAL_LINES lines"
echo -e "    ${C_BOLD}DENSITY:${C_RESET}    $DENSITY% code density (approx)" 
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
