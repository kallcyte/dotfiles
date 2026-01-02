# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kall/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(starship init zsh)"
# Bind Ctrl+Left/Right arrow keys for word jumping
bindkey '^[[1;5C' forward-word  # Ctrl+Right (adjust code if necessary)
bindkey '^[[1;5D' backward-word # Ctrl+Left (adjust code if necessary)
# Alternative common codes:
bindkey '^[O5C' forward-word
bindkey '^[O5D' backward-word
