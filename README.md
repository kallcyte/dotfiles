# Dotfiles - EndeavourOS Hyprland Setup

Personal dotfiles for a complete Hyprland desktop environment on EndeavourOS/Arch Linux, featuring the Catppuccin Mocha theme, Waybar with Islamic prayer times integration, and a curated set of Wayland-native applications.

## Features

- **Hyprland** - Dynamic tiling Wayland compositor
- **Waybar** - Customizable status bar with system monitoring and prayer times
- **Catppuccin Mocha** - Consistent theming across all applications
- **go-pray** - Islamic prayer times integration (Gresik, Indonesia)
- **JetBrainsMono Nerd Font** - Universal font across terminal and UI
- **Wofi/Rofi** - Application launchers
- **Alacritty/Ghostty** - Terminal emulators
- **Mako** - Notification daemon

## Quick Start

### Fresh Installation (New System)

For a complete installation with all packages and configurations:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

This will:
- Install all required packages (Hyprland, Waybar, etc.)
- Install AUR helper (yay) if not present
- Install AUR packages (go-pray, themes, etc.)
- Backup existing configurations
- Apply dotfiles
- Set up directories

### Apply Configs Only (Existing Setup)

If you already have packages installed and just want to update configurations:

```bash
cd ~/dotfiles
chmod +x apply.sh
./apply.sh
```

### Manual Installation

1. Install packages from `packages.txt`:
```bash
# Install pacman packages
sudo pacman -S --needed hyprland waybar wofi alacritty mako ...

# Install AUR packages (using yay)
yay -S hyprswitch go-pray-bin catppuccin-gtk-theme-mocha
```

2. Apply configurations:
```bash
./apply.sh
```

## Backup Your Current Setup

Before installing, the scripts automatically create backups at `~/.config_backup_TIMESTAMP/`. You can also manually backup:

```bash
mkdir -p ~/config_backup
cp -r ~/.config/{hypr,waybar,alacritty} ~/config_backup/
cp ~/.bashrc ~/config_backup/
```

## Repository Structure

```
dotfiles/
├── config/              # Application configurations
│   ├── hypr/           # Hyprland (window manager)
│   ├── waybar/         # Status bar
│   ├── alacritty/      # Terminal
│   ├── wofi/           # Launcher
│   ├── rofi/           # Alternative launcher
│   ├── mako/           # Notifications
│   ├── ghostty/        # Alternative terminal
│   ├── go-pray/        # Prayer times
│   ├── dunst/          # Alternative notifications
│   └── wlogout/        # Logout menu
├── .bashrc             # Bash configuration
├── backup.sh           # Backup system → repo
├── install.sh          # Full installation script
├── apply.sh            # Apply configs only
├── packages.txt        # Package list
├── WARP.md            # AI assistant guidance
└── README.md          # This file
```

## Key Bindings

| Keybinding | Action |
|------------|--------|
| `SUPER + Return` | Launch terminal |
| `SUPER + Space` | Application launcher |
| `SUPER + W` | Close window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + T` | Toggle floating |
| `SUPER + E` | File manager |
| `SUPER + L` | Lock screen |
| `SUPER + X` | Power menu |
| `SUPER + V` | Clipboard history |
| `SUPER + [1-9,0]` | Switch workspace |
| `SUPER + SHIFT + [1-9,0]` | Move window to workspace |
| `SUPER + Arrow Keys` | Move focus |
| `SUPER + SHIFT + Arrows` | Swap windows |
| `SUPER + ALT + H/J/K/L` | Resize window |
| `Print` | Screenshot (select area) |
| `SUPER + Print` | Screenshot (fullscreen) |

See `WARP.md` for complete keybinding reference.

## Updating Configurations

### Backup System to Repository

After making changes to your system configs:

```bash
./backup.sh
git add .
git commit -m "Update config"
git push
```

### Pull Updates from Repository

```bash
cd ~/dotfiles
git pull
./apply.sh
```

## Customization

### Change Prayer Location

Edit `~/.config/go-pray/config.toml`:
```toml
city = "YourCity"
country = "YourCountry"
method = "YourMethod"  # e.g., "Kemenag", "MWL", "ISNA"
```

### Change Theme Colors

All configs use Catppuccin Mocha. To change:
- Hyprland: `~/.config/hypr/themes/catppuccin.conf`
- Waybar: `~/.config/waybar/style.css`
- Alacritty: `~/.config/alacritty/catppuccin-mocha.toml`
- Other apps follow the same pattern

### Add Applications to Backup

Edit `backup.sh` and add to the `folders` array:
```bash
folders=(
    "hypr"
    "waybar"
    "your-new-app"
)
```

## Troubleshooting

### Hyprland won't start
- Check logs: `~/.local/share/hyprland/hyprland.log`
- Ensure all packages are installed
- Try: `Hyprland` from TTY

### Waybar not showing
- Reload: `pkill waybar; waybar &`
- Check config: `~/.config/waybar/config`

### Prayer times not working
- Install go-pray: `yay -S go-pray-bin`
- Test: `go-pray next`
- Configure: `~/.config/go-pray/config.toml`

### Scripts not executable
```bash
chmod +x ~/.config/hypr/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh
```

## System Requirements

- **OS**: EndeavourOS, Arch Linux, or Arch-based distro
- **Display**: Wayland-compatible GPU
- **Memory**: 4GB+ RAM recommended
- **Packages**: See `packages.txt`

## Credits

- [Hyprland](https://hyprland.org/) - Dynamic tiling Wayland compositor
- [Catppuccin](https://github.com/catppuccin/catppuccin) - Soothing pastel theme
- [go-pray](https://github.com/hablullah/go-pray) - Islamic prayer times calculator
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) - Font

## License

Personal dotfiles - feel free to use and modify as needed.
