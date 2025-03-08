#!/bin/bash

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

# Function to back up existing dotfiles
backup_dotfile() {
    if [ -e "$1" ]; then
        print_message info "Backing up existing file: $1"
        mv "$1" "$BACKUP_DIR/"
    fi
}
