#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
RESET='\033[0m'

TARGET_DIR="$HOME/Makefile/scripts"

echo -e "${BLUE}🚀 Initializing God Tier Environment Setup...${RESET}"

# --- 1. DETECT PACKAGE MANAGER & INSTALL SYSTEM DEPS ---
echo -e "${BLUE}>>> Checking System Dependencies...${RESET}"

if command -v apt &> /dev/null; then
    # Debian / Ubuntu / Kali
    PKG_MANAGER="sudo apt install -y"
    PACKAGES="make gcc git fzf curl mpv socat inotify-tools valgrind python3-pip"
elif command -v dnf &> /dev/null; then
    # Fedora / RedHat
    PKG_MANAGER="sudo dnf install -y"
    PACKAGES="make gcc git fzf curl mpv socat inotify-tools valgrind python3-pip"
elif command -v pacman &> /dev/null; then
    # Arch Linux
    PKG_MANAGER="sudo pacman -S --noconfirm"
    PACKAGES="make gcc git fzf curl mpv socat inotify-tools valgrind python-pip"
elif command -v apk &> /dev/null; then
    # Alpine Linux / iSH (iOS)
    PKG_MANAGER="apk add"
    # Note : 'py3-pip' est le nom du paquet pip sur Alpine
    PACKAGES="make gcc git fzf curl mpv socat inotify-tools valgrind py3-pip"
    
    # --- ASTUCE MAGIC ---
    # On définit une fonction 'sudo' qui ne fait rien d'autre qu'exécuter la commande directe.
    # Cela permet de "tromper" le reste du script qui contient des 'sudo' en dur.
    sudo() { "$@"; }
else
    echo -e "${RED}Error: Unsupported Package Manager.${RESET}"
    exit 1
fi

echo -e "${BLUE}>>> Installing system packages using $PKG_MANAGER...${RESET}"
$PKG_MANAGER $PACKAGES

# --- 2. INSTALL PYTHON DEPS ---
echo -e "${BLUE}>>> Installing Python dependencies (from requirements.txt)...${RESET}"
if [ -f "requirements.txt" ]; then
    sudo pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
else
    echo -e "${RED}Warning: requirements.txt not found. Skipping Python deps.${RESET}"
fi

# --- 3. SETUP FZF (If not already configured) ---
echo -e "${BLUE}>>> Configuring FZF keybindings...${RESET}"
# Try to source standard locations to see if it works
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    echo "source /usr/share/doc/fzf/examples/key-bindings.bash" >> ~/.bashrc
elif [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
    echo "source /usr/share/fzf/shell/key-bindings.bash" >> ~/.bashrc
fi

# --- 4. DEPLOY SCRIPTS ---
echo -e "${BLUE}>>> Deploying scripts to $TARGET_DIR...${RESET}"

# Create directory
mkdir -p "$TARGET_DIR"

# ... (Partie existante : copie des scripts)
cp -r scripts/* "$TARGET_DIR/"
chmod +x "$TARGET_DIR"/*.sh

# --- AJOUT ICI ---
echo -e "${BLUE}>>> Copying reference Makefile to ~/Makefile/...${RESET}"
cp Makefile "$HOME/Makefile/Makefile"
# -----------------
echo -e "${GREEN}✅ Installation Complete!${RESET}"
echo -e "--------------------------------------------------------"
echo -e "To use the Makefile in your projects:"
echo -e "1. Copy the 'Makefile' file to your project root."
echo -e "2. Edit SRC and NAME variables."
echo -e "3. Run 'make menu'."
echo -e "--------------------------------------------------------"
echo -e "${YELLOW}Please restart your terminal to enable FZF shortcuts.${RESET}"
# ... (après la copie des scripts et du Makefile template)

echo -e "${BLUE}>>> Creating global 'makefile' command...${RESET}"

# Suppression d'une éventuelle ancienne version
sudo rm -f /usr/local/bin/makefile

# Création du lien symbolique
# Cela permet de taper 'makefile' n'importe où
sudo ln -sf "$HOME/Makefile/scripts/setup.sh" /usr/local/bin/makefile

echo -e "${GREEN}✅ Installation terminée !${RESET}"
echo -e "${CYAN}Usage : tapez makefile dans le terminal et il sera généré :${RESET}"
echo -e "${BOLD}makefile${RESET}"
