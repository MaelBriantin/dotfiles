#!/bin/bash

# Dotfiles folder name
DOTFILES_DIR="$(dirname "$0")/dotfiles"

# Array to hold packages to install
ALL_PACKAGES=()

# Flag to control Docker setup
DOCKER_SETUP=false

# Backup directory name for existing dotfiles
BACKUP_DIR="$(dirname "$0")/backup"
