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
    INSTALLER="brew install"
    INSTALLER_FD="brew install fd"
elif [[ -f "/etc/os-release"]] && grep -qi "ubuntu" /etc/os-release; then
    # Ubuntu
    echo "Detected Ubuntu"
    INSTALLER="sudo apt install -y"
    INSTALLER_FD="sudo apt install -y fd-find && ln -s $(which fdfind) ~/.local/bin/fd"
elif [[ -f "/etc/os-release"]] && grep -qi "centos" /etc/os-release; then
    # CentOS
    echo "Detected CentOS"
else
    echo "Unsupported OS."
    exit 1
fi


# Install necessary packages
install_package "rg" "$INSTALLER ripgrep"
install_package "fd" "$INSTALLER_FD"

# Install zsh from source
if [[ -f ~/.zshrc ]]; then
    echo "~/.zshrc already exists. Backing up..."
    mv ~/.zshrc ~/.zshrc.backup.$(date +%Y.%m.%d.%H%M%S)
fi
bash zsh/install_zsh.sh


# Install tmux from source
if [[ -f ~/.tmux.conf ]]; then
    echo "~/.tmux.conf already exists. Backing up..."
    mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y.%m.%d.%H%M%S)
fi
bash tmux/install_tmux.sh

# process tmux config
cp tmux/.tmux.conf ~/.tmux.conf
mkdir -p "~/.config"

cp -a 3rdparty ~/.config