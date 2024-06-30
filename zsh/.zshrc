# Import autosuggestions plugin
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Import all plugins in the ~/.zsh/plugins/ directory
for plugin in ~/.zsh/plugins/*.zsh; do
    source $plugin
done

export EDITOR='nvim'

# Enable global use for composer
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

# Init starship prompt
eval "$(starship init zsh)"


# bun completions
[ -s "/home/mael/.bun/_bun" ] && source "/home/mael/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$HOME/bin:$PATH

export BAT_THEME="Catppuccin Mocha"
