# ---- macOS PATH setup ----
# set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin
fish_add_path /opt/homebrew/bin

# ---- Interactive shell config ----
if status is-interactive
    set -U fish_greeting

    # ---- Starship ----
    if type -q starship
        starship init fish | source
    end

    # ---- Zoxide ----
    if type -q zoxide
        zoxide init fish | source
    end

    # ---- Emacs ----
    alias emacs="emacsclient -c -a 'emacs'"
    set -gx PATH $HOME/.config/emacs/bin $PATH
end

# ---- Envman (do not modify) ----
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish

# ---- Symfony ----
set -Ux PATH $HOME/.symfony5/bin $PATH

# ---- Bun ----
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# ---- Go ----
set --export PATH $HOME/go/bin $PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ---- Mise ----
# mise activate fish | source

# Added by Antigravity CLI installer
set -gx PATH "/Users/mael/.local/bin" $PATH

# Added by Antigravity IDE
fish_add_path /Users/mael/.antigravity-ide/antigravity-ide/bin

# Hunk (installé via curl hunk.dev/install.sh)
fish_add_path $HOME/.hunk/bin

# pnpm
set -gx PNPM_HOME '/Users/mael/Library/pnpm'
if test "$PATH[1]" != "$PNPM_HOME/bin"
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
