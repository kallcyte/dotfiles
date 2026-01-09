#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH="/home/kall/.config/FlyEnv/alias:/home/kall/.config/FlyEnv/env/php:/home/kall/.config/FlyEnv/env/php/bin:$PATH"
