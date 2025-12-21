#!/bin/bash

# Apply Dotfiles Script
# This script only applies configuration files without installing packages
# Useful for updating configs on an existing setup

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Applying Dotfiles Configuration                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}\n"

echo -e "${YELLOW}This will overwrite your current configuration files.${NC}"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cancelled.${NC}"
    exit 1
fi

# Copy config directories
echo -e "\n${BLUE}Copying configuration files...${NC}"
for dir in hypr waybar rofi wofi alacritty mako wlogout go-pray ghostty dunst; do
    if [ -d "$SCRIPT_DIR/config/$dir" ]; then
        mkdir -p "$HOME/.config/$dir"
        cp -r "$SCRIPT_DIR/config/$dir/"* "$HOME/.config/$dir/"
        echo -e "${GREEN}✓ Applied $dir configuration${NC}"
    fi
done

# Copy shell configs
if [ -f "$SCRIPT_DIR/.bashrc" ]; then
    cp "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
    echo -e "${GREEN}✓ Applied .bashrc${NC}"
fi

if [ -f "$SCRIPT_DIR/.zshrc" ]; then
    cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    echo -e "${GREEN}✓ Applied .zshrc${NC}"
fi

# Make scripts executable
chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true

echo -e "\n${GREEN}Configuration files applied successfully!${NC}"
echo -e "${BLUE}To reload:${NC}"
echo -e "  • Hyprland: ${YELLOW}hyprctl reload${NC}"
echo -e "  • Waybar:   ${YELLOW}pkill waybar; waybar &${NC}"
echo -e "  • Shell:    ${YELLOW}source ~/.bashrc${NC}\n"
