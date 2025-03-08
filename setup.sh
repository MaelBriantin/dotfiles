#!/bin/bash

# Import functions
source "$(dirname "$0")/config/functions.sh"

# Import constants
source "$(dirname "$0")/config/constants.sh"

# Exit immediately if a command exits with a non-zero status
set -e

# Ask user for password
echo "Please enter your password:"
read -s PASSWORD

# Validate sudo access before proceeding
echo $PASSWORD | sudo -S -v 2>/dev/null
if [ $? -ne 0 ]; then
    print_message error "Incorrect password, exiting."
    exit 1
fi

# Add core packages by default
add_packages "pkgs/core.txt"

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dev)
            add_packages "pkgs/dev.txt"
            DOCKER_SETUP=true  # Docker is required for --dev
            ;;
        --gaming)
            add_packages "pkgs/gaming.txt"
            ;;
        --all)
            add_packages "pkgs/dev.txt"
            add_packages "pkgs/gaming.txt"
            add_packages "pkgs/core.txt"
            DOCKER_SETUP=true  # Docker is required for --all
            ;;
        *)
            print_message error "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# If no options are passed, install only core packages
if [ ${#ALL_PACKAGES[@]} -eq 0 ]; then
    print_message info "No options provided. Installing only core packages."
    add_packages "pkgs/core.txt"
fi

# Display packages that will be installed
echo -e "\nThe following packages will be installed:"
echo "${ALL_PACKAGES[@]}"
echo ""

# Detect package manager (pacman, apt or dnf)
if command -v pacman &>/dev/null; then
    PKG_MANAGER="sudo pacman -Sy --noconfirm"
elif command -v apt &>/dev/null; then
    PKG_MANAGER="sudo apt update && sudo apt install -y"
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="sudo dnf install -y"
else
    print_message error "No compatible package manager found."
    exit 1
fi

# Install selected packages
print_message info "Installing selected packages..."
echo $PASSWORD | sudo -S $PKG_MANAGER "${ALL_PACKAGES[@]}"

print_message success "Package installation completed!"

# Change default shell to Zsh if not already set
if [[ "$SHELL" != "/bin/zsh" ]]; then
    if command -v chsh &>/dev/null; then
        print_message info "Changing default shell to Zsh..."
        echo $PASSWORD | sudo -S chsh -s $(which zsh)
    else
        print_message warning "'chsh' command not found. You may need to change the shell manually."
    fi
fi

# Docker setup: Add user to docker group and enable/start service (only if --dev or --all is passed)
if [ "$DOCKER_SETUP" = true ] && command -v docker &>/dev/null; then
    print_message success "Configuring Docker..."
    
    # Add user to the docker group
    echo $PASSWORD | sudo -S usermod -aG docker $USER
    
    # Enable and start Docker service
    if command -v systemctl &>/dev/null; then
        echo $PASSWORD | sudo -S systemctl enable --now docker
    else
        print_message warning "systemctl not found. You may need to start Docker manually."
    fi
else
    if [ "$DOCKER_SETUP" = true ]; then
        print_message warning "Docker installation failed or not found."
    fi
fi

# Apply dotfiles using Stow

# Check if the dotfiles directory exists
if [ -d "$DOTFILES_DIR" ]; then
    print_message success "Setting up dotfiles using Stow..."
    cd "$DOTFILES_DIR" || { print_message error "Error: Unable to access $DOTFILES_DIR"; exit 1; }

    
    # Stow each configuration (assuming zsh and nvim directories exist in the sources folder)
    stow zsh -v --adopt
    stow nvim -v --adopt
    stow ghostty -v --adopt
else
    print_message warning "$DOTFILES_DIR not found. Skipping dotfiles setup."
fi

echo ""
print_message success "Setup complete!" 
if [ "$DOCKER_SETUP" = true ] && command -v docker &>/dev/null; then
    print_message success "Please log out and log back in to apply Docker group changes."
fi
