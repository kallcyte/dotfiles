# Initialize Completion System (MUST BE FIRST)
# This fixes the "command not found: compdef" error
autoload -Uz compinit
compinit

# Enable Powerlevel10k instant prompt (if you use p10k) OR Starship
# We are using Starship for this config:
eval "$(starship init zsh)"

# Antidote Plugin Management
# Checks if the static file exists; if not, bundles it.
source /usr/share/zsh-antidote/antidote.zsh
antidote load

# Basic Zsh Options
setopt HIST_IGNORE_ALL_DUPS  # Don't record dupes in history
setopt SHARE_HISTORY         # Share history between terminals
setopt INC_APPEND_HISTORY    # Write to history immediately, not when shell exits

# Keybindings (Fixes for Arch/terminals)
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
# Bind Ctrl+Left/Right arrow keys for word jumping
bindkey '^[[1;5C' forward-word  # Ctrl+Right (adjust code if necessary)
bindkey '^[[1;5D' backward-word # Ctrl+Left (adjust code if necessary)
# Alternative common codes:
bindkey '^[O5C' forward-word
bindkey '^[O5D' backward-word

# Aliases (The fun part)
alias ll='ls -alF'
alias c='clear'
alias v='nvim'           # Or code/zed
alias gs='git status'
alias cat='bat'          # If you have bat installed (sudo pacman -S bat)

# FZF Integration (If installed: sudo pacman -S fzf)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
