#! /bin/bash
set -xe

# Ensure HOME is set
if [[ -z "${HOME:-}" ]]; then
    export HOME="$(eval echo ~${USER:-$(whoami)})"
fi
export HOME

# Debug: Print HOME value at script start
echo "=== install_zsh.sh: HOME is set to: $HOME ==="
echo "=== install_zsh.sh: Current working directory: $(pwd) ==="

NCURSES_INSTALL=ON

install_ncurses() {
    mkdir -p "$HOME/dotfile"
    mkdir -p "$HOME/software"
    if [ ! -f "$HOME/dotfile/ncurses-6.1.tar.gz" ]; then
        wget -c -O "$HOME/dotfile/ncurses-6.1.tar.gz" https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.1.tar.gz --no-check-certificate
    fi
    tar -zxvf "$HOME/dotfile/ncurses-6.1.tar.gz" -C "$HOME/dotfile"

    # install zsh to $HOME/software
    pushd "$HOME/dotfile/ncurses-6.1"
    ./configure --prefix="$HOME/software" CXXFLAGS="-fPIC" CFLAGS="-fPIC" --with-shared && make && make install
    popd 
}

install_zsh() {
    if [ -n "$(cat /etc/shells | grep zsh)" ]; then
        chsh -s $(cat /etc/shells | grep zsh)
    else
        # install zsh from source
        mkdir -p "$HOME/dotfile"
        mkdir -p "$HOME/software"
        if [ ! -f "$HOME/dotfile/zsh.tar.xz" ]; then
            wget -c -O "$HOME/dotfile/zsh.tar.xz" https://sourceforge.net/projects/zsh/files/latest/download --no-check-certificate
        fi
        mkdir -p "$HOME"/dotfile/zsh
        tar -xvf "$HOME/dotfile/zsh.tar.xz" -C "$HOME/dotfile/zsh" --strip-components 1

        # install zsh to $HOME/software
        pushd "$HOME/dotfile/zsh"
        if [[ ${NCURSES_INSTALL} == "ON" ]]; then
            ./configure --prefix="$HOME/software" CPPFLAGS="-I$HOME/software/include -I$HOME/software/include/ncurses" LDFLAGS="-L$HOME/software/lib"
        else
            ./configure --prefix="$HOME/software"
        fi
        make && make install
        popd
        rm -rf "$HOME/dotfile/zsh"

        echo "export PATH=$PATH:$HOME/software/bin" >> "$HOME/.bashrc"
        echo "export LD_LIBRARY_PATH=\"$HOME/software/lib:\$LD_LIBRARY_PATH\"" >> "$HOME/.bashrc"
        echo "✅ 安装完成！请运行: source ~/.bashrc"
    fi
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    fi
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

    # install autosuggestion plugin
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    fi
    # install syntax-highlighting plugin
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    fi

    sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' "$HOME/.zshrc"
}


### main entry point
case "$1" in
    ncurses)
        install_ncurses
        ;;
    zsh)
        install_zsh
        ;;
    oh_my_zsh)
        install_oh_my_zsh
        ;;
    "")
        if [[ ${NCURSES_INSTALL} == "ON" ]]; then
            install_ncurses
        fi
        install_zsh
        install_oh_my_zsh
        echo "You may set http/https proxy to speed up wget process"
        echo "export PATH=$PATH:$HOME/software/bin" >> "$HOME/.bashrc"
        ;;
    *)
        echo "Usage: $0 [ncurses|zsh|oh_my_zsh]"
        exit 1
        ;;
esac

