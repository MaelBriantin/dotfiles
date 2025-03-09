#!/bin/bash

# Help function
function show_help {
    echo "Usage: $0 [options]"
    echo "Available options:"
    echo "  empty       Install only core packages"
    echo "  --dev, -d   Install development packages and setup docker"
    echo "  --full, -f  Install all packages (core, dev and media) and setup docker"
    echo "  --yes, -y   Automatically accept all prompts (yes mode). You can combine this option with '-f' or '-d' like '-fy' or '-dy'."
    echo "  --help      Show this help message"
    exit 0
}

# Function to print messages with color
print_message() {
    local TYPE=$1
    local MESSAGE=$2
    case $TYPE in
        error)
            echo -e "\033[31m[ERROR] $MESSAGE\033[0m"
            ;;
        warning)
            echo -e "\033[33m[WARNING] $MESSAGE\033[0m"
            ;;
        success)
            echo -e "\033[32m[SUCCESS] $MESSAGE\033[0m"
            ;;
        info)
            echo -e "\033[37m[INFO] $MESSAGE\033[0m"
            ;;
        *)
            echo "$MESSAGE"
            ;;
    esac
}

# Function to add packages from a file
add_packages() {
    if [ -f "$1" ]; then
        ALL_PACKAGES+=($(<"$1"))
    else
        print_message error "The file $1 is missing."
        exit 1
    fi
}

# Function to configure Docker
configure_docker() {
    if command -v docker &>/dev/null; then
        print_message info "Configuring Docker..."
        echo $PASSWORD | sudo -S usermod -aG docker $USER
        
        if command -v systemctl &>/dev/null; then
            echo $PASSWORD | sudo -S systemctl enable --now docker
            print_message success "Docker setup completed!"
        else
            print_message warning "systemctl not found. You may need to start Docker manually."
        fi
    else
        print_message warning "Docker installation failed or is missing."
    fi
}

# Function to install yay (AUR helper)
install_yay() {
    local init_installation=false

    if [ "$YES_MODE" == "true" ]; then
        init_installation=true
    else
        read -p "Do you want to install yay (AUR helper)? [y/N]: " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            init_installation=true
        else
            print_message info "Installation of yay has been skipped."
            return
        fi
    fi

    if [ "$init_installation" == true ]; then
        if ! command -v yay &>/dev/null; then
            print_message info "yay (AUR helper) is not installed. Installing yay..."

            echo $PASSWORD | sudo -S pacman -Sy --needed --noconfirm base-devel git

            rm -rf /tmp/yay-bin
            git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
            cd /tmp/yay-bin || { print_message error "Failed to access /tmp/yay-bin"; exit 1; }

            makepkg -si --noconfirm

            cd - > /dev/null
            rm -rf /tmp/yay-bin
            
            print_message success "yay has been installed successfully!"
        else
            print_message success "yay is already installed."
        fi
    fi
}
