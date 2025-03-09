#!/bin/bash

# Variables
DIR="$(dirname "$0")"
ALL_PACKAGES=()
YES_MODE=false
DOCKER_SETUP=false
PKG_MANAGER="sudo pacman -Sy --noconfirm"
DOTFILES=("bash" "fish" "nvim" "ghostty" "git")
DOTFILES_DIR="$DIR"

# Import functions
source "$DIR/.functions.sh"

# Exit immediately if a command exits with a non-zero status
set -e

# Add core packages by default
add_packages "pkgs/core.txt"

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --yes|-y)
            YES_MODE=true
            ;;
        --dev|-d)
            add_packages "pkgs/dev.txt"
            DOCKER_SETUP=true  # Docker is required for --dev
            ;;
        --dev-yes|-dy)
            add_packages "pkgs/dev.txt"
            DOCKER_SETUP=true  # Docker is required for --dev
            YES_MODE=true
            ;;
        --full|-f)
            add_packages "pkgs/dev.txt"
            add_packages "pkgs/media.txt"
            add_packages "pkgs/core.txt"
            DOCKER_SETUP=true  # Docker is required for --all
            ;;
        --full-yes|-fy)
            add_packages "pkgs/dev.txt"
            add_packages "pkgs/media.txt"
            add_packages "pkgs/core.txt"
            DOCKER_SETUP=true  # Docker is required for --all
            YES_MODE=true
            ;;
        --help)
            show_help
            ;;
        *)
            print_message error "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Ask user for password
echo "Please enter your password:"
read -s PASSWORD

# Validate sudo access before proceeding
echo $PASSWORD | sudo -S -v 2>/dev/null
if [ $? -ne 0 ]; then
    print_message error "Incorrect password, exiting."
    exit 1
fi

# Update Arch
echo $PASSWORD | sudo -S pacman -Syu --noconfirm

# If no options are passed, install only core packages
if [ ${#ALL_PACKAGES[@]} -eq 0 ]; then
    print_message info "No options provided. Installing only core packages."
    add_packages "pkgs/core.txt"
fi

# Display packages that will be installed
echo -e "\nThe following packages will be installed:"
echo "${ALL_PACKAGES[@]}"
echo ""

# Install selected packages
print_message info "Installing selected packages..."
echo $PASSWORD | sudo -S $PKG_MANAGER "${ALL_PACKAGES[@]}"

print_message success "Package installation completed!"

# Docker setup: Add user to docker group and enable/start service (only if --dev or --all is passed)
if [ "$DOCKER_SETUP" = true ] && command -v docker &>/dev/null; then
    configure_docker
fi

# Install yay if needed
install_yay

# Stow each configuration (assuming corresponding directories exist)
cd "$DOTFILES_DIR"
for dotfile in "${DOTFILES[@]}"; do
    stow "$dotfile" -v --adopt
done
cd "$DIR"

# End of script
echo ""
print_message success "Setup complete!" 
if [ "$DOCKER_SETUP" = true ] && command -v docker &>/dev/null; then
    print_message success "Please log out and log back in to apply Docker group changes."
fi
