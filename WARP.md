# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for an EndeavourOS (Arch-based) Linux system running Hyprland (Wayland compositor). The repository manages configuration files for a complete desktop environment setup.

## Architecture

### Core Structure

The repository follows a two-level backup system:
- **Root level**: Shell configurations (`.bashrc`, `.zshrc`)
- **config/**: Application configurations mirroring `~/.config/` structure

### Key Components

**Window Manager & Desktop Environment:**
- **Hyprland** (`config/hypr/hyprland.conf`): Main Wayland compositor configuration
  - Imports theme from `config/hypr/themes/catppuccin.conf`
  - Related configs: `hyprlock.conf` (lock screen), `hypridle.conf` (idle management), `hyprpaper.conf` (wallpaper)
  - Scripts in `config/hypr/scripts/`: `powermenu.sh`, `songdetail.sh`
  
**Status Bar & UI:**
- **Waybar** (`config/waybar/`): Top bar with system info and custom widgets
  - `config`: JSON configuration defining modules (workspaces, clock, system stats, prayer times, media controls)
  - `scripts/`: Custom widget scripts including `prayer-waybar.sh` (Islamic prayer times via go-pray) and `mpris_scroll.sh` (media player control)

**Application Launchers:**
- **Wofi** (`config/wofi/`): Primary application launcher (dmenu-style)
- **Rofi** (`config/rofi/`): Alternative launcher with Catppuccin Mocha theme

**Terminal Emulators:**
- **Alacritty** (`config/alacritty/alacritty.toml`): Primary terminal, imports Catppuccin Mocha theme
- **Ghostty** (`config/ghostty/config`): Alternative terminal with matching configuration

**Religious Tools:**
- **go-pray** (`config/go-pray/config.toml`): Islamic prayer time calculator for Gresik, Indonesia (Kemenag method)
  - Integrated into Waybar via `prayer-waybar.sh` script

**Theming:**
- Consistent **Catppuccin Mocha** theme across all applications
- Primary colors: background `#1e1e2e`, blue accent `#89b4fa`, text `#cdd6f4`
- Font: **JetBrainsMono Nerd Font** used universally

### Backup System

The `backup.sh` script handles synchronization from system to repository:
1. Copies specified folders from `~/.config/` to `config/`
2. Backs up shell configs from `~` to repository root
3. Uses `rm -rf` before copying to ensure clean 1:1 sync
4. Provides git commands reminder for committing changes

**Backed up applications:** hypr, waybar, rofi, wofi, alacritty, wlogout, go-pray, ghostty

## Scripts

The repository includes several utility scripts:

### Installation Scripts
- **install.sh**: Full installation script for new systems
  - Installs all packages (pacman + AUR)
  - Backs up existing configs
  - Applies dotfiles
  - Sets up directories
  - Usage: `./install.sh`

- **apply.sh**: Apply configs only (no package installation)
  - Updates configuration files from repo to system
  - Useful for refreshing configs on existing setup
  - Usage: `./apply.sh`

- **backup.sh**: Backup system configs to repository
  - Copies configs from system to repo
  - Used to save changes made on system
  - Usage: `./backup.sh`

### Package List
- **packages.txt**: Complete list of required packages
  - Pacman packages
  - AUR packages (commented)
  - Organized by category

## Common Commands

### Installation & Setup
```bash
# Fresh installation (new system)
chmod +x install.sh
./install.sh

# Apply configs only (existing setup)
chmod +x apply.sh
./apply.sh
```

### Backup & Sync
```bash
# Backup current system configs to repository
./backup.sh

# After backup, commit and push changes
git add .
git commit -m "Update config"
git push
```

### Apply Configurations
```bash
# Copy individual config folder to system
cp -r config/hypr ~/.config/

# Copy shell config
cp .bashrc ~/

# Reload Hyprland config (from within Hyprland)
hyprctl reload

# Reload Waybar
pkill waybar; waybar &
```

### Hyprland Management
```bash
# Reload Hyprland configuration
hyprctl reload

# View current monitors
hyprctl monitors

# List active windows
hyprctl clients

# Check Hyprland version and build info
hyprctl version
```

### Prayer Times (go-pray)
```bash
# Show next prayer time
go-pray next

# Show full prayer schedule
go-pray calendar

# Configuration location
config/go-pray/config.toml
```

## Key Bindings Reference

Main modifier: `SUPER` (Windows key)

**Core Actions:**
- `SUPER + Return`: Launch terminal (Alacritty)
- `SUPER + Space`: Application launcher (Wofi)
- `SUPER + W`: Kill active window
- `SUPER + F`: Toggle fullscreen
- `SUPER + T`: Toggle floating
- `SUPER + E`: File manager (Thunar)
- `SUPER + L`: Lock screen (hyprlock)
- `SUPER + X`: Power menu
- `SUPER + V`: Clipboard history (cliphist + wofi)

**Window Navigation:**
- `SUPER + Arrow Keys`: Move focus
- `SUPER + SHIFT + Arrow Keys`: Swap windows
- `SUPER + ALT + H/J/K/L`: Resize active window

**Workspaces:**
- `SUPER + [1-9,0]`: Switch to workspace
- `SUPER + SHIFT + [1-9,0]`: Move window to workspace
- `SUPER + Tab`: Next workspace
- `SUPER + SHIFT + Tab`: Previous workspace
- `SUPER + Grave`: Previous workspace (alternative)

**Screenshots:**
- `Print`: Select area → copy to clipboard
- `SUPER + Print`: Fullscreen → save to `~/Pictures/Screenshots/`
- `SUPER + SHIFT + S`: Select area → save to `~/Pictures/Screenshots/`

**Media Controls:**
- `XF86AudioRaiseVolume`/`XF86AudioLowerVolume`: Volume control
- `XF86AudioPlay`/`XF86AudioNext`/`XF86AudioPrev`: Media playback (via playerctl)

## Configuration Guidelines

### Adding New Applications to Backup
Edit `backup.sh` and add folder name to the `folders` array:
```bash
folders=(
    "hypr"
    "waybar"
    # ... existing entries
    "your-new-app"
)
```

### Theme Consistency
When adding new applications, use Catppuccin Mocha colors:
- Background: `#1e1e2e`
- Foreground/Text: `#cdd6f4`
- Blue (primary accent): `#89b4fa`
- Red (urgent): `#f38ba8`
- Green (success): `#a6e3a1`

### Waybar Widget Integration
To add custom Waybar widgets:
1. Create script in `config/waybar/scripts/` (make executable)
2. Add module definition to `config/waybar/config` modules list
3. Configure output format (JSON for rich tooltips, plain text for simple display)
4. Add styling in `config/waybar/style.css`

### Hyprland Configuration Changes
The main `hyprland.conf` imports `themes/catppuccin.conf`. To modify:
- **Keybindings**: Edit directly in `hyprland.conf` (lines 236+)
- **Appearance**: Modify theme file or override in main config
- **Autostart**: Add `exec-once` entries (lines 42-55)
- **Window rules**: Add at bottom of file (lines 366+)

## System Context

- **Distribution**: EndeavourOS (Arch-based)
- **Display Server**: Wayland (Hyprland)
- **Shell**: Bash with Starship prompt
- **Monitor**: HDMI-A-1, 1920x1080@75Hz
- **Location**: Gresik, Indonesia (affects prayer times)
