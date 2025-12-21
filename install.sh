#!/bin/bash

# Dotfiles Installation Script
# This script installs all configuration files and required packages for EndeavourOS/Arch-based systems

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Functions
print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running on Arch-based system
check_system() {
    print_header "Checking System Compatibility"
    
    if [ ! -f /etc/arch-release ]; then
        print_error "This script is designed for Arch-based systems (EndeavourOS, Arch Linux, etc.)"
        exit 1
    fi
    
    print_success "Running on Arch-based system"
}

# Install packages
install_packages() {
    print_header "Installing Required Packages"
    
    print_info "This will install Hyprland and all required packages..."
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Package installation skipped"
        return
    fi
    
    print_info "Updating system..."
    sudo pacman -Syu --noconfirm
    
    print_info "Installing core packages..."
    sudo pacman -S --needed --noconfirm \
        hyprland \
        hyprlock \
        hypridle \
        hyprpaper \
        waybar \
        wofi \
        rofi \
        alacritty \
        ghostty \
        mako \
        dunst \
        wlogout \
        thunar \
        grim \
        slurp \
        swappy \
        wl-clipboard \
        cliphist \
        playerctl \
        pavucontrol \
        brightnessctl \
        pamixer \
        network-manager-applet \
        blueman \
        polkit-kde-agent \
        qt6ct \
        starship \
        ttf-jetbrains-mono-nerd \
        xdg-desktop-portal-hyprland \
        udiskie
    
    print_success "Core packages installed"
    
    # Install AUR helper if not present
    if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
        print_info "Installing yay (AUR helper)..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
        print_success "yay installed"
    fi
    
    # Determine which AUR helper to use
    if command -v yay &> /dev/null; then
        AUR_HELPER="yay"
    elif command -v paru &> /dev/null; then
        AUR_HELPER="paru"
    else
        print_warning "No AUR helper found, skipping AUR packages"
        return
    fi
    
    print_info "Installing AUR packages..."
    $AUR_HELPER -S --needed --noconfirm \
        hyprswitch \
        go-pray-bin \
        catppuccin-gtk-theme-mocha \
        qogir-cursor-theme-git \
        hypremoji || print_warning "Some AUR packages failed to install"
    
    print_success "Package installation complete"
}

# Backup existing configs
backup_existing() {
    print_header "Backing Up Existing Configurations"
    
    BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    
    if [ -d "$HOME/.config/hypr" ] || [ -d "$HOME/.config/waybar" ] || [ -f "$HOME/.bashrc" ]; then
        print_info "Creating backup at $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        
        # Backup config directories
        for dir in hypr waybar rofi wofi alacritty mako wlogout go-pray ghostty dunst; do
            if [ -d "$HOME/.config/$dir" ]; then
                cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
                print_success "Backed up ~/.config/$dir"
            fi
        done
        
        # Backup shell configs
        [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$BACKUP_DIR/" && print_success "Backed up .bashrc"
        [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/" && print_success "Backed up .zshrc"
        
        print_success "Backup complete: $BACKUP_DIR"
    else
        print_info "No existing configurations found, skipping backup"
    fi
}

# Install configuration files
install_configs() {
    print_header "Installing Configuration Files"
    
    # Copy config directories
    print_info "Copying configuration files..."
    for dir in hypr waybar rofi wofi alacritty mako wlogout go-pray ghostty dunst; do
        if [ -d "$SCRIPT_DIR/config/$dir" ]; then
            mkdir -p "$HOME/.config/$dir"
            cp -r "$SCRIPT_DIR/config/$dir/"* "$HOME/.config/$dir/"
            print_success "Installed $dir configuration"
        fi
    done
    
    # Copy shell configs
    if [ -f "$SCRIPT_DIR/.bashrc" ]; then
        cp "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
        print_success "Installed .bashrc"
    fi
    
    if [ -f "$SCRIPT_DIR/.zshrc" ]; then
        cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
        print_success "Installed .zshrc"
    fi
    
    # Make scripts executable
    print_info "Making scripts executable..."
    chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
    chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true
    
    print_success "Configuration files installed"
}

# Setup directories
setup_directories() {
    print_header "Setting Up Directories"
    
    mkdir -p "$HOME/Pictures/Screenshots"
    print_success "Created ~/Pictures/Screenshots"
    
    print_success "Directory setup complete"
}

# Configure go-pray
configure_go_pray() {
    print_header "Configuring Prayer Times"
    
    if command -v go-pray &> /dev/null; then
        print_info "go-pray is installed"
        print_info "Current configuration is set for Gresik, Indonesia (Kemenag method)"
        print_info "To change location, edit: ~/.config/go-pray/config.toml"
        print_success "Prayer times configured"
    else
        print_warning "go-pray not found. Install it manually or via AUR: go-pray-bin"
    fi
}

# Post-installation steps
post_install() {
    print_header "Post-Installation Steps"
    
    print_info "Setting up Starship prompt..."
    if ! grep -q "starship init bash" "$HOME/.bashrc"; then
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        print_success "Starship prompt added to .bashrc"
    fi
    
    # Enable services
    print_info "Note: Some services may need to be enabled manually"
    print_info "Hyprland will auto-start most components via hyprland.conf"
    
    print_success "Post-installation complete"
}

# Final message
show_final_message() {
    print_header "Installation Complete!"
    
    echo -e "${GREEN}Your dotfiles have been installed successfully!${NC}\n"
    echo -e "Next steps:"
    echo -e "  1. ${BLUE}Log out and select Hyprland from your display manager${NC}"
    echo -e "  2. ${BLUE}Or start Hyprland manually with: Hyprland${NC}"
    echo -e "  3. ${BLUE}Review WARP.md for key bindings and configuration guide${NC}\n"
    echo -e "Key bindings quick reference:"
    echo -e "  ${YELLOW}SUPER + Return${NC}     - Terminal"
    echo -e "  ${YELLOW}SUPER + Space${NC}      - App Launcher"
    echo -e "  ${YELLOW}SUPER + W${NC}          - Close Window"
    echo -e "  ${YELLOW}SUPER + X${NC}          - Power Menu"
    echo -e "  ${YELLOW}SUPER + L${NC}          - Lock Screen\n"
    echo -e "Configuration location: ${BLUE}~/.config/${NC}"
    echo -e "Backup location (if created): ${BLUE}~/.config_backup_*${NC}\n"
    echo -e "${YELLOW}Note: If you encounter any issues, check the logs and ensure all packages installed correctly.${NC}\n"
}

# Main installation flow
main() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║                                                       ║"
    echo "║     Hyprland Dotfiles Installation Script            ║"
    echo "║     EndeavourOS / Arch Linux                          ║"
    echo "║                                                       ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    print_warning "This script will:"
    echo "  • Install Hyprland and all required packages"
    echo "  • Backup your existing configurations"
    echo "  • Install dotfiles from this repository"
    echo ""
    read -p "Continue with installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Installation cancelled"
        exit 1
    fi
    
    check_system
    install_packages
    backup_existing
    install_configs
    setup_directories
    configure_go_pray
    post_install
    show_final_message
}

# Run main function
main
