#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -z "$FISH_VERSION" ]; then
    PS1='[\u@\h \W]\$ '
fi

if command -v fish &>/dev/null; then
    exec fish
fi

if [ -z "$FISH_VERSION" ]; then
    eval "$(starship init bash)"
fi

[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export PATH=$PATH:$HOME/go/bin
export PATH="$HOME/.symfony5/bin:$PATH"
