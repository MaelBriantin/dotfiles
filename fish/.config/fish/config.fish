# ---- macOS PATH setup ----
set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin
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
end

# ---- Envman (do not modify) ----
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish

# ---- Symfony ----
set -Ux PATH $HOME/.symfony5/bin $PATH

# ---- FNM (Fast Node Manager) ----
fnm env --use-on-cd | source

