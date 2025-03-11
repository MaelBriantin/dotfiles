if status is-interactive
    # Commands to run in interactive sessions can go here
    set -U fish_greeting
    starship init fish | source
end

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish

# Make Symfony available globally
set -Ux PATH $HOME/.symfony5/bin $PATH
