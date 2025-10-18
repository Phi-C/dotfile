#! /bin/bash
set -xe

NCURSES_INSTALL=ON

install_ncurses() {
    if [ ! -f "ncurses-6.1.tar.gz" ]; then
        wget -q https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.1.tar.gz --no-check-certificate
    fi
    tar -zxvf ncurses-6.1.tar.gz

    # install zsh to $HOME/software
    if [ ! -d "$HOME"/software ]; then
        mkdir -p "$HOME"/software
    fi

    pushd ncurses-6.1
    ./configure --prefix="$HOME/software" CXXFLAGS="-fPIC" CFLAGS="-fPIC"
    make && make install
    popd 
}

install_zsh() {
    if [ -n "$(cat /etc/shells | grep zsh)" ]; then
        chsh -s $(cat /etc/shells | grep zsh)
    else
        # install zsh from source
        if [ ! -f "zsh.tar.xz" ]; then
            wget -q -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download --no-check-certificate
        fi
        mkdir -p zsh
        tar -xvf zsh.tar.xz -C zsh --strip-components 1

        # install zsh to $HOME/software
        if [ ! -d "$HOME"/software ]; then
            mkdir -p "$HOME"/software
        fi

        # configure and install zsh
        pushd zsh
        if [[ ${NCURSES_INSTALL} == "ON" ]]; then
            ./configure --prefix="$HOME/software" CPPFLAGS="-I$HOME/software/include" LDFLAGS="-L$HOME/software/lib"
        else
            ./configure --prefix="$HOME/software"
        fi
        make && make install
        popd
        rm -rf zsh

        echo "export PATH=$PATH:$HOME/software/bin" >> ~/.bashrc
        source ~/.bashrc
    fi
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh 
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    fi

    # install autosuggestion plugin
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi
    # install syntax-highlighting plugin
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi

    sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc
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
    *)
        if [[ ${NCURSES_INSTALL} == "ON" ]]; then
            install_ncurses
        fi
        install_zsh
        install_oh_my_zsh
        echo "You may set http/https proxy to speed up wget process"
        ;;
esac

