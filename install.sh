#!/bin/bash
set -euox pipefail

# Function to check if a package is installed
is_installed() {
    command -v "$1" &>/dev/null
}

# Install package if not already installed
install_package() {
    local package_name="$1"
    local install_cmd="$2"

    if is_installed "$package_name"; then
        echo "$package_name is already installed. Skipping..."
    else
        echo "Installing $package_name..."
        eval "$install_cmd"
    fi
}

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    echo "Detected macOS"
    SYSTEM="Mac"
    INSTALLER="brew install"
    INSTALLER_FD="brew install fd"
    INSTALLER_XZ="brew install xz"
    BUILD_TOOLS=""
elif [[ -f "/etc/os-release" ]] && grep -qi "ubuntu" /etc/os-release; then
    # Ubuntu
    echo "Detected Ubuntu"
    apt update
    SYSTEM="Ubuntu"
    INSTALLER="apt install -y"
    INSTALLER_FD='apt install -y fd-find && mkdir -p ~/.local/bin && ln -sf $(command -v fdfind || echo /usr/bin/fdfind) ~/.local/bin/fd'
    INSTALLER_XZ="apt install -y xz-utils"
    BUILD_TOOLS="build-essential automake pkg-config"
elif [[ -f "/etc/os-release" ]] && grep -qi "centos" /etc/os-release; then
    # CentOS
    echo "Detected CentOS"
    yum update
    SYSTEM="Centos"
    INSTALLER="yum install -y"
    INSTALLER_FD='yum install -y fd-find && mkdir -p ~/.local/bin && ln -sf $(command -v fdfind || echo /usr/bin/fdfind) ~/.local/bin/fd'
    INSTALLER_XZ="yum install -y xz"
    BUILD_TOOLS="gcc gcc-c++ make automake pkgconfig"
else
    echo "Unsupported OS."
    exit 1
fi


# Install build tools (required for compiling zsh and tmux from source)
if [[ -n "$BUILD_TOOLS" ]]; then
    # Check and install each build tool individually
    for tool in $BUILD_TOOLS; do
        # Map package names to their command names
        case "$tool" in
            build-essential)  cmd="gcc" ;;      # build-essential provides gcc
            gcc-c++)          cmd="g++" ;;      # CentOS gcc-c++ package provides g++
            pkg-config)       cmd="pkg-config" ;;
            pkgconfig)        cmd="pkg-config" ;;  # CentOS package name differs
            *)                cmd="$tool" ;;   # Default: use package name as command
        esac

        if is_installed "$cmd"; then
            echo "$tool (command: $cmd) is already installed. Skipping..."
        else
            echo "Installing $tool..."
            eval "$INSTALLER $tool"
        fi
    done
else
    echo "Build tools should already be available on macOS via Xcode Command Line Tools"
fi

# Install necessary packages
install_package "wget" "$INSTALLER wget"
install_package "git" "$INSTALLER git"
install_package "vim" "$INSTALLER vim"
install_package "rg" "$INSTALLER ripgrep"
install_package "fd" "$INSTALLER_FD"
install_package "xz" "$INSTALLER_XZ"
install_package "pigz" "$INSTALLER pigz"



# Ensure HOME is set and export it for the child script
if [[ -z "${HOME:-}" ]]; then
    export HOME="$(eval echo ~${USER:-$(whoami)})"
fi
export HOME
echo "=== install.sh: HOME is set to: $HOME ==="
echo "=== install.sh: Files will be downloaded to: $HOME/downloads ==="

# Get the absolute path of the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Parse command line arguments
INSTALL_ZSH=true
INSTALL_TMUX=true
INSTALL_CONFIG=true

while [[ $# -gt 0 ]]; do
    case "$1" in
        zsh)
            INSTALL_ZSH=true
            INSTALL_TMUX=false
            INSTALL_CONFIG=false
            shift
            ;;
        tmux)
            INSTALL_ZSH=false
            INSTALL_TMUX=true
            INSTALL_CONFIG=true
            shift
            ;;
        all|"")
            INSTALL_ZSH=true
            INSTALL_TMUX=true
            INSTALL_CONFIG=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [zsh|tmux|all]"
            echo "  zsh  - Install only zsh"
            echo "  tmux - Install only tmux"
            echo "  all  - Install everything (default)"
            exit 1
            ;;
    esac
done

# Install zsh from source
if [[ "$INSTALL_ZSH" == true ]]; then
    if ! is_installed "zsh"; then
        if [[ -f ~/.zshrc ]]; then
            echo "~/.zshrc already exists. Backing up..."
            mv ~/.zshrc ~/.zshrc.backup.$(date +%Y.%m.%d.%H%M%S)
        fi
        # Explicitly pass HOME as environment variable to the child script
        HOME="$HOME" bash "$SCRIPT_DIR/zsh/install_zsh.sh"
    fi
fi

# Install tmux from source
if [[ "$INSTALL_TMUX" == true ]]; then
    if ! is_installed "tmux"; then
        if [[ -f ~/.tmux.conf ]]; then
            echo "~/.tmux.conf already exists. Backing up..."
            mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y.%m.%d.%H%M%S)
        fi
        HOME="$HOME" SYSTEM="$SYSTEM" bash "$SCRIPT_DIR/tmux/install_tmux.sh"
    fi
fi

# process tmux config
if [[ "$INSTALL_CONFIG" == true ]]; then
    # Backup and copy tmux config
    if [[ -f ~/.tmux.conf ]]; then
        echo "Backing up existing ~/.tmux.conf..."
        mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y.%m.%d.%H%M%S)
    fi
    cp tmux/.tmux.conf ~/.tmux.conf

    # Backup and copy 3rdparty config
    mkdir -p ~/.config
    if [[ -d ~/.config/3rdparty ]]; then
        echo "Backing up existing ~/.config/3rdparty..."
        mv ~/.config/3rdparty ~/.config/3rdparty.backup.$(date +%Y.%m.%d.%H%M%S)
    fi
    cp -a 3rdparty ~/.config
fi