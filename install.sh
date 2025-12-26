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
    # Debian / Ubuntu / Kali / Epitech Dump
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
else
    echo -e "${RED}Error: Unsupported Package Manager. Please install dependencies manually.${RESET}"
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
