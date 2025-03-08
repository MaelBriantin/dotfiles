# Setup Script for Package Installation and Configuration

This script automates the installation of essential packages, development tools, gaming utilities, and the setup of Docker and dotfiles.

## Features

- Installs core packages by default (essential utilities and tools).
- Optionally installs development (`--dev`) and gaming (`--gaming`) packages.
- Configures Docker and adds the user to the Docker group when using `--dev` or `--all`.
- Configures the default shell to Zsh if not already set.
- Applies dotfiles using Stow for a consistent configuration across systems.

## Prerequisites

A Linux-based system with a compatible package manager (`pacman`, `apt`, or `dnf`).

## Usage

### Clone the repository and navigate to the directory

```bash
git clone https://MaelBriantin/dotfiles
cd dotfiles
```

## Making the Script Executable

Before running the script, you need to make it executable. You can do this by running the following command:

```bash
chmod +x setup.sh
```

## Run the script

The script can be run with different options to control which packages to install.

### Options

- `--dev`: Installs the development packages and sets up Docker.
- `--gaming`: Installs gaming-related packages.
- `--all`: Installs all packages (core, development, and gaming) and configures Docker.

### Example Usage

For a complete installation (core, development, and gaming), you can run:

```bash
./setup.sh --all
```

If no options are provided, the script will only install the core packages.

## Packages files

- **`pkgs/core.txt`**: Contains the list of core packages that will always be installed.
- **`pkgs/dev.txt`**: Contains the list of packages for development (only installed if `--dev` or `--all` is passed).
- **`pkgs/gaming.txt`**: Contains the list of packages for gaming (only installed if `--gaming` or `--all` is passed).

## Dotfile Management

The script uses **Stow** to apply dotfiles:

- The `dotfiles` folder contain directories for each dotfile configuration (e.g., `zsh`, `nvim`).
- The script will automatically apply the dotfiles from the `dotfiles` directory using Stow.

## Docker Configuration

If you run the script with the `--dev` or `--all` options, Docker will be configured as follows:

- The user will be added to the `docker` group.
- Docker will be enabled and started using `systemctl`.
- If Docker installation fails, a warning will be displayed.

## Troubleshooting

- **Package manager issues**:
    - The script supports `pacman`, `apt`, and `dnf`. Make sure your system uses one of these.
  
- **Docker setup**:
    - If Docker installation or configuration fails, check your system for missing dependencies or issues with Docker installation.

- **Stow issues**:
    - Ensure that your dotfile directories are properly set up in the `dotfiles` folder.
